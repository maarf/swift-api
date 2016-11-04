//
//  Events.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 28/10/2016.
//
//

import Foundation
import UIKit

import SwiftyJSON
import Starscream


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

  /// Class delegate
  public var delegate:QminderEventsDelegate?
  
  
  /**
    Callback type when subscrubing to evenets
   
    - Parameters:
      - data: JSON data
      - error: Error if exists
  */
  public typealias CallbackType = (_ data:JSON?, _ error:NSError?) -> Void
  
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
  
  /// Retried connections to open socket
  private var socketRetriedConnections = 0
  
  /// Websocket object
  private var socket:WebSocket
  
  
  /// Ping timer
  private var pingTimer = Timer()
  
  /// Auto reopen timer
  private var autoReopenTimer = Timer()
  
  
  /**
    Initialization function. Initializes Websocket object and sets Websocket library delegate to self.
    
    - Parameter apiKey: Qminder API key
  */
  public init(apiKey:String) {
    self.socket = WebSocket(url: URL(string: "wss://api.qminderapp.com/events?rest-api-key=\(apiKey)")!)
    self.socket.delegate = self
  }
  
  /**
    Open websocket
  */
  public func openSocket() {
    print("openSocket")
    
    openingConnection = true
    
    if autoReopenTimer.isValid {
      autoReopenTimer.invalidate()
    }
    
    self.socket.connect()
  }
  
  /**
    Subscribe to event
    
    - Parameters:
      - eventName: Event name to subscribe
      - parameters: Dictionary of parameters
      - callback: Callback executed when response got from Websocket
  */
  public func subscribe(eventName:String, parameters:NSMutableDictionary, callback:@escaping CallbackType) {
  
    let subscriptionId = self.createRandomId()
    
    parameters.setValue(subscriptionId, forKey: "id")
    parameters.setValue(eventName, forKey: "subscribe")
    
    var json = JSON(parameters)
    
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
    socketRetriedConnections = 0
    
    for message in messageHistory {
      socket.write(string: message)
    }
    
    //send message queue
    while messageQueue.count > 0 {
      var queueItem:WebsocketMessage = messageQueue.removeFirst()
      
      sendMessage(subscriptionId: queueItem.subscriptionId, messageToSend: queueItem.messageToSend, callback: queueItem.callback)
      messageHistory.append(queueItem.messageToSend)
    }
    
    // set up ping interval
    self.pingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
      (timer) in
        if self.socket.isConnected {
          self.socket.write(ping: "PING".data(using: .utf8)!)
        }
    })
    
    delegate?.onConnected()
  }
  
  /**
    Delegate method when Websocket did disconnect
    
    - Parameters:
      - socket: Websocket object
      - error: Error why Websocket disconnected
  */
  public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
    self.pingTimer.invalidate()
    
    print(error)
    
    var timeoutMult = floor(Double(socketRetriedConnections / 10))
    var newTimeout = min(5 + timeoutMult * 1, 6)
    print("Connection closed, Trying to reconnect in \(newTimeout) seconds")
    
    if autoReopenTimer.isValid {
      autoReopenTimer.invalidate()
    }
    
    autoReopenTimer = Timer.scheduledTimer(withTimeInterval: newTimeout, repeats: false, block: {
      (timer) in
        print("autoReopenTimer")
        self.openSocket()
    })
    
    socketRetriedConnections += 1
    
    delegate?.onDisconnected(error: error)
    
    //try to reconnect
  }
  
  /**
    Delegate function when Websocket received message
    
    - Parameters:
      - socket: Websocket object
      - text: Received text
  */
  public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
    if var t = text.removingPercentEncoding {
      var json = JSON.parse(text)
      
      if var callback:CallbackType = callbackMap[json["subscriptionId"].stringValue] {
        callback(json["data"], nil)
      }
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
