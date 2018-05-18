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
  
  private let subscriptionId = String(Int.random)
  private let messageId = Int.random
  
  private let firstLineId = Int.random
  private let firstLineName = String.random
  private let firstLineLocationId = Int.random
  
  private let secondLineId = Int.random
  private let secondLineName = String.random
  private let secondLineLocationId = Int.random
  
  private var lineResponseData: [String: Any]!
  
  override func setUp() {
    super.setUp()
    
    lineResponseData = [
      "subscriptionId": subscriptionId,
      "messageId": messageId,
      "data": [
        "lines": [
          ["id": firstLineId,
           "name": firstLineName,
           "location": firstLineLocationId],
          ["id": secondLineId,
           "name": secondLineName,
           "location": secondLineLocationId
          ]
        ]
      ]
    ]
  }
  
  func testLineResponse() {
    let lineResponse = decodeToLinesResponse()
    
    guard let lines = lineResponse?.data["lines"] else {
      XCTFail("Can't get lines from TV device response")
      return
    }
    XCTAssertEqual(lines.count, 2)
    
    XCTAssertEqual(lineResponse?.subscriptionId, subscriptionId)
    XCTAssertEqual(lineResponse?.messageId, messageId)
    
    XCTAssertTrue(lineResponse?.lines.count == 2)
    XCTAssertFalse((lineResponse?.lines.isEmpty)!)
    
    XCTAssertEqual(lineResponse?.lines.first?.id, firstLineId)
    XCTAssertEqual(lineResponse?.lines.first?.name, firstLineName)
    XCTAssertEqual(lineResponse?.lines.first?.location, firstLineLocationId)
    
    XCTAssertEqual(lineResponse?.lines[1].id, secondLineId)
    XCTAssertEqual(lineResponse?.lines[1].name, secondLineName)
    XCTAssertEqual(lineResponse?.lines[1].location, secondLineLocationId)
  }
  
  func testEmptyLinesResponse() {
    lineResponseData["data"] = ["lines": []]
    let lineResponse = decodeToLinesResponse()
    
    XCTAssertTrue(lineResponse?.lines.count == 0)
  }
  
  fileprivate func decodeToLinesResponse() -> LinesEventResponse? {
    return try? lineResponseData.decodeAs(LinesEventResponse.self)
  }
}
