//
//  Loggable.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 27/07/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

protocol Loggable {
  func log(_ message: @autoclosure () -> Any, _ path: String, _ function: String, line: Int)
}

extension Loggable {
  func log(_ message: @autoclosure () -> Any, _ path: String = #file, _ function: String = #function, line: Int = #line) {
    print("\(Date()) \(path):\(line) \(function) \(message())")
  }
}
