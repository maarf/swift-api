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
    
    let firstLineId = Int.random
    let firstLineName = String.random
    
    let secondLineId = Int.random
    let secondLineName = String.random
    
    let thirdLineId = Int.random
    let thirdLineName = String.random
    
    let locationLines: [String: Any] = [
      "data": [
        [
          "id": firstLineId,
          "name": firstLineName
        ],
        [
          "id": secondLineId,
          "name": secondLineName
        ],
        [
          "id": thirdLineId,
          "name": thirdLineName
        ]
      ]
    ]
    
    let result = locationLines.jsonData()!.decode(Lines.self)
    
    switch result {
    case let .success(value):
      XCTAssertTrue(value.contains(where: {
        $0.id == firstLineId && $0.name == firstLineName
      }))
      
      XCTAssertTrue(value.contains(where: {
        $0.id == secondLineId && $0.name == secondLineName
      }))
      
      XCTAssertTrue(value.contains(where: {
        $0.id == thirdLineId && $0.name == thirdLineName
      }))
      
    case let .failure(error):
      XCTFail("Should not fail decoding \(error)")
    }
  }
  
  func testResponsableWithDataError() {
    let locationLines: [String: Any] = [
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
    let lineId = Int.random
    let lineName = String.random
    let locationId = Int.random
    
    let line: [String: Any] = [
      "statusCode": 200,
      "id": lineId,
      "name": lineName,
      "location": locationId
    ]
    
    let result = line.jsonData()!.decode(Line.self)
    
    switch result {
    case let .success(value):
      XCTAssertEqual(value.id, lineId)
      XCTAssertEqual(value.name, lineName)
      XCTAssertEqual(value.location, locationId)
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
