//
//  QminderGraphQLAPITests.swift
//  QminderAPITests
//
//  Created by Kristaps Grinbergs on 15/10/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import XCTest

@testable import QminderAPI

struct QminderGraphQLAPIFaker: QminderGraphQLAPIProtocol {
  
  var locationDetails: LocationDetails
  var error: Error?
  
  func locationDetails(locationID: Int, completion: @escaping (Result<LocationDetails, QminderError>) -> Void) {
    if let error = error {
      completion(Result(QminderError.graphQL(error)))
    } else {
      completion(Result(locationDetails))
    }
  }
}

class QminderGraphQLAPITests: XCTestCase {
  
  var qminderGraphQLAPI: QminderGraphQLAPIProtocol!
  
  let lineID = Int.random
  let lineName = String.random
  
  let deskID = Int.random
  let deskName = String.random
  
  lazy var oneLineArray: [Line] = {
    return [
      Line(statusCode: nil, id: lineID, name: lineName, location: nil)
    ]
  }()
  
  func testResponseWithDesk() {
    let desks = [
      Desk(id: deskID, name: deskName)
    ]
    
    qminderGraphQLAPI = QminderGraphQLAPIFaker(locationDetails: (oneLineArray, desks), error: nil)
    qminderGraphQLAPI.locationDetails(locationID: Int.random) { result in
      switch result {
      case .success(let lines, let desks):
        XCTAssertNotNil(lines)
        guard let line = lines.first else {
          XCTFail("Should be at least one line")
          return
        }
        XCTAssertEqual(line.id, self.lineID)
        XCTAssertEqual(line.name, self.lineName)
        
        XCTAssertNotNil(desks)
        guard let desk = desks?.first else {
          XCTFail("Should be at least one desk")
          return
        }
        XCTAssertEqual(desk.id, self.deskID)
        XCTAssertEqual(desk.name, self.deskName)
      case .failure(let error):
        XCTFail(error.localizedDescription)
      }
    }
  }
  
  func testResponseWithoutDesk() {
    qminderGraphQLAPI = QminderGraphQLAPIFaker(locationDetails: (oneLineArray, nil), error: nil)
    qminderGraphQLAPI.locationDetails(locationID: Int.random) { result in
      switch result {
      case .success(_, let desks):
        XCTAssertNil(desks)
      case .failure(let error):
        XCTFail(error.localizedDescription)
      }
    }
  }
  
  func testResponseWithError() {
    let errorDomain = String.random
    let errorCode = Int.random
    
    qminderGraphQLAPI = QminderGraphQLAPIFaker(locationDetails: (oneLineArray, nil),
                                               error: NSError(domain: errorDomain, code: errorCode, userInfo: nil))
    qminderGraphQLAPI.locationDetails(locationID: Int.random) { result in
      switch result {
      case .success:
        XCTFail("Should not succeed")
      case .failure(let error):
        XCTAssertNotNil(error)
        
        switch error {
        case .graphQL(let error as NSError):
          XCTAssertEqual(error.code, errorCode)
          XCTAssertEqual(error.domain, errorDomain)
        default:
          XCTFail("Wrong error")
        }
      }
    }
  }
}
