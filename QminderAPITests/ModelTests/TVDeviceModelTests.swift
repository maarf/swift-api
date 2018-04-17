//
//  TVDeviceModelTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 19/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

import QminderAPI

class TVDeviceModelTests: ModelTests {
  
  var tvDeviceData: [String: Any] = [
    "statusCode": 200,
    "id": 999,
    "name": "Apple TV",
    "settings": ["lines": [1, 2, 3], "clearTickets": "afterCalling"],
    "theme": "Default",
    "layout": "standard"
  ]
  
  func testTVDeviceModel() {
    let device = decodeToTVDevice()
    
    XCTAssertEqual(device?.id, 999)
    XCTAssertEqual(device?.name, "Apple TV")
    XCTAssertEqual(device?.theme, "Default")
    XCTAssertNotNil(device?.settings)
    XCTAssertEqual(device?.settings?.clearTickets, .afterCalling)
    
    guard let lines = device?.settings?.lines else {
      XCTFail("Can't get device lines")
      return
    }
    
    XCTAssertFalse(lines.isEmpty)
    XCTAssertTrue(lines.contains(where: { $0 == 1 }))
    XCTAssertTrue(lines.contains(where: { $0 == 2 }))
    XCTAssertTrue(lines.contains(where: { $0 == 3 }))
  }
  
  func testWithoutSettings() {
    tvDeviceData["settings"] = nil
    
    let device = decodeToTVDevice()
  
    XCTAssertNil(device?.settings)
    XCTAssertNil(device?.settings?.lines)
  }
  
  fileprivate func decodeToTVDevice() -> TVDevice? {
    return try? tvDeviceData.decodeAs(TVDevice.self)
  }
}
