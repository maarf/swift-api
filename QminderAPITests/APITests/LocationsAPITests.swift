//
//  LocationsAPITests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 27/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

@testable import QminderAPI

class LocationsAPITests: QminderAPITests {
  
  func testLocationsList() {
    var locations: [Location]?
    var location: Location?
    
    wait { expectation in
      qminderAPI.getLocationsList { result in
        switch result {
        case let .success(value):
          locations = value
          location = locations?.first
          
          expectation.fulfill()
        case .failure:
          XCTFail("Can't get locations list")
        }
      }
    }
    
    XCTAssertNotNil(locations)
    
    XCTAssertNotNil(location)
    XCTAssertNotNil(location?.id)
    XCTAssertNotNil(location?.name)
    XCTAssertNotNil(location?.latitude)
    XCTAssertNotNil(location?.longitude)
  }
  
  func testLocationDetails() {
    var location: Location?
    
    wait { expectation in
      qminderAPI.getLocationDetails(locationId: locationId) { result in
        switch result {
        case let .success(value):
          location = value
          
          expectation.fulfill()
        case .failure:
          XCTFail("Can't get location details")
        }
      }
    }
    
    XCTAssertNotNil(location)
    
    XCTAssertNotNil(location?.id)
    XCTAssertNotNil(location?.name)
    XCTAssertNotNil(location?.latitude)
    XCTAssertNotNil(location?.longitude)
  }
  
  func testLinesList() {
    var lines: [Line]?
    var line: Line?
    
    wait { expectation in
      qminderAPI.getLocationLines(locationId: locationId) { result in
        switch result {
        case let .success(value):
          lines = value
          line = lines?.first
          
          expectation.fulfill()
        case .failure:
          XCTFail("Can't get lines list")
        }
      }
    }
    
    XCTAssertNotNil(lines)
    
    XCTAssertNotNil(line)
    XCTAssertNotNil(line?.id)
    XCTAssertNotNil(line?.name)
  }
  
  func testUsersList() {
    var users: [User]?
    var user: User?
    
    wait { expectation in
      qminderAPI.getLocationUsers(locationId: locationId) { result in
        switch result {
        case let .success(value):
          users = value
          user = users?.first
          
          expectation.fulfill()
        case .failure:
          XCTFail("Can't get users list")
        }
      }
    }
    
    XCTAssertNotNil(users)
    
    XCTAssertNotNil(user)
    XCTAssertNotNil(user?.id)
    XCTAssertNotNil(user?.firstName)
    XCTAssertNotNil(user?.lastName)
    XCTAssertNotNil(user?.email)
  }
  
  func testDesksList() {
    var desks: [Desk]?
    var desk: Desk?
    
    wait { expectation in
      qminderAPI.getLocationDesks(locationId: locationId) { result in
        switch result {
        case let .success(value):
          desks = value
          desk = desks?.first
          
          expectation.fulfill()
        case .failure:
          XCTFail("Can't get desks list")
        }
      }
    }
    
    XCTAssertNotNil(desks)
    
    XCTAssertNotNil(desk)
    XCTAssertNotNil(desk?.id)
    XCTAssertNotNil(desk?.name)
  }
}