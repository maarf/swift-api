//
//  TicketsAPITests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 27/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

@testable import QminderAPI

class TicketsAPITests: QminderAPITests {
  func testSearchTickets() {
    var tickets: [Ticket]?
    var ticket: Ticket?
    
    wait { expectation in
      qminderAPI.searchTickets(locationId: locationId, limit: 10) { result in
        
        XCTAssertTrue(Thread.isMainThread)
        
        switch result {
        case let .success(value):
          tickets = value
          ticket = tickets?.first
          
          expectation.fulfill()
        case .failure:
          XCTFail("Can't search tickets")
        }
      }
    }
    
    XCTAssertNotNil(tickets)
    
    XCTAssertNotNil(ticket)
    XCTAssertNotNil(ticket?.id)
    XCTAssertNotNil(ticket?.source)
    XCTAssertNotNil(ticket?.line)
    
    guard let ticketID = ticket?.id else {
      XCTFail("Can't get ticket")
      return
    }
    
    ticketDetails(ticketID: ticketID)
  }
  
  func testSearchTicketsWithLineID() {
    var tickets: [Ticket]?
    
    wait { expectation in
      qminderAPI.searchTickets(locationId: locationId, lineId: [lineId], limit: 10) { result in
        
        XCTAssertTrue(Thread.isMainThread)
        
        switch result {
        case let .success(value):
          tickets = value
          
          expectation.fulfill()
        case .failure:
          XCTFail("Can't search tickets with line ID")
        }
      }
    }
    
    XCTAssertNotNil(tickets)
  }
  
  func testSearchTicketsStatus() {
    var tickets: [Ticket]?
    
    wait { expectation in
      qminderAPI.searchTickets(locationId: locationId,
                               status: [.new, .called, .cancelledByClerk, .noShow, .served],
                               limit: 10, responseScope: ["INTERACTIONS"]) { result in
                                
        XCTAssertTrue(Thread.isMainThread)
                                
        switch result {
        case let .success(value):
          tickets = value
          
          expectation.fulfill()
        case .failure:
          XCTFail("Can't search tickets with status")
        }
      }
    }
    
    XCTAssertNotNil(tickets)
  }
  
  func ticketDetails(ticketID: String) {
    var ticket: Ticket?
    
    wait { expectation in
      qminderAPI.getTicketDetails(ticketId: ticketID) { result in
        
        XCTAssertTrue(Thread.isMainThread)
        
        switch result {
        case let .success(value):
          ticket = value
          
          expectation.fulfill()
        case .failure:
          XCTFail("Can't get ticket details")
        }
      }
    }
    
    XCTAssertNotNil(ticket)
    XCTAssertNotNil(ticket?.id)
    XCTAssertNotNil(ticket?.source)
    XCTAssertNotNil(ticket?.status)
    XCTAssertNotNil(ticket?.line)
    XCTAssertNotNil(ticket?.created)
  }
}
