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
    let secret = String.random
    let pairingCode = String(String.random.dropFirst(4))
    
    let tvPairingData: [String: Any] = [
      "code": pairingCode,
      "secret": secret
    ]
    let tvPairingCode = try? tvPairingData.decodeAs(TVPairingCode.self)
    
    XCTAssertEqual(tvPairingCode?.code, pairingCode)
    XCTAssertEqual(tvPairingCode?.secret, secret)
  }
}
