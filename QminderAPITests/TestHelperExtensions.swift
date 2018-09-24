//
//  TestHelperExtensions.swift
//  QminderAPITests
//
//  Created by Kristaps Grinbergs on 17/05/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

extension Int {
  
  /// Random Int value
  static var random: Int {
    return random()
  }
  
  /**
   Random Int
   
   - Parameters:
     - max: Max value
   
   - Returns: Random Int
  */
  static func random(max: Int = 20) -> Int {
    return Int.random(in: 0...max)
  }
}

extension Double {
  /// Random Double value
  static var random: Double {
    return random(min: 10, max: 20)
  }
  
  /**
   Random Double value from min and max
   
   - Parameters:
     - min: Minimal value
     - max: Maximal value
   
   - Returns: Random Double
  */
  static func random(min: Double, max: Double) -> Double {
    return Double.random(in: min...max)
  }
}

extension String {
  /// Random String value
  static var random: String {
    return UUID().uuidString
  }
}

enum DateFormat: String {
  case withoutMilliseconds = "yyyy-MM-dd'T'HH:mm:ss'Z"
  case withMilliseconds = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
}

extension Date {
  
  /// Random Date (distant future)
  static var random: Date {
    return Date.distantFuture
  }
  
  /**
   Format date with
   
   - Parameters:
     - dateFormat: With or without milliseconds
   
   - Returns Formatted date string
  */
  func format(_ dateFormat: DateFormat = .withoutMilliseconds) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat.rawValue
    dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
    
    return dateFormatter.string(from: self)
  }
}
