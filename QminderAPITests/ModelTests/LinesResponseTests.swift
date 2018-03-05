//
//  LinesResponseTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 28/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

import QminderAPI

class LinesResponseTests: ModelTests {
  
  var lineResponseData: [String: Any] = [
    "subscriptionId": "1",
    "messageId": 2,
    "data": [
      "lines": [
        ["id": 999,
         "name": "Line name 1",
         "location": 333],
        ["id": 111,
         "name": "Line name 2",
         "location": 222
        ]
      ]
    ]
  ]
  
  func testLineResponse() {
    let jsonData = try? JSONSerialization.data(withJSONObject: lineResponseData, options: [])
    let lineResponse = try? JSONDecoder().decode(LinesEventResponse.self, from: jsonData!)
    
    guard let lines = lineResponse?.data["lines"] else {
      XCTFail("Can't get lines from TV device response")
      return
    }
    XCTAssertEqual(lines.count, 2)
    
    XCTAssertEqual(lineResponse?.subscriptionId, "1")
    XCTAssertEqual(lineResponse?.messageId, 2)
    
    XCTAssertTrue(lineResponse?.lines.count == 2)
    XCTAssertFalse((lineResponse?.lines.isEmpty)!)
    
    XCTAssertEqual(lineResponse?.lines.first?.id, 999)
    XCTAssertEqual(lineResponse?.lines.first?.name, "Line name 1")
    XCTAssertEqual(lineResponse?.lines.first?.location, 333)
    
    XCTAssertEqual(lineResponse?.lines[1].id, 111)
    XCTAssertEqual(lineResponse?.lines[1].name, "Line name 2")
    XCTAssertEqual(lineResponse?.lines[1].location, 222)
  }
  
  func testEmptyLinesResponse() {
    lineResponseData["data"] = ["lines": []]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: lineResponseData, options: [])
    let lineResponse = try? JSONDecoder().decode(LinesEventResponse.self, from: jsonData!)
    
    XCTAssertTrue(lineResponse?.lines.count == 0)
    
  }
}
