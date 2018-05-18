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
  
  func testLocationModel() {
    
    let locationId = Int.random
    let locationName = String.random
    let timezoneOffset = Int.random(max: 10)
    let latitude = Double.random
    let longitude = Double.random
    
    let locationData: [String: Any] = [
      "id": locationId,
      "name": locationName,
      "latitude": latitude,
      "longitude": longitude,
      "timezoneOffset": timezoneOffset
    ]
    
    let location = try? locationData.decodeAs(Location.self)
    
    XCTAssertEqual(location?.id, locationId)
    XCTAssertEqual(location?.name, locationName)
    XCTAssertEqual(location?.timezoneOffset, timezoneOffset)
    XCTAssertEqual(location?.latitude, latitude)
    XCTAssertEqual(location?.longitude, longitude)
  }
}
