//
//  LinesAPITests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 27/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

@testable import QminderAPI

class LinesAPITests: QminderAPITests {
  func testLineDetails() {
    var details: Line?
    
    wait { expectation in
      qminderAPI.getLineDetails(lineId: lineId) { result in
        
        XCTAssertTrue(Thread.isMainThread)
        
        switch result {
        case let .success(value):
          details = value
          
          expectation.fulfill()
        case let .failure(error):
          XCTFail("Can't get line details \(error)")
        }
      }
    }
    
    XCTAssertNotNil(details)
    XCTAssertNotNil(details?.id)
    XCTAssertNotNil(details?.name)
    XCTAssertNotNil(details?.location)
  }
}
