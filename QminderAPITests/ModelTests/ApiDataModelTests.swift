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
    let apiDataId = Int.random
    let locationId = Int.random
    let apiKey = String.random
    
    let apiData: [String: Any] = [
      "status": "PAIRED",
      "id": apiDataId,
      "apiKey": apiKey,
      "location": locationId
    ]
   
    let tvAPIData = try? apiData.decodeAs(TVAPIData.self)
      
    XCTAssertEqual(tvAPIData?.status, .paired)
    XCTAssertEqual(tvAPIData?.id, apiDataId)
    XCTAssertEqual(tvAPIData?.apiKey, apiKey)
    XCTAssertEqual(tvAPIData?.location, locationId)
  }
  
  func testNotPaired() {
    let apiData: [String: Any] = [
      "statusCode": 200,
      "status": "NOT_PAIRED"
    ]
    
    let tvAPIData = try? apiData.decodeAs(TVAPIData.self)
    
    XCTAssertEqual(tvAPIData?.status, .notPaired)
    XCTAssertNil(tvAPIData?.id)
    XCTAssertNil(tvAPIData?.apiKey)
    XCTAssertNil(tvAPIData?.location)
  }
}
