//
//  ModelTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 19/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

import QminderAPI

class ModelTests: XCTestCase {
  let dateISO8601Formatter = DateFormatter()
  let dateISO8601MillisecondsFormatter = DateFormatter()
  
  override func setUp() {
    dateISO8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateISO8601MillisecondsFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    super.setUp()
  }
}
