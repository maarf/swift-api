//
//  QminderWebsocketsController.swift
//  App
//
//  Created by Kristaps Grinbergs on 29/09/2017.
//

import Foundation
import Vapor

public class QminderWebsocketController {

  /// Websocket object
  var ws: WebSocket!

  /// Dictionary which keeps what already has been subscribed to
  var subscriptions: [QminderEvent: String] = [:]

  /// What events we need to start tests?
  let events: Set<QminderEvent> = [.ticketCreated, .ticketCalled,
                                .ticketRecalled, .ticketServed,
                                .ticketCancelled, .ticketChanged,
                                .overviewMonitorChange, .linesChanged
  ]

  /**
    Initialize function

    - Parameters:
      - drop: Droplet
  */
  public init(drop: Droplet) {
    drop.socket("events", handler: socketHandler)
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
      print("RECEIVED: \(text)")

      guard text != "PING", let data = text.data(using: .utf8) else {
        return
      }

      let message = try JSONDecoder().decode(WebsocketMessage.self, from: data)
      self.subscriptions[message.eventType] = message.id

      if self.events == Set(self.subscriptions.keys) {
        self.executeTests()
      }
    }

    ws.onClose = { ws, code, reason, clean in
      print("Closed connection")
    }
  }

  /**
    Execute Websocket mocking tests
  */
  fileprivate func executeTests() {
    print("Start tests")

    var firstTicketData: [String: Any] = [
      "data": [
        "status": "NEW",
        "source": "MANUAL",
        "firstName": "Name",
        "lastName": "Surname",
        "line": 62633,
        "id": "23853943",
        "created" : [
          "date" : "2017-02-06T12:35:29Z"
        ]
      ]
    ]

    var secondTicketData: [String: Any] = [
      "data": [
        "status": "NEW",
        "source": "MANUAL",
        "firstName": "Name1",
        "lastName": "Surname1",
        "line": 62633,
        "id": "23856820",
        "created": [
          "date": "2017-02-06T13:35:31Z"
        ]
      ]
    ]

    Async.waterfall(1, [
      { callback, counter in
        self.send(.ticketCreated, counter, firstTicketData) {
          callback(2)
        }
      },
      { callback, counter in
        
        let data = [
          "firstName": "Name2",
          "lastName": "Surname2"
        ]
        firstTicketData.changeTicketData(data)

        self.send(.ticketChanged, counter, firstTicketData) {
          callback(3)
        }
      },
      { callback, counter in
        firstTicketData.changeTicketData(["status": "CANCELLED_BY_CLERK"])

        self.send(.ticketCancelled, counter, firstTicketData) {
          callback(4)
        }
      },
      { callback, counter in
        self.send(.ticketCreated, counter, secondTicketData) {
          callback(5)
        }
      },
      { callback, counter in
        let data = [
          "firstName": "Name",
          "lastName": "Surname"
        ]
        secondTicketData.changeTicketData(data)
        
        self.send(.ticketChanged, counter, secondTicketData) {
          callback(6)
        }
      },
      { callback, counter in
        
        let data: [String: Any] = [
          "status": "CALLED",
          "interactions": [
            ["start": "2017-02-06T13:36:11Z",
             "line": 62633,
             "desk": 1,
             "user": 891
            ]
          ]
        ]
        secondTicketData.changeTicketData(data)
        
        self.send(.ticketCalled, counter, secondTicketData) {
          callback(7)
        }
      },
      { callback, counter in
        
        let data: [String: Any] = [
          "status": "CALLED",
          "interactions": [
            ["start": "2017-02-06T13:36:21Z",
             "line": 62633,
             "desk": 1,
             "user": 891
            ]
          ]
        ]
        secondTicketData.changeTicketData(data)
        
        self.send(.ticketRecalled, counter, secondTicketData) {
          callback(8)
        }
      },
      { callback, counter in
        let data: [String: Any] = [
          "status": "SERVED",
          "served": [
            "date": "2017-02-06T13:36:36Z"
          ]
        ]
        secondTicketData.changeTicketData(data)
        
        self.send(.ticketServed, counter, secondTicketData) {
          callback(9)
        }
      },
      { callback, counter in
        self.send(.overviewMonitorChange, counter, ["data": []]) {
          callback(10)
        }
      },
      { callback, counter in
        let data: [String: Any] = [
          "data": [
            "lines": [
              [
                "id": 1,
                "name": "Business",
                "disabled": false
              ],
              [
                "id": 2,
                "name": "Private",
                "disabled": false
              ],
              [
                "id": 3,
                "name": "Information",
                "disabled": false
              ]
            ]
          ]
        ]
        
        self.send(.linesChanged, counter, data) {
          callback(11)
        }
      }

    ], end: { _, _ in
      self.subscriptions = [:]
      print("Tests executed")
    })
  }

  /**
    Send message to Websocket

    - Parameters:
      - message: Message to send
      - callback: Execute callback after it's done
  */
  fileprivate func send(_ eventType: QminderEvent, _ counter: Any?, _ data: [String: Any], _ callback: () -> ()) {

    var data = data
    data["subscriptionId"] = subscriptions[eventType]!.description
    data["messageId"] = counter as! Int

    sleep(UInt32(3))

    let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
    let jsonString = String(data: jsonData, encoding: .utf8)
    
    print(jsonString!)

    try! ws.send(jsonString!)
    
    callback()
  }
}
