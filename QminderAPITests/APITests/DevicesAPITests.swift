//
//  DevicesAPITests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 27/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

@testable import QminderAPI

class DevicesAPITests: QminderAPITests {
  func testPairingCodeSecret() {
    var code: String?
    var secret: String?
    
    wait { expectation in
      qminderAPI.getPairingCodeAndSecret { result in
        
        XCTAssertTrue(Thread.isMainThread)
        
        switch result {
        case let .success(value):
          code = value.code
          secret = value.secret
          
          expectation.fulfill()
        case .failure:
          XCTFail("Can't get pairing code and secret")
        }
      }
    }
    
    XCTAssertNotNil(code)
    XCTAssertFalse((code?.isEmpty)!)
    
    XCTAssertNotNil(secret)
    XCTAssertFalse((secret?.isEmpty)!)
  }
  
  func testPairTV() {
    var e: Error?
    
    wait { expectation in
      qminderAPI.pairTV(code: "XXX", secret: "YYY", completion: { result in
        
        XCTAssertTrue(Thread.isMainThread)
        
        switch result {
        case .success:
          XCTFail("Should not be succesfull")
        case let .failure(error):
          e = error
          expectation.fulfill()
        }
      })
    }
    
    XCTAssertNotNil(e)
  }
  
  func testTVDetails() {
    var device: TVDevice?
    
    wait { expectation in
      qminderAPI.tvDetails(id: tvID) { result in
        
        XCTAssertTrue(Thread.isMainThread)
        
        switch result {
        case let .success(value):
          device = value
        case .failure:
          XCTFail("Can't get TV details")
        }
        
        expectation.fulfill()
      }
    }
    
    XCTAssertNotNil(device)
    XCTAssertEqual(device?.id, tvID)
    XCTAssertNotNil(device?.name)
    XCTAssertNotNil(device?.theme)
    XCTAssertNotNil(device?.layout)
  }
  
  func testEmptyState() {
    var emptyState: EmptyState?
    
    wait { expectation in
      qminderAPI.tvEmptyState(id: tvID, language: "en", completion: { result in
        
        XCTAssertTrue(Thread.isMainThread)
        
        switch result {
        case let .success(value):
          emptyState = value
          
          expectation.fulfill()
        case .failure:
          XCTFail("Can't get TV empty state")
        }
      })
    }
    
    XCTAssertNotNil(emptyState)
    XCTAssertNotNil(emptyState?.message)
    XCTAssertNotNil(emptyState?.layout)
  }
  
  func testSendHeartbeat() {
    wait { expectation in
      qminderAPI.tvHeartbeat(id: tvID, metadata: ["foo": "bar"]) { result in
        
        XCTAssertTrue(Thread.isMainThread)
        
        switch result {
        case .success:
          expectation.fulfill()
        case .failure:
          XCTFail("Can't send TV heartbeat")
        }
      }
    }
  }
  
  func testSendHeartbeatUnknownTV() {
    var e: Error?
    
    wait { expectation in
      qminderAPI.tvHeartbeat(id: 666, metadata: ["foo": "bar"]) { result in
        
        XCTAssertTrue(Thread.isMainThread)
        
        switch result {
        case .success:
          XCTFail("Can't send heartbeat to false TV")
        case let .failure(error):
          e = error
        }
        
        expectation.fulfill()
      }
    }
    
    XCTAssertNotNil(e)
  }
}
