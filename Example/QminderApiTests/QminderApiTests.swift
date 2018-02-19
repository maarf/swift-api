//
//  QminderApiTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 04/11/2016.
//  Copyright © 2016 Qminder. All rights reserved.
//

import XCTest


import QminderAPI

/// Qminder API tests
class QminderApiTests: XCTestCase {
  
  /// Qminder API client
  var qminderAPI: QminderAPI!
  
  /// Events
  var events: QminderEvents!
  
  /// Location ID
  let locationId:Int = Int(ProcessInfo.processInfo.environment["QMINDER_LOCATION_ID"]!)!
  
  /// Line ID
  let lineId:Int = Int(ProcessInfo.processInfo.environment["QMINDER_LINE_ID"]!)!
  
  override func setUp() {
    super.setUp()
    
    if let apiKey = ProcessInfo.processInfo.environment["QMINDER_API_KEY"] {
      qminderAPI = QminderAPI(apiKey: apiKey)
    }
  }
  
  //MARK: - Location tests
  
  func testLocationsList() {
    var locations: [Location]?
    var location: Location?
    
    wait { expectation in
      qminderAPI.getLocationsList() { result in
        switch result {
        case let .success(value):
          locations = value
          location = locations?.first
          
          expectation.fulfill()
        case .failure(_):
          XCTFail()
        }
      }
    }
    
    XCTAssertNotNil(locations)
    
    XCTAssertNotNil(location)
    XCTAssertNotNil(location?.id)
    XCTAssertNotNil(location?.name)
    XCTAssertNotNil(location?.latitude)
    XCTAssertNotNil(location?.longitude)
  }
  
  func testLocationDetails() {
    var location: Location?
    
    wait { expectation in
      qminderAPI.getLocationDetails(locationId: locationId) { result in
        switch result {
        case let .success(value):
          location = value
          
          expectation.fulfill()
        case .failure(_):
          XCTFail()
        }
      }
    }
    
    XCTAssertNotNil(location)
    
    XCTAssertNotNil(location?.id)
    XCTAssertNotNil(location?.name)
    XCTAssertNotNil(location?.latitude)
    XCTAssertNotNil(location?.longitude)
  }
  
  func testLinesList() {
    var lines: [Line]?
    var line: Line?
    
    wait { expectation in
      qminderAPI.getLocationLines(locationId: locationId) { result in
        switch result {
        case let .success(value):
          lines = value
          line = lines?.first
          
          expectation.fulfill()
        case .failure(_):
          XCTFail()
        }
      }
    }
    
    XCTAssertNotNil(lines)
    
    XCTAssertNotNil(line)
    XCTAssertNotNil(line?.id)
    XCTAssertNotNil(line?.name)
  }
  
  func testUsersList() {
    var users: Array<User>?
    var user: User?
    
    wait { expectation in
      qminderAPI.getLocationUsers(locationId: locationId) { result in
        switch result {
        case let .success(value):
          users = value
          user = users?.first
          
          expectation.fulfill()
        case .failure(_):
          XCTFail()
        }
      }
    }
    
    XCTAssertNotNil(users)
    
    XCTAssertNotNil(user)
    XCTAssertNotNil(user?.id)
    XCTAssertNotNil(user?.firstName)
    XCTAssertNotNil(user?.lastName)
    XCTAssertNotNil(user?.email)
  }
  
  func testDesksList() {
    var desks: [Desk]?
    var desk: Desk?
    
    wait { expectation in
      qminderAPI.getLocationDesks(locationId: locationId) { result in
        switch result {
        case let .success(value):
          desks = value
          desk = desks?.first
          
          expectation.fulfill()
        case .failure(_):
          XCTFail()
        }
      }
    }
    
    XCTAssertNotNil(desks)
    
    XCTAssertNotNil(desk)
    XCTAssertNotNil(desk?.id)
    XCTAssertNotNil(desk?.name)
  }
  
  
  //MARK: - Line tests
  
