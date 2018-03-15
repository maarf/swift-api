//
//  TicketModelTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 19/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

import QminderAPI

class TicketModelTests: ModelTests {
  
  var ticketData: [String: Any] = [
    "status": "NEW",
    "source": "MANUAL",
    "firstName": "Name",
    "created": ["date": "2017-02-06T12:35:29.123Z"],
    "id": "999",
    "line": 333,
    "lastName": "Surname"
  ]
  
  func testTicketWithoutMilliseconds() {
    let createdDateString = "2017-02-06T12:35:29Z"
    ticketData["created"] = ["date": createdDateString]
    let ticket = decodeToTicket()
    
    XCTAssertEqual(ticket?.id, "999")
    XCTAssertEqual(ticket?.source, .manual)
    XCTAssertEqual(ticket?.status, .new)
    XCTAssertEqual(ticket?.firstName, "Name")
    XCTAssertEqual(ticket?.lastName, "Surname")
    XCTAssertEqual(ticket?.line, 333)
    XCTAssertEqual(ticket?.createdDate, dateISO8601Formatter.date(from: createdDateString))
  }
  
  func testTicketWithMilliseconds() {
    let createdDateString = "2017-02-06T12:35:29.123Z"
    ticketData["created"] = ["date": createdDateString]
    let ticket = decodeToTicket()
    
    XCTAssertEqual(ticket?.createdDate, dateISO8601MillisecondsFormatter.date(from: createdDateString))
  }
  
  func testOrderAfterWithoutMilliseconds() {
    let orderAfterDateString = "2017-02-06T12:35:29Z"
    ticketData["orderAfter"] = orderAfterDateString
    ticketData["created"] = ["date": "2017-02-06T12:35:29Z"]
    let ticket = decodeToTicket()
    
    XCTAssertNotNil(ticket?.orderAfter)
    XCTAssertEqual(ticket?.orderAfter, dateISO8601Formatter.date(from: orderAfterDateString))
  }
  
  func testOrderAfterWithMilliseconds() {
    let orderAfterDateString = "2017-02-06T12:35:29.123Z"
    ticketData["orderAfter"] = orderAfterDateString
    let ticket = decodeToTicket()
    
    XCTAssertNotNil(ticket?.orderAfter)
    XCTAssertEqual(ticket?.orderAfter, dateISO8601MillisecondsFormatter.date(from: orderAfterDateString))
  }
  
  func testCalledDataUserDesk() {
    let calledDateString = "2017-02-06T12:35:29Z"
    ticketData["interactions"] = [
      ["start": calledDateString,
       "line": 62633,
       "desk": 1,
       "user": 444
      ]
    ]
    let ticket = decodeToTicket()
    
    XCTAssertNotNil(ticket?.calledDate)
    XCTAssertEqual(ticket?.calledDate, dateISO8601Formatter.date(from: calledDateString))
    XCTAssertEqual(ticket?.calledUserID, 444)
    XCTAssertEqual(ticket?.calledDeskID, 1)
  }
  
  func testServedDate() {
    let servedDateString = "2017-02-06T12:35:29Z"
    ticketData["served"] = ["date": servedDateString]
    let ticket = decodeToTicket()
    
    XCTAssertNotNil(ticket?.servedDate)
    XCTAssertEqual(ticket?.servedDate, dateISO8601Formatter.date(from: servedDateString))
  }
  
  func testLabels() {
    ticketData["labels"] = [["color": "#000000", "value": "Test"]]
    let ticket = decodeToTicket()
    
    XCTAssertNotNil(ticket?.labels)
    
    guard let labels = ticket?.labels else {
      XCTFail("Can't get ticket labels")
      return
    }
    
    XCTAssertTrue(labels.contains(where: {
      $0.color == "#000000" && $0.value == "Test"
    }))
  }
  
  func testExtraFields() {
    ticketData["extra"] = [["title": "Title", "value": "Test", "url": "http://www.google.com"]]
    let ticket = decodeToTicket()
    
    XCTAssertNotNil(ticket?.extra)
    
    guard let extra = ticket?.extra else {
      XCTFail("Can't get ticket extra data")
      return
    }
    
    XCTAssertTrue(extra.contains(where: {
      $0.title == "Title" && $0.value == "Test" && $0.url == "http://www.google.com"
    }))
  }
  
  func testInteractions() {
    ticketData["interactions"] = [
      ["start": "2018-01-29T12:55:46Z",
       "end": "2018-01-29T12:55:51Z",
       "line": 62633,
       "desk": 6202,
       "user": 891
      ]
    ]
    let ticket = decodeToTicket()
    
    XCTAssertNotNil(ticket?.interactions)
    
    guard let interaction = ticket?.interactions?.first else {
      XCTFail("Can't get ticket interactions")
      return
    }
    
    XCTAssertEqual(interaction.start, dateISO8601Formatter.date(from: "2018-01-29T12:55:46Z"))
    XCTAssertEqual(interaction.end, dateISO8601Formatter.date(from: "2018-01-29T12:55:51Z"))
    XCTAssertEqual(interaction.line, 62633)
    XCTAssertEqual(interaction.desk, 6202)
    XCTAssertEqual(interaction.user, 891)
  }
  
  func testSourceName() {
    ticketData["source"] = "NAME"
    let ticket = decodeToTicket()
    
    XCTAssertEqual(ticket?.source, .name)
  }
  
  func testSourcePrinter() {
    ticketData["source"] = "PRINTER"
    let ticket = decodeToTicket()
    
    XCTAssertEqual(ticket?.source, .printer)
  }
  
  func testSourceOther() {
    ticketData["source"] = "OTHER"
    let ticket = decodeToTicket()
    
    XCTAssertEqual(ticket?.source, .other)
  }
  
  fileprivate func decodeToTicket() -> Ticket? {
    return try? ticketData.decodeAs(Ticket.self)
  }
}
