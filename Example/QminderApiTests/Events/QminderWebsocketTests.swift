//
//  QminderWebsocketTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 29/01/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

import QminderAPI

class QminderWebsocketTests: XCTestCase {
  /// Qminder API client
  var qminderAPI: QminderAPI!
  var events: QminderEvents!
  
  /// Location ID
  let locationId: Int = Int(ProcessInfo.processInfo.environment["QMINDER_LOCATION_ID"]!)!
  
  var parameters: [String: Any] = [:]
  var eventsResponses: [Ticket] = []
  
  override func setUp() {
    super.setUp()
    
    if let apiKey = ProcessInfo.processInfo.environment["QMINDER_API_KEY"] {
      qminderAPI = QminderAPI(apiKey: apiKey)
      events = QminderEvents(apiKey: apiKey, serverAddress: "ws://localhost:8889")
    }
    
    parameters = ["location": locationId]
    
    subscribeToTicket(.ticketCreated, parameters: parameters)
    subscribeToTicket(.ticketCalled, parameters: parameters)
    subscribeToTicket(.ticketRecalled, parameters: parameters)
    subscribeToTicket(.ticketCancelled, parameters: parameters)
    subscribeToTicket(.ticketServed, parameters: parameters)
    subscribeToTicket(.ticketChanged, parameters: parameters)
  }
  
  override func tearDown() {
    super.tearDown()
    
    events.closeConnection()
  }
  
  fileprivate func subscribeToTicket(_ ticketEvent: QminderEvent, parameters: [String: Any]) {
    events.subscribe(toTicketEvent: ticketEvent, parameters: parameters, callback: { result in
      switch result {
      case .success(let ticket):
        print(ticket)
        
        self.eventsResponses.append(ticket)
      default:
        break
      }
    })
  }
  
  func testWebsocketEvents() {
    // Test run #1
    // Ticket created
    addTestTimer { ticket in
      ticket.status == .new && ticket.id == "23853943" && ticket.firstName == "Name" && ticket.lastName == "Surname"
    }
    
    // Ticket edited
    addTestTimer { ticket in
      ticket.id == "23853943"  && ticket.firstName == "Name2" && ticket.lastName == "Surname2"
    }
    
    // Ticket deleted
    addTestTimer { ticket in
      ticket.status == .cancelledByClerk &&
        ticket.id == "23853943" &&
        ticket.firstName == "Name2" &&
        ticket.lastName == "Surname2"
    }
    
    // Test run #2
    // Ticket created
    addTestTimer { ticket in
      ticket.status == .new && ticket.id == "23856820"  && ticket.firstName == "Name1" && ticket.lastName == "Surname1"
    }
    
    // Ticket edited
    addTestTimer { ticket in
      ticket.status == .new && ticket.id == "23856820" && ticket.firstName == "Name" && ticket.lastName == "Surname"
    }
    
    ticketCalled()
    ticketRecalled()
    ticketServed()
    
    waitForExpectations(timeout: 30, handler: nil)
  }
  
  fileprivate func ticketCalled() {
    addTestTimer { ticket in
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      guard let date = formatter.date(from: "2017-02-06T13:36:11Z") else {
        return false
      }
      
      guard let calledDate = ticket.calledDate else {
        return false
      }
      
      return ticket.id == "23856820" &&
        ticket.status == .called &&
        ticket.firstName == "Name" &&
        ticket.lastName == "Surname" &&
        date.compare(calledDate) == ComparisonResult.orderedSame
    }
  }
  
  fileprivate func ticketRecalled() {
    addTestTimer { ticket in
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      guard let date = formatter.date(from: "2017-02-06T13:36:21Z") else {
        return false
      }
      
      guard let calledDate = ticket.calledDate else {
        return false
      }
      
      return ticket.id == "23856820" &&
        ticket.status == .called &&
        ticket.firstName == "Name" &&
        ticket.lastName == "Surname" &&
        date.compare(calledDate) == ComparisonResult.orderedSame
    }
  }
  
  fileprivate func ticketServed() {
    addTestTimer { ticket in
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      guard let date = formatter.date(from: "2017-02-06T13:36:36Z") else {
        return false
      }
      
      guard let servedDate = ticket.served?.date else {
        return false
      }
      
      return ticket.id == "23856820" &&
        ticket.status == .served &&
        ticket.firstName == "Name" &&
        ticket.lastName == "Surname" &&
        date.compare(servedDate) == ComparisonResult.orderedSame
    }
  }
  
  /**
   Add test timer as expectation
   
   - Parameters:
     - description: Expecation description
     - pollInterval: Poll interval
     - checker: Checker block
  */
  func addTestTimer(description: String = #function + String(#line),
                    pollInterval: TimeInterval = 1.0, checker: @escaping (Ticket) -> Bool) {
    
    let expectation = self.expectation(description: description)
    
    Timer.scheduledTimer(withTimeInterval: pollInterval, repeats: true) { timer in
      if self.eventsResponses.contains(where: { checker($0) }) {
        expectation.fulfill()
        timer.invalidate()
      }
    }
  }
}
