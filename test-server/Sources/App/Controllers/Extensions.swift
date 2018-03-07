//
//  Extensions.swift
//  test-serverPackageDescription
//
//  Created by Kristaps Grinbergs on 06/03/2018.
//

import Foundation

extension Array where Element: Equatable {
  func contains(array: [Element]) -> Bool {
    for item in array {
      if !self.contains(item) { return false }
    }
    return true
  }
}

extension Dictionary where Key == String, Value == Any {
  
  /**
   Change ticket data
   
   - Parameters:
     - newData: Data to merge
  */
  mutating func changeTicketData(_ newData: [String: Any]) {
    guard let data = self["data"] as? [String: Any] else {
      return
    }
    
    self["data"] = data.merging(newData, uniquingKeysWith: { (_, last) in last })
  }
}
