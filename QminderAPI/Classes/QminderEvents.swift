//
//  Events.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 28/10/2016.
//
//

import Foundation

import Starscream

/// Qminder Event type
public enum QminderEvent: String {
  /// Ticket created
  case ticketCreated = "TICKET_CREATED"
  
  /// Ticket called
  case ticketCalled = "TICKET_CALLED"
  
  /// Ticke recalled
  case ticketRecalled = "TICKET_RECALLED"
  
  /// Ticket cancelled
  case ticketCancelled = "TICKET_CANCELLED"
  
  /// Ticket served
  case ticketServed = "TICKET_SERVED"
  
  /// Ticket changed
  case ticketChanged = "TICKET_CHANGED"
  
  /// Overview monitor change
  case overviewMonitorChange = "OVERVIEW_MONITOR_CHANGE"
}

/// Qminder Event error
public enum QminderEventError: Error {
  
  /// Simple error
  case error(Error)
  
  /// Parsing error
  case parse
}

/// Qminder Event result
public enum QminderEventResult {
  /// Ticket response
  case ticket(Ticket)
  
  /// Device response
  case device(TVDevice)
  
  /// Error
  case failure(QminderEventError)
}

/// Protocol to conform to event response
public protocol EventResponsable {
  associatedtype Data
  
  /// Subscription ID
  var subscriptionId: String { get }
  
  /// Message ID
  var messageId: Int { get }
  
  /// Cata event containts
  var data: Data { get }
}

/// Ticket response container
struct TicketResponse: EventResponsable, Codable {
  typealias Data = Ticket
  
  var subscriptionId: String
  var messageId: Int
  var data: Data
}

/// TV device response container
struct DeviceResponse: EventResponsable, Codable {
  typealias Data = TVDevice
  
  var subscriptionId: String
  var messageId: Int
  var data: Data
}

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
  func onDisconnected(error:Error?)
  
}

/// Qminder Events works with Qminder Websockets
public class QminderEvents : WebSocketDelegate {
  
  /// Singleton shared instance
  public static let sharedInstance = QminderEvents()

  /// Class delegate
  public var delegate:QminderEventsDelegate?
  
  /// Qminder close code
  fileprivate let websocketReservedCloseCode = UInt16(1099)
  
  /// JSON decoder with milliseconds
  fileprivate let jsonDecoderWithMilliseconds = JSONDecoder.withMilliseconds()
  
  /**
    Callback type when subscrubing to evenets
   
    - Parameters:
      - data: JSON data
      - error: Error if exists
  */
  public typealias CallbackType = (QminderEventResult) -> Void
  
  /// Websocket message
  fileprivate struct WebsocketMessage {
  
    /// Unique subscribtion ID
    var subscriptionId: String
    
    var eventType: QminderEvent
    
    /// String message what should be sent to Websocket
    var messageToSend: String
    
    /// Callback block
    var callback: CallbackType
  }
  
  /// Message history to hold sent messages to Websocket
  fileprivate var messageHistory = [String]()
  
  /// Message queue to hold not sent messages to Websocket
  fileprivate var messageQueue = [WebsocketMessage]()
  
  /// Callback map type
  fileprivate typealias CallbackMap = (callback: CallbackType, eventType: QminderEvent)
    
  /// Callback map to call specific block when data is received from Websocket
  fileprivate var callbackMap = [String:CallbackMap]()
  
  /// Is currently connection being opened (Boolean)
  fileprivate var openingConnection = false
  
  /// Is connection closed
  fileprivate var connectionClosed = false
  
  /// Websocket object
  fileprivate var socket:WebSocket!
  
  
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
    Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true, block: {timer in
      if self.socket.isConnected {
        self.socket.write(ping: "PING".data(using: .utf8)!)
      }
    })
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
  public func subscribe(event eventType: QminderEvent, parameters: [String: Any], callback: @escaping CallbackType) {
    
    var parameters = parameters
    let subscriptionId = String.random(length: 30)
    
    parameters["id"] = subscriptionId
    parameters["subscribe"] = eventType.rawValue
    
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
      
      guard let message = String(data: jsonData, encoding: .utf8) else {
        callback(QminderEventResult.failure(QminderEventError.parse))
        return
      }
      
      if self.socket.isConnected {
        sendMessage(subscriptionId: subscriptionId, eventType: eventType, messageToSend: message, callback: callback);
        
        messageHistory.append(message)
      } else {
        messageQueue.append(WebsocketMessage(subscriptionId:subscriptionId, eventType: eventType, messageToSend: message, callback: callback))
        
        if !openingConnection {
          openSocket()
        }
      }
      
    } catch {
      callback(QminderEventResult.failure(QminderEventError.parse))
    }
  }
  
  
  // MARK: - Websocket delegate methods
  /**
    Delegate methods when websocket did connect
    
    - Parameter socket: Websocket object
  */
  public func websocketDidConnect(socket: WebSocketClient) {
    print("Connection opened")

    openingConnection = false
    
    for message in messageHistory {
      socket.write(string: message)
    }
    
    //send message queue
    while messageQueue.count > 0 {
      let queueItem:WebsocketMessage = messageQueue.removeFirst()
      
      sendMessage(subscriptionId: queueItem.subscriptionId, eventType: queueItem.eventType, messageToSend: queueItem.messageToSend, callback: queueItem.callback)
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
  public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
    
    openingConnection = false
    
    Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: {timer in
        
      // If is disconnected
      if self.connectionClosed || self.socket.isConnected {
        timer.invalidate()
        return
      }
      
      // Check if there is an error
      guard let error = error as NSError? else {
        timer.invalidate()
        return
      }
      
      
      // Don't reopen if going away normally
      if UInt16(error.code) == self.websocketReservedCloseCode {
        timer.invalidate()
        return
      }
      
      // Reopen socket
      self.openSocket()
    })
    
    delegate?.onDisconnected(error: error)
  }
  
  /**
    Delegate function when Websocket received message
    
    - Parameters:
      - socket: Websocket object
      - text: Received text
  */
  public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
    
    guard let data = text.data(using: .utf8) else { return }
    
    do {
      guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
      
      guard let subscriptionId = json["subscriptionId"] as? String else { return }
      
      guard let callbackMap = callbackMap[subscriptionId] else { return }
      
      switch callbackMap.eventType {
        case .ticketCalled, .ticketCancelled, .ticketCreated, .ticketServed, .ticketChanged, .ticketRecalled:

          guard let ticket = try? self.jsonDecoderWithMilliseconds.decode(TicketResponse.self, from: data).data else {
            return
          }
        
          callbackMap.callback(QminderEventResult.ticket(ticket))
        
        case .overviewMonitorChange:
          guard let device = try? self.jsonDecoderWithMilliseconds.decode(DeviceResponse.self, from: data).data else {
            return
          }
          
          callbackMap.callback(QminderEventResult.device(device))
      }
    } catch {
      print("Error deserializing JSON")
    }
  }

  /**
    Delegate function when Websocket received data
    
    - Parameters:
      - socket: Websocket object
      - data: Received data
  */
  public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
    print(data)
  }
  
  /**
    Did receive PONG
   
    - Parameters:
      - socket: Websocket
      - data: Data received
  */
  public func websocketDidReceivePong(socket: WebSocketClient, data: Data?) {
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
  private func sendMessage(subscriptionId:String, eventType: QminderEvent, messageToSend:String, callback:@escaping CallbackType) {
    self.callbackMap[subscriptionId] = CallbackMap(callback: callback, eventType: eventType)
    self.socket.write(string: messageToSend)
  }
  
}
