//
//  TVPairingCodeModelTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 19/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

import QminderAPI

class TVPairingCodeModelTests: ModelTests {
  
  func testTVPairing() {
    let tvPairingData: [String: Any] = [
      "statusCode": 200,
      "code": "PW3R",
      "secret": "75aa16d7923ac707cc302e1ce7c81e8a"
    ]
    let tvPairingCode = try? tvPairingData.decodeAs(TVPairingCode.self)
    
    XCTAssertEqual(tvPairingCode?.code, "PW3R")
    XCTAssertEqual(tvPairingCode?.secret, "75aa16d7923ac707cc302e1ce7c81e8a")
  }
}
