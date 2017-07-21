//
//  Events.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 28/10/2016.
//
//

import Foundation

import SwiftyJSON
import Starscream
import RxSwift


/**
  QminderEvents delagate methods
*/
public protocol QminderEventsDelegate {
  
  /**
    Called when connected to Websocket
  */
  func onConnected()
  
  /**
    Called when disconnected from Websocket
    
    - Parameter error: Error why it got disconnected
  */
  func onDisconnected(error:NSError?)
  
}

/// Qminder Events class to work with Websockets API
public class QminderEvents : WebSocketDelegate {

  /// Singleton shared instance
  public static let sharedInstance = QminderEvents()

  /// Class delegate
  public var delegate:QminderEventsDelegate?
  
  /// Qminder close code
  private let websocketReservedCloseCode = UInt16(1099)
  
  
  /**
    Callback type when subscrubing to evenets
   
    - Parameters:
      - data: JSON data
      - error: Error if exists
  */
  public typealias CallbackType = (_ data:[String: Any]?, _ error:NSError?) -> Void
  
  /// Websocket message
  struct WebsocketMessage {
  
    /// Unique subscribtion ID
    var subscriptionId:String
    
    /// String message what should be sent to Websocket
    var messageToSend:String
    
    /// Callback block
    var callback:CallbackType
  }
  
  /// Message history to hold sent messages to Websocket
  var messageHistory = [String]()
  
  /// Message queue to hold not sent messages to Websocket
  var messageQueue = [WebsocketMessage]()
  
  /// Callback map to call specific block when data is received from Websocket
  public var callbackMap = [String:CallbackType]()
  
  /// Is currently connection being opened (Boolean)
  private var openingConnection = false
  
  /// Is connection closed
  private var connectionClosed = false
  
  /// Websocket object
  private var socket:WebSocket!
  
  /// Dispose bag
  private var disposeBag = DisposeBag()
  
  
  /**
    Private init for singleton approach
  */
  private init() {}
  
  /**
    Initialization function. Initializes Websocket object and sets Websocket library delegate to self.
    
    - Parameters:
      - apiKey: Qminder API key
      - serverAddress: Optional server address (used for tests)
    
    - Returns: Creates Qminder Events client
   
  */
  public func setup(apiKey:String, serverAddress:String="wss://api.qminder.com") {
    self.socket = WebSocket(url: URL(string: "\(serverAddress)/events?rest-api-key=\(apiKey)")!)
    self.socket?.delegate = self
    
    // Ping server each 30 seconds
    Observable<Int>.interval(RxTimeInterval(3), scheduler: MainScheduler.instance)
      .startWith(-1)
      .filter({_ in self.socket.isConnected })
      .subscribe(onNext: {sec in
        self.socket.write(ping: "PING".data(using: .utf8)!)
      })
      .addDisposableTo(disposeBag)
  }
  
  /**
    Open websocket
  */
  public func openSocket() {
    if !openingConnection {
      print("openSocket")
      openingConnection = true
      connectionClosed = false
      self.socket.connect()
    }
  }
  
  /**
    Reopen websocket
  */
  public func reOpenSocket() {
    if !self.socket.isConnected {
      openSocket()
    }
  }
  
  /**
    Close websocket connection
  */
  public func closeConnection() {
    if self.socket.isConnected {
      // Remove messages from history
      messageHistory.removeAll()
      messageQueue.removeAll()
      
      self.connectionClosed = true
      self.socket.disconnect(closeCode: websocketReservedCloseCode)
    }
  }
  
