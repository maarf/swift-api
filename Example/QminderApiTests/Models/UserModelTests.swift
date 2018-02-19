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
  
  let userData: [String: Any] = [
    "id": 999,
    "email": "john@example.com",
    "firstName": "John",
    "lastName": "Appleseed",
    "desk": 1,
    "roles": [["type": "MANAGER", "location": 3245], ["type": "USER", "location": 1265]],
    "picture": [["size": "medium", "url": "http://www.google.com/"]]
  ]
  
  func testUserModel() {
    let jsonData = try? JSONSerialization.data(withJSONObject: userData, options: [])
    let user = try? JSONDecoder().decode(User.self, from: jsonData!)
    
    
    XCTAssertEqual(user?.id, 999)
    XCTAssertEqual(user?.email, "john@example.com")
    XCTAssertEqual(user?.firstName, "John")
    XCTAssertEqual(user?.lastName, "Appleseed")
    XCTAssertEqual(user?.desk, 1)
    
    guard let roles = user?.roles else {
      XCTFail()
      return
    }
    
    XCTAssertTrue(roles.contains(where: { $0.type == "MANAGER" && $0.location == 3245 }))
    XCTAssertTrue(roles.contains(where: { $0.type == "USER" && $0.location == 1265 }))
    
    guard let picture = user?.picture else {
      XCTFail()
      return
    }
    
    XCTAssertTrue(picture.contains(where: { $0.size == "medium" && $0.url == "http://www.google.com/" }))
  }
}
