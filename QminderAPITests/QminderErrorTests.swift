//
//  QminderErrorTests.swift
//  QminderAPITests
//
//  Created by Kristaps Grinbergs on 12/03/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import XCTest

@testable import QminderAPI

class QminderErrorTests: XCTestCase {
  func testErrorToQmidnerError() {
    let error = NSError(domain: "Qminder", code: 1)
    
    let qminderError = error.qminderError
    
    switch qminderError {
    case let .request(requestError as NSError):
      XCTAssertEqual(requestError, error)
    default:
      XCTFail("Should be request QminderError")
    }
  }
  
  func testErrorFromQmidnerError() {
    let error = QminderError.parse
    
    switch error.qminderError {
    case .parse:
      print("Error is QminderError.parse")
    default:
      XCTFail("Should be parse QminderError")
    }
  }
}
