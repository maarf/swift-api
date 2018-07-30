//
//  Loggable.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 27/07/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

protocol Loggable {
  func log(_ closure: @autoclosure () -> Any)
}

extension Loggable {
  func log(_ closure: @autoclosure () -> Any) {
    print("%@", "\(closure())")
  }
}
