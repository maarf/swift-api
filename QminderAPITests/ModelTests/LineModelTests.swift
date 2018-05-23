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
  
  private let lineId = Int.random
  private let lineName = String.random
  private let locationId = Int.random
  
  private var lineData: [String: Any]!
  
  override func setUp() {
    super.setUp()
    
    lineData = [
      "id": lineId,
      "name": lineName,
      "location": locationId
    ]
  }
  
  func testLineModel() {
    let line = decodeToLine()
    
    XCTAssertEqual(line?.id, lineId)
    XCTAssertEqual(line?.name, lineName)
    XCTAssertEqual(line?.location, locationId)
  }
  
  func testLocationAsSting() {
    
    let newLineId = Int.random
    let newLocationId = Int.random
    
    lineData["id"] = newLineId
    lineData["location"] = newLocationId
    
    let line = decodeToLine()
    
    XCTAssertEqual(line?.id, newLineId)
    XCTAssertEqual(line?.location, newLocationId)
  }
  
  fileprivate func decodeToLine() -> Line? {
    return try? lineData.decodeAs(Line.self)
  }
}
