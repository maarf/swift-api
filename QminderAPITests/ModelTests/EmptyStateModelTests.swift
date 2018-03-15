//
//  EmptyStateModelTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 19/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

import QminderAPI

class EmptyStateModelTests: ModelTests {
  
  func testParsingEmptyStateSimple() {
    let data: [String: Any] = [
      "statusCode": 200,
      "layout": "simple",
      "message": "Simple message"
    ]
    let emptyState = try? data.decodeAs(EmptyState.self)
    
    XCTAssertEqual(emptyState?.message, "Simple message")
    XCTAssertEqual(emptyState?.layout, .simple)
  }
  
  func testParsingEmptyStateClosed() {
    let data: [String: Any] = [
      "statusCode": 200,
      "layout": "closed",
      "message": "closed message"
    ]
    let emptyState = try? data.decodeAs(EmptyState.self)
    
    XCTAssertEqual(emptyState?.message, "closed message")
    XCTAssertEqual(emptyState?.layout, .closed)
  }
  
  func testOtherEmptyState() {
    let data: [String: Any] = [
      "statusCode": 200,
      "layout": "other",
      "message": "other message"
    ]
    let emptyState = try? data.decodeAs(EmptyState.self)
    
    XCTAssertEqual(emptyState?.message, "other message")
    XCTAssertEqual(emptyState?.layout, .other)
  }
}
