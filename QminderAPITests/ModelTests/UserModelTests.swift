//
//  UserModelTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 19/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

import QminderAPI

class UserModelTests: ModelTests {
  
  private let userId = Int.random
  private let firstName = String.random
  private let lastName = String.random
  private let deskNumber = Int.random
  
  private let managerRoleType = String.random
  private let userRoleType = String.random
  
  private let managerLocationId = Int.random
  private let userLocationId = Int.random
  
  private let pictureSize = String.random
  private let pictureUrl = "http://www.\(String.random).com"
  
  private var userData: [String: Any]!
  
  override func setUp() {
    super.setUp()
    
    userData = [
      "id": userId,
      "email": "john@example.com",
      "firstName": firstName,
      "lastName": lastName,
      "desk": deskNumber,
      "roles": [
        [
          "type": managerRoleType,
          "location": managerLocationId
        ],
        [
          "type": userRoleType,
          "location": userLocationId
        ]
      ],
      "picture": [
        [
          "size": pictureSize,
          "url": pictureUrl
        ]
      ]
    ]
  }
  
  func testUserModel() {
    let user = try? userData.decodeAs(User.self)
    
    XCTAssertEqual(user?.id, userId)
    XCTAssertEqual(user?.email, "john@example.com")
    XCTAssertEqual(user?.firstName, firstName)
    XCTAssertEqual(user?.lastName, lastName)
    XCTAssertEqual(user?.desk, deskNumber)
    
    guard let roles = user?.roles else {
      XCTFail("Can't get user roles")
      return
    }
    
    XCTAssertTrue(roles.contains(where: {
      $0.type == managerRoleType && $0.location == managerLocationId
    }))
    
    XCTAssertTrue(roles.contains(where: {
      $0.type == userRoleType && $0.location == userLocationId
    }))
    
    guard let picture = user?.picture else {
      XCTFail("Can't get user picture")
      return
    }
    
    XCTAssertTrue(picture.contains(where: {
      $0.size == pictureSize && $0.url == pictureUrl
    }))
  }
}
