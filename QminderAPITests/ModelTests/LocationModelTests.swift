//
//  LocationModelTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 19/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

import QminderAPI

class LocationModelTests: ModelTests {
  let locationData: [String: Any] = [
    "id": 999,
    "name": "Location name",
    "latitude": 25.5555,
    "longitude": 24.666,
    "timezoneOffset": 4
  ]
  
  func testLocationModel() {
    let jsonData = try? JSONSerialization.data(withJSONObject: locationData, options: [])
    let location = try? JSONDecoder().decode(Location.self, from: jsonData!)
    
    XCTAssertEqual(location?.id, 999)
    XCTAssertEqual(location?.name, "Location name")
    XCTAssertEqual(location?.timezoneOffset, 4)
    XCTAssertEqual(location?.latitude, 25.5555)
    XCTAssertEqual(location?.longitude, 24.666)
  }
}
