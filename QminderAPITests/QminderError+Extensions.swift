//
//  QminderError+Extensions.swift
//  QminderAPITests
//
//  Created by Kristaps Grinbergs on 12/03/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

@testable import QminderAPI

extension QminderError: Equatable {
  public static func == (lhs: QminderError, rhs: QminderError) -> Bool {
    switch (lhs, rhs) {
    case (.jsonParsing, .jsonParsing):
      return true
    case (.apiKeyNotSet, .apiKeyNotSet):
      return true
    default:
      return false
    }
  }
}
