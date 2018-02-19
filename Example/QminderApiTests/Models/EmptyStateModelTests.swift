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
  func testParsingEmptyState() {
    let data: [String: Any] = [
      "statusCode": 200,
      "layout": "closed",
      "message": "closed message"
    ]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
    let emptyState = try? JSONDecoder().decode(EmptyState.self, from: jsonData!)
    
    XCTAssertEqual(emptyState?.message, "closed message")
    XCTAssertEqual(emptyState?.layout, .closed)
  }
  
  func testOtherEmptyState() {
    let data: [String: Any] = [
      "statusCode": 200,
      "layout": "other",
      "message": "other message"
    ]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
    let emptyState = try? JSONDecoder().decode(EmptyState.self, from: jsonData!)
    
    XCTAssertEqual(emptyState?.message, "other message")
    XCTAssertEqual(emptyState?.layout, .other)
  }
}