  func testLineDetails() {
    var details:Line?
    
    wait { expectation in
      qminderAPI.getLineDetails(lineId: lineId) { result in
        switch result {
        case let .success(value):
          details = value
          
          expectation.fulfill()
        case .failure(_):
          XCTFail()
        }
      }
    }
    
    XCTAssertNotNil(details)
    XCTAssertNotNil(details?.id)
    XCTAssertNotNil(details?.name)
    XCTAssertNotNil(details?.location)
  }
  
  
  //MARK: - Ticket tests
  func testSearchTickets() {
    var tickets: [Ticket]?
    var ticket: Ticket?
    
    wait { expectation in
      qminderAPI.searchTickets(locationId: locationId, limit: 10) { result in
        switch result {
        case let .success(value):
          tickets = value
          ticket = tickets?.first
          
          expectation.fulfill()
        case .failure(_):
          XCTFail()
        }
      }
    }

    XCTAssertNotNil(tickets)
    
    XCTAssertNotNil(ticket)
    XCTAssertNotNil(ticket?.id)
    XCTAssertNotNil(ticket?.source)
    XCTAssertNotNil(ticket?.line)
    
    guard let ticketID = ticket?.id else {
      XCTFail()
      return
    }
    
    ticketDetails(ticketID: ticketID)
  }
  
  func testSearchTicketsWithLineID() {
    var tickets: [Ticket]?
    
    wait { expectation in
      qminderAPI.searchTickets(locationId: locationId, lineId: [lineId], limit: 10) { result in
        switch result {
        case let .success(value):
          tickets = value
          
          expectation.fulfill()
        case .failure(_):
          XCTFail()
        }
      }
    }
    
    XCTAssertNotNil(tickets)
  }
  
  func testSearchTicketsStatus() {
    var tickets: [Ticket]?
    
    wait { expectation in
      qminderAPI.searchTickets(locationId: locationId, status: [.new, .called, .cancelled, .cancelledByClerk, .noShow, .served], limit: 10) { result in
        switch result {
        case let .success(value):
          tickets = value
          
          expectation.fulfill()
        case .failure(_):
          XCTFail()
        }
      }
    }
    
    XCTAssertNotNil(tickets)
  }
  
  func ticketDetails(ticketID: String) {
    var ticket: Ticket?
    
    wait { expectation in
      qminderAPI.getTicketDetails(ticketId: ticketID) { result in
        switch result {
        case let .success(value):
          ticket = value
          
          expectation.fulfill()
        case .failure(_):
          XCTFail()
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

  
  //MARK: - Devices
  func testPairingCodeSecret() {
    var code: String?
    var secret: String?
    
    wait { expectation in
      qminderAPI.getPairingCodeAndSecret { result in
        switch result {
        case let .success(value):
          code = value.code
          secret = value.secret
          
          expectation.fulfill()
        case .failure(_):
          XCTFail()
        }
      }
    }
    
    XCTAssertNotNil(code)
    XCTAssertFalse((code?.isEmpty)!)
    
    XCTAssertNotNil(secret)
    XCTAssertFalse((secret?.isEmpty)!)
  }
  
  func testTVDetails() {
    var device: TVDevice?
    var e: Error?
    
    wait { expectation in
      qminderAPI.tvDetails(id: 666) { result in
        switch result {
        case let .success(value):
          device = value
        case let .failure(error):
          e = error
        }
        
        expectation.fulfill()
      }
    }
    
    XCTAssertNil(device)
    XCTAssertNotNil(e)
  }
  
  func testSendHeartbeat() {
    var e: Error?
    
    wait { expectation in
      qminderAPI.tvHeartbeat(id: 666, metadata: ["foo": "bar"]) { result in
        switch result {
        case .success(_):
          XCTFail()
        case let .failure(error):
          e = error
        }
        
        expectation.fulfill()
      }
    }
    
    XCTAssertNotNil(e)
  }
  
}
