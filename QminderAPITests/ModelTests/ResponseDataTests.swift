//
//  ResponseDataTests.swift
//  QminderAPITests
//
//  Created by Kristaps Grinbergs on 12/03/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import XCTest

@testable import QminderAPI

class ResponseDataTests: XCTestCase {
  
  func testResponsableWithData() {
    let locationLines: [String: Any] = [
      "statusCode": 200,
      "data": [
        [
          "id": 1,
          "name": "Private"
        ],
        [
          "id": 2,
          "name": "Business"
        ],
        [
          "id": 3,
          "name": "Information"
        ]
      ]
    ]
    
    let result = locationLines.jsonData()!.decode(Lines.self)
    
    switch result {
    case let .success(value):
      XCTAssertTrue(value.contains(where: {
        $0.id == 1 && $0.name == "Private"
      }))
      
      XCTAssertTrue(value.contains(where: {
        $0.id == 2 && $0.name == "Business"
      }))
      
      XCTAssertTrue(value.contains(where: {
        $0.id == 3 && $0.name == "Information"
      }))
      
    case let .failure(error):
      XCTFail("Should not fail decoding \(error)")
    }
  }
  
  func testResponsableWithDataError() {
    let locationLines: [String: Any] = [
      "statusCode": 200,
      "data": [
        [
          "Error": 666
        ]
      ]
    ]
    let result = locationLines.jsonData()!.decode(Lines.self)
    
    switch result {
    case let .success(value):
      XCTFail("Should fail to decode \(value)")
    case let .failure(error):
      
      XCTAssertEqual(error, QminderError.jsonParsing(error))
      
      switch error {
      case let .jsonParsing(jsonError as DecodingError):
        print("Parsing error \(jsonError)")
      default:
        XCTFail("Should not be other error than jsonParsing")
      }
    }
  }
  
  func testResponsable() {
    let line: [String: Any] = [
      "statusCode": 200,
      "id": 1,
      "name": "Private",
      "location": 333
    ]
    
    let result = line.jsonData()!.decode(Line.self)
    
    switch result {
    case let .success(value):
      XCTAssertEqual(value.id, 1)
      XCTAssertEqual(value.name, "Private")
      XCTAssertEqual(value.location, 333)
    case let .failure(error):
      XCTFail("Should not fail with \(error)")
    }
  }
  
  func testResponsableError() {
    let line: [String: Any] = [
      "statusCode": 200,
      "Error": 666
    ]
    
    let result = line.jsonData()!.decode(Line.self)
    
    switch result {
    case let .success(value):
      XCTFail("Should fail to decode \(value)")
    case let .failure(error):
      XCTAssertEqual(error, QminderError.jsonParsing(error))
      
      switch error {
      case let .jsonParsing(jsonError as DecodingError):
        print("Parsing error \(jsonError)")
      default:
        XCTFail("Should not be other error than jsonParsing")
      }
    }
  }
}
