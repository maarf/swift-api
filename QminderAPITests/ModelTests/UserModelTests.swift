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
  
  func testUserModel() {
    let userData: [String: Any] = [
      "id": 999,
      "email": "john@example.com",
      "firstName": "John",
      "lastName": "Appleseed",
      "desk": 1,
      "roles": [["type": "MANAGER", "location": 3245], ["type": "USER", "location": 1265]],
      "picture": [["size": "medium", "url": "http://www.google.com/"]]
    ]
    let user = try? userData.decodeAs(User.self)
    
    XCTAssertEqual(user?.id, 999)
    XCTAssertEqual(user?.email, "john@example.com")
    XCTAssertEqual(user?.firstName, "John")
    XCTAssertEqual(user?.lastName, "Appleseed")
    XCTAssertEqual(user?.desk, 1)
    
    guard let roles = user?.roles else {
      XCTFail("Can't get user roles")
      return
    }
    
    XCTAssertTrue(roles.contains(where: { $0.type == "MANAGER" && $0.location == 3245 }))
    XCTAssertTrue(roles.contains(where: { $0.type == "USER" && $0.location == 1265 }))
    
    guard let picture = user?.picture else {
      XCTFail("Can't get user picture")
      return
    }
    
    XCTAssertTrue(picture.contains(where: { $0.size == "medium" && $0.url == "http://www.google.com/" }))
  }
}
