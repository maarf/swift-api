//
//  QminderWebsocketsController.swift
//  App
//
//  Created by Kristaps Grinbergs on 29/09/2017.
//

import Foundation
import Vapor

public class QminderWebsocketController {
  
  /// Droplet object
  var droplet : Droplet
  
  /// Websocket object
  var ws: WebSocket!
  
  /// Dictionary which keeps what already has been subscribed to
  var subscriptions: [QminderEvent: String] = [:]
  
  /// What events we need to start tests?
  let events: [QminderEvent] = [.ticketCreated, .ticketCalled, .ticketRecalled, .ticketServed, .ticketCancelled, .ticketChanged]
  
  /**
    Initialize function
   
    - Parameters:
      - drop: Droplet
  */
  public init(drop: Droplet) {
    droplet = drop
    
    // Sert up to /events for websocket
    droplet.socket("events", handler: socketHandler)
  }
  
  /**
    Websocket handler
   
    - Parameters:
      - request: Request
      - ws: Websocket
  */
  func socketHandler(request: Request, ws: WebSocket) throws {
    
    self.ws = ws
    
    ws.onText = { ws, text in
      
      print("RECIVED: \(text)")
      
      guard text != "PING" else { return }
      
      guard let data = text.data(using: .utf8) else { return }
      
      let message = try JSONDecoder().decode(WebsocketMessage.self, from: data)
      
      // Let's add to needed subscriptions dictionary
      self.subscriptions[message.eventType] = message.id
      
      // If we did get all needed events let's start tests
      if Array(self.subscriptions.keys).contains(array: self.events) {
        self.executeTests()
      }
    }
    
    ws.onClose = { ws, code, reason, clean in
      print("Closed.")
    }
  }
  
