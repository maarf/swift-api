//
//  LineModelTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 19/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

@testable import QminderAPI

class LineModelTests: ModelTests {
  var lineData: [String: Any] = [
    "id": 999,
    "name": "Line name",
    "location": 333
  ]
  
  func testLineModel() {
    let jsonData = try? JSONSerialization.data(withJSONObject: lineData, options: [])
    let line = try? JSONDecoder().decode(Line.self, from: jsonData!)
    
    XCTAssertEqual(line?.id, 999)
    XCTAssertEqual(line?.name, "Line name")
    XCTAssertEqual(line?.location, 333)
  }
  
  func testLocationAsSting() {
    lineData["id"] = 999
    lineData["location"] = 333
    
    let jsonData = try? JSONSerialization.data(withJSONObject: lineData, options: [])
    let line = try? JSONDecoder().decode(Line.self, from: jsonData!)
    
    XCTAssertEqual(line?.id, 999)
    XCTAssertEqual(line?.location, 333)
  }
}