  /**
    Subscribe to event
    
    - Parameters:
      - eventName: Event name to subscribe
      - parameters: Dictionary of parameters
      - callback: Callback executed when response got from Websocket
  */
  public func subscribe(eventName:String, parameters:Dictionary<String, Any>, callback:@escaping CallbackType) {
    
    var parameters = parameters
    let subscriptionId = self.createRandomId()
    
    parameters["id"] = subscriptionId
    parameters["subscribe"] = eventName
    
    let json = JSON(parameters)
    
    if let messageToSend = json.rawString() {
      
      if self.socket.isConnected {
        sendMessage(subscriptionId: subscriptionId, messageToSend: messageToSend, callback: callback);
        
        messageHistory.append(messageToSend);
      } else {
        messageQueue.append(WebsocketMessage(subscriptionId:subscriptionId, messageToSend: messageToSend, callback: callback))
        
        if !openingConnection {
          openSocket()
        }
      }
    }
  }
  
  
  // MARK: - Websocket delegate methods
  /**
    Delegate methods when websocket did connect
    
    - Parameter socket: Websocket object
  */
  public func websocketDidConnect(socket: WebSocket) {
    print("Connection opened")

    openingConnection = false
    
    for message in messageHistory {
      socket.write(string: message)
    }
    
    //send message queue
    while messageQueue.count > 0 {
      let queueItem:WebsocketMessage = messageQueue.removeFirst()
      
      sendMessage(subscriptionId: queueItem.subscriptionId, messageToSend: queueItem.messageToSend, callback: queueItem.callback)
      messageHistory.append(queueItem.messageToSend)
    }
    
    delegate?.onConnected()
  }
  
  /**
    Delegate method when Websocket did disconnect
    
    - Parameters:
      - socket: Websocket object
      - error: Error why Websocket disconnected
  */
  public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
  
    openingConnection = false
    
    Observable<Int>.timer(RxTimeInterval(5), scheduler: MainScheduler.instance)
      .skipWhile({_ in self.connectionClosed })
      .filter({_ in
        
        // if there is error at all
        guard let err = error else {
          return true
        }
        
        // don't reopen if going away normally
        return UInt16(err.code) != self.websocketReservedCloseCode
      })
      // do it onlu if disconnected
      .filter({ _ in !self.socket.isConnected })
      .subscribe(onNext: {_ in
        print("Auto reopen Socket")
        self.openSocket()
      })
      .addDisposableTo(disposeBag)
  
    delegate?.onDisconnected(error: error)
  }
  
  /**
    Delegate function when Websocket received message
    
    - Parameters:
      - socket: Websocket object
      - text: Received text
  */
  public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
    guard let dataFromString = text.data(using: .utf8) else {
      print("Can't parse to data \(text)")
      return
    }
    let json = JSON(data: dataFromString)
    
    print(json)
    
    if let callback:CallbackType = callbackMap[json["subscriptionId"].stringValue] {
      callback(json["data"].dictionaryObject, nil)
    }
  }

  /**
    Delegate function when Websocket received data
    
    - Parameters:
      - socket: Websocket object
      - data: Received data
  */
  public func websocketDidReceiveData(socket: WebSocket, data: Data) {
    print(data)
  }
  
  func websocketDidReceivePong(socket: WebSocket, data: Data?) {
    print("Got pong! Maybe some data: \(String(describing: data))")
  }
  
  
  // MARK: - Additional methods
  /**
    Send message to Websocket
    
    - Parameters:
      - subscriptionId: Unique subscription ID
      - messageToSend: Message to send to Websocket
      - callback: Callback block when response is received
  */
  func sendMessage(subscriptionId:String, messageToSend:String, callback:@escaping CallbackType) {
    self.callbackMap[subscriptionId] = callback
    self.socket.write(string: messageToSend)
  }

  /**
    Create random string for subscription ID
   
    - Returns: String random ID
  */
  private func createRandomId() -> String {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

    let randomString : NSMutableString = NSMutableString(capacity: 30)

    for _ in 0..<30 {
      let length = UInt32 (letters.length)
      let rand = arc4random_uniform(length)
      randomString.appendFormat("%C", letters.character(at: Int(rand)))
    }

    return randomString as String
  }
  
}
