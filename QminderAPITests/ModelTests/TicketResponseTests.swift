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
  
  func testTicketResponsable() {
    let subScriptionId = String(Int.random)
    let messageId = Int.random
    let ticketId = String(Int.random)
    let firstName = String.random
    let lastName = String.random
    let ticketCreated = Date.random
    let lineId = Int.random
    
    let ticketResponseData: [String: Any] = [
      "subscriptionId": subScriptionId,
      "messageId": messageId,
      "data": [
        "status": "NEW",
        "source": "MANUAL",
        "firstName": firstName,
        "created": ["date": ticketCreated.format(.withMilliseconds)],
        "id": ticketId,
        "line": lineId,
        "lastName": lastName
      ]
    ]
    let ticketResponse = try? ticketResponseData.decodeAs(TicketEventResponse.self,
                                                          decoder: JSONDecoder.withMilliseconds)
    
    XCTAssertEqual(ticketResponse?.subscriptionId, subScriptionId)
    XCTAssertEqual(ticketResponse?.messageId, messageId)
    
    guard let ticket = ticketResponse?.data else {
      XCTFail("Can't parse data to ticket")
      return
    }
    
    XCTAssertEqual(ticket.id, ticketId)
    XCTAssertEqual(ticket.source, .manual)
    XCTAssertEqual(ticket.status, .new)
    XCTAssertEqual(ticket.firstName, firstName)
    XCTAssertEqual(ticket.lastName, lastName)
    XCTAssertEqual(ticket.line, lineId)
    XCTAssertEqual(ticket.createdDate, ticketCreated)
  }
}
