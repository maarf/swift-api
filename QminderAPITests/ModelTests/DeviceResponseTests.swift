//
//  DeviceResponseTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 28/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

import QminderAPI

class DeviceResponseTests: ModelTests {
  
  func testDeviceResponse() {
    let tvDeviceResponseData: [String: Any] = [
      "subscriptionId": "1",
      "messageId": 2,
      "data": [
        "statusCode": 200,
        "id": 999,
        "name": "Apple TV",
        "settings": ["lines": [1, 2, 3], "clearTickets": "afterCalling"],
        "theme": "Default",
        "layout": "standard"
      ]
    ]
    let deviceResponse = try? tvDeviceResponseData.decodeAs(DeviceEventResponse.self)
    
    XCTAssertEqual(deviceResponse?.subscriptionId, "1")
    XCTAssertEqual(deviceResponse?.messageId, 2)
    
    guard let device = deviceResponse?.data else {
      XCTFail("Can't parse data to ticket")
      return
    }
    
    XCTAssertEqual(device.id, 999)
    XCTAssertEqual(device.name, "Apple TV")
    XCTAssertEqual(device.theme, "Default")
    XCTAssertNotNil(device.settings)
    XCTAssertEqual(device.settings?.clearTickets, .afterCalling)
  }
}
