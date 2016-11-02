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


// Delegate methods
public protocol QminderEventsDelegate {
  
  func onConnected()
  func onDisconnected(error:NSError?)
  
}


public class QminderEvents : WebSocketDelegate {

  public var delegate:QminderEventsDelegate?
  
  public typealias CallbackType = (_ data:JSON?, _ error:NSError?) -> Void
  
  struct WebsocketMessage {
    var subscriptionId:String
    var messageToSend:String
    var callback:CallbackType
  }
  
  var messageHistory = [String]()
  var messageQueue = [WebsocketMessage]()
  public var callbackMap = [String:CallbackType]()
  
  private var openingConnection = false
  private var socketRetriedConnections = 0
  private var socket:WebSocket
  
  private var pingTimer = Timer()
  private var autoReopenTimer = Timer()
  
  
  public init(apiKey:String) {
    self.socket = WebSocket(url: URL(string: "wss://api.qminderapp.com/events?rest-api-key=\(apiKey)")!)
    self.socket.delegate = self
  }
  
  // open websocket
  public func openSocket() {
    print("openSocket")
    
    openingConnection = true
    
    if autoReopenTimer.isValid {
      autoReopenTimer.invalidate()
    }
    
    self.socket.connect()
  }
  
  // subscribe to event
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

  public func websocketDidConnect(socket: WebSocket) {
    print("Connection opened")

    openingConnection = false
    socketRetriedConnections = 0
    
    for message in messageHistory {
      socket.write(string: message)
    }
    
    //send message queue
    while messageQueue.count > 0 {
      var websocketMessage:WebsocketMessage = messageQueue.removeFirst()
      socket.write(string: websocketMessage.messageToSend)
      callbackMap[websocketMessage.subscriptionId] = websocketMessage.callback
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
  
  public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
    if var t = text.removingPercentEncoding {
      var json = JSON.parse(text)
      
      if var callback:CallbackType = callbackMap[json["subscriptionId"].stringValue] {
        callback(json["data"], nil)
      }
    }
  }

  public func websocketDidReceiveData(socket: WebSocket, data: Data) {
    print(data)
  }
  
  
  // MARK: - Additional methods
  
  func sendMessage(subscriptionId:String, messageToSend:String, callback:@escaping CallbackType) {
    self.callbackMap[subscriptionId] = callback
    self.socket.write(string: messageToSend)
  }

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