  /**
    Execute Websocket mocking tests tests
  */
  fileprivate func executeTests() {
    print("Start tests")
    
    Async.waterfall(1, [
      { callback, value in
        self.send(message: """
          {
          "subscriptionId": "\(String(describing: self.subscriptions[QminderEvent.ticketCreated]!))",
          "messageId" : \(String(describing: value!)),
          "data" : {
          "status" : "NEW",
          "source" : "MANUAL",
          "firstName" : "Name",
          "lastName" : "Surname",
          "line" : 62633,
          "id" : "23853943",
          "created" : {
          "date" : "2017-02-06T12:35:29Z"
          }
          }
          }
          """, {callback(2)})
      },
      { callback, value in
        self.send(message: """
          {
          "subscriptionId": "\(String(describing: self.subscriptions[QminderEvent.ticketChanged]!))",
          "messageId" : \(String(describing: value!)),
          "data" : {
          "status" : "NEW",
          "source" : "MANUAL",
          "firstName" : "Name2",
          "lastName" : "Surname2",
          "line" : 62633,
          "id" : "23853943",
          "created" : {
          "date" : "2017-02-06T12:35:29Z"
          }
          }
          }
          """, {callback(3)})
      },
      { callback, value in
        self.send(message: """
          {
          "subscriptionId": "\(String(describing: self.subscriptions[QminderEvent.ticketCancelled]!))",
          "messageId" : \(String(describing: value!)),
          "data" : {
          "status" : "CANCELLED_BY_CLERK",
          "source" : "MANUAL",
          "firstName" : "Name2",
          "lastName" : "Surname2",
          "line" : 62633,
          "id" : "23853943",
          "created" : {
          "date" : "2017-02-06T12:35:29Z"
          }
          }
          }
          """, {callback(4)})
      },
      { callback, value in
        self.send(message: """
          {
          "subscriptionId": "\(String(describing: self.subscriptions[QminderEvent.ticketCreated]!))",
          "messageId" : \(String(describing: value!)),
          "data" : {
          "status" : "NEW",
          "source" : "MANUAL",
          "firstName" : "Name1",
          "lastName" : "Surname1",
          "line" : 62633,
          "id" : "23856820",
          "created" : {
          "date" : "2017-02-06T13:35:31Z"
          }
          }
          }
          """, {callback(5)})
      },
      { callback, value in
        self.send(message: """
          {
          "subscriptionId": "\(String(describing: self.subscriptions[QminderEvent.ticketChanged]!))",
          "messageId" : \(String(describing: value!)),
          "data" : {
          "status" : "NEW",
          "source" : "MANUAL",
          "firstName" : "Name",
          "lastName" : "Surname",
          "line" : 62633,
          "id" : "23856820",
          "created" : {
          "date" : "2017-02-06T13:35:31Z"
          }
          }
          }
          """, {callback(6)})
      },
      { callback, value in
        self.send(message: """
          {
          "subscriptionId": "\(String(describing: self.subscriptions[QminderEvent.ticketCalled]!))",
          "messageId" : \(String(describing: value!)),
          "data" : {
          "status" : "CALLED",
          "source" : "MANUAL",
          "firstName" : "Name",
          "lastName" : "Surname",
          "line" : 62633,
          "id" : "23856820",
          "created" : {
          "date" : "2017-02-06T13:35:31Z"
          },
          "interactions": [{
            "start": "2017-02-06T13:36:11Z",
            "line": 62633,
            "desk": 1,
            "user": 891
          }]
          }
          }
          """, {callback(7)})
      },
      { callback, value in
        self.send(message: """
          {
            "subscriptionId": "\(String(describing: self.subscriptions[QminderEvent.ticketRecalled]!))",
            "messageId" : \(String(describing: value!)),
            "data" : {
              "status": "CALLED",
              "source": "MANUAL",
              "firstName": "Name",
              "lastName": "Surname",
              "line": 62633,
              "id": "23856820",
              "created" : {
                "date" : "2017-02-06T13:35:31Z"
              },
              "interactions": [{
                "start": "2017-02-06T13:36:11Z",
                "line": 62633,
                "desk": 1,
                "user": 891
              }]
            }
          }
          """, {callback(8)})
      },
      { callback, value in
        self.send(message: """
          {
          "subscriptionId": "\(String(describing: self.subscriptions[QminderEvent.ticketServed]!))",
          "messageId" : \(String(describing: value!)),
          "data" : {
          "status" : "SERVED",
          "source" : "MANUAL",
          "firstName" : "Name",
          "lastName" : "Surname",
          "line" : 62633,
          "id" : "23856820",
          "created" : {
          "date" : "2017-02-06T13:35:31Z"
          },
          "interactions": [{
            "start": "2017-02-06T13:36:11Z",
            "line": 62633,
            "desk": 1,
            "user": 891
          }],
          "served" : {
          "date" : "2017-02-06T13:36:36Z"
          }
          }
          }
          """, {callback(9)})
      }
      ],
      end: {error, result in
        self.subscriptions = [:]
        print("Tests executed")
      }
    )
  }
  
  /**
    Send message to Websocket
   
    - Parameters:
      - message: Message to send
      - callback: Execute callback after it's done
  */
  fileprivate func send(message: String, _ callback: () -> ()) {
    // Let's sleep for a while
    sleep(UInt32(3))
    
    try! ws.send(message)
    
    callback()
  }
}

extension Array where Element: Equatable {
  func contains(array: [Element]) -> Bool {
    for item in array {
      if !self.contains(item) { return false }
    }
    return true
  }
}

public class Async {
  class func waterfall(_ initialValue: Any? = nil,_ chain:[(@escaping (Any?) -> (), Any?) throws -> ()],end: @escaping (Error?, Any?) -> () ) {
    guard let function = chain.first else {
      end(nil, initialValue)
      return
    }
    do {
      try function({ (newResult: Any?) in  waterfall(newResult, Array(chain.dropFirst()), end: end) }, initialValue)
    }
    catch let error {
      end(error, nil)
    }
  }
}
