//
//  UsersAPITests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 27/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

@testable import QminderAPI

class UsersAPITests: QminderAPITests {
  func testUserDetails() {
    var user: User?
    
    wait { expectation in
      qminderAPI.getUserDetails(userId: userID) { result in
        switch result {
        case let .success(value):
          user = value
          
          expectation.fulfill()
        case .failure:
          XCTFail("Can't get user details")
        }
      }
    }
    
    XCTAssertNotNil(user)
    XCTAssertNotNil(user?.id)
    XCTAssertNotNil(user?.firstName)
    XCTAssertNotNil(user?.lastName)
    XCTAssertNotNil(user?.email)
  }
}