//
//  TicketResponseTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 28/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

import QminderAPI

class TicketResponseTests: ModelTests {
  
  var ticketResponseData: [String: Any] = [
    "subscriptionId": "1",
    "messageId": 2,
    "data": [
      "status": "NEW",
      "source": "MANUAL",
      "firstName": "Name",
      "created": ["date": "2017-02-06T12:35:29.123Z"],
      "id": "999",
      "line": 333,
      "lastName": "Surname"
    ]
  ]
  
  func testTicketResponsable() {
    let jsonData = try? JSONSerialization.data(withJSONObject: ticketResponseData, options: [])
    let ticketResponse = try? JSONDecoder.withMilliseconds.decode(TicketEventResponse.self, from: jsonData!)
    
    XCTAssertEqual(ticketResponse?.subscriptionId, "1")
    XCTAssertEqual(ticketResponse?.messageId, 2)
    
    guard let ticket = ticketResponse?.data else {
      XCTFail("Can't parse data to ticket")
      return
    }
    
    XCTAssertEqual(ticket.id, "999")
    XCTAssertEqual(ticket.source, .manual)
    XCTAssertEqual(ticket.status, .new)
    XCTAssertEqual(ticket.firstName, "Name")
    XCTAssertEqual(ticket.lastName, "Surname")
    XCTAssertEqual(ticket.line, 333)
    XCTAssertEqual(ticket.createdDate, dateISO8601MillisecondsFormatter.date(from: "2017-02-06T12:35:29.123Z"))
  }
}
