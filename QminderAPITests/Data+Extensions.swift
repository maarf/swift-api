//
//  Data+Extensions.swift
//  QminderAPITests
//
//  Created by Kristaps Grinbergs on 15/03/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

extension Data {
  
  /**
   String by encoding Data using the given encoding (if applicable).
   
   - Parameters:
   - encoding: encoding.
   - Returns: String by encoding Data using the given encoding (if applicable).
   */
  func string(encoding: String.Encoding) -> String? {
    return String(data: self, encoding: encoding)
  }
}
