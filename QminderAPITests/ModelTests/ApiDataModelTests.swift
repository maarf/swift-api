//
//  ApiDataModelTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 19/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

@testable import QminderAPI

class ApiDataModelTests: ModelTests {
  
  func testPaired() {
    let apiData: [String: Any] = [
      "statusCode": 200,
      "status": "PAIRED",
      "id": 41078,
      "apiKey": "804ef75ba9b6b5264c96150b457f8f30",
      "location": 666
    ]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: apiData, options: [])
    let tvAPIData = try? JSONDecoder().decode(TVAPIData.self, from: jsonData!)
    
    XCTAssertEqual(tvAPIData?.status, "PAIRED")
    XCTAssertEqual(tvAPIData?.id, 41078)
    XCTAssertEqual(tvAPIData?.apiKey, "804ef75ba9b6b5264c96150b457f8f30")
    XCTAssertEqual(tvAPIData?.location, 666)
  }
  
  func testNotPaired() {
    let apiData: [String: Any] = [
      "statusCode": 200,
      "status": "NOT_PAIRED"
    ]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: apiData, options: [])
    let tvAPIData = try? JSONDecoder().decode(TVAPIData.self, from: jsonData!)
    
    XCTAssertEqual(tvAPIData?.status, "NOT_PAIRED")
    XCTAssertNil(tvAPIData?.id)
    XCTAssertNil(tvAPIData?.apiKey)
    XCTAssertNil(tvAPIData?.location)
  }
}
