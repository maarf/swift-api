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
  let locationId:Int = Int(ProcessInfo.processInfo.environment["QMINDER_LOCATION_ID"]!)!
  
  var parameters: [String: Any] = [:]
  var eventsResponses: [Ticket] = []
  
  override func setUp() {
    if let apiKey = ProcessInfo.processInfo.environment["QMINDER_API_KEY"] {
      qminderAPI = QminderAPI(apiKey: apiKey)
      events = QminderEvents(apiKey: apiKey, serverAddress: "ws://localhost:8889")
    }
    
    parameters = ["location": locationId]
    
    events.subscribe(toTicketEvent: .ticketCreated, parameters: parameters, callback: { result in
      switch result {
      case .success(let ticket):
        print(ticket)
        
        self.eventsResponses.append(ticket)
      default:
        break
      }
    })
    
    events.subscribe(toTicketEvent: .ticketCalled, parameters: parameters, callback: { result in
      switch result {
      case .success(let ticket):
        print(ticket)
        
        self.eventsResponses.append(ticket)
      default:
        break
      }
    })
    
    events.subscribe(toTicketEvent: .ticketRecalled, parameters: parameters, callback: { result in
      switch result {
      case .success(let ticket):
        print(ticket)
        
        self.eventsResponses.append(ticket)
      default:
        break
      }
    })
    
    events.subscribe(toTicketEvent: .ticketCancelled, parameters: parameters, callback: { result in
      switch result {
      case .success(let ticket):
        print(ticket)
        
        self.eventsResponses.append(ticket)
      default:
        break
      }
    })
    
    events.subscribe(toTicketEvent: .ticketServed, parameters: parameters, callback: { result in
      switch result {
      case .success(let ticket):
        print(ticket)
        
        self.eventsResponses.append(ticket)
      default:
        break
      }
    })
    
    events.subscribe(toTicketEvent: .ticketChanged, parameters: parameters, callback: { result in
      switch result {
      case .success(let ticket):
        print(ticket)
        
        self.eventsResponses.append(ticket)
      default:
        break
      }
    })
    
    super.setUp()
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
      ticket.status == .cancelledByClerk && ticket.id == "23853943" && ticket.firstName == "Name2" && ticket.lastName == "Surname2"
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
    
    // Ticket called
    addTestTimer { ticket in
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      guard let date = formatter.date(from: "2017-02-06T13:36:11Z") else {
        return false
      }
      
      guard let calledDate = ticket.calledDate else {
        return false
      }
      
      return ticket.id == "23856820" && ticket.status == .called && ticket.firstName == "Name" && ticket.lastName == "Surname" && date.compare(calledDate) == ComparisonResult.orderedSame
    }
    
    // Ticket re-called
    addTestTimer { ticket in
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      guard let date = formatter.date(from: "2017-02-06T13:36:21Z") else {
        return false
      }
      
      guard let calledDate = ticket.calledDate else {
        return false
      }
      
      return ticket.id == "23856820" && ticket.status == .called && ticket.firstName == "Name" && ticket.lastName == "Surname" && date.compare(calledDate) == ComparisonResult.orderedSame
    }
    
    // Ticket served
    addTestTimer { ticket in
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      guard let date = formatter.date(from: "2017-02-06T13:36:36Z") else {
        return false
      }
      
      guard let servedDate = ticket.served?.date else {
        return false
      }
      
      return ticket.id == "23856820" && ticket.status == .served && ticket.firstName == "Name" && ticket.lastName == "Surname" && date.compare(servedDate) == ComparisonResult.orderedSame
    }
    
    waitForExpectations(timeout: 30, handler: nil)
  }
  
  /**
   Add test timer as expectation
   
   - Parameters:
     - description: Expecation description
     - pollInterval: Poll interval
     - checker: Checker block
  */
  func addTestTimer(description: String = #function + String(#line), pollInterval: TimeInterval = 1.0, checker: @escaping (Ticket) -> Bool) {
    let expectation = self.expectation(description: description)
    
    Timer.scheduledTimer(withTimeInterval: pollInterval, repeats: true) { timer in
      if self.eventsResponses.contains(where: { checker($0) }) {
        expectation.fulfill()
        timer.invalidate()
      }
    }
  }
}
