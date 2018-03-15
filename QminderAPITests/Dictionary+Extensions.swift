//
//  Dictionary+Extensions.swift
//  QminderAPITests
//
//  Created by Kristaps Grinbergs on 15/03/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

public extension Dictionary {
  
  /**
   JSON data of Dictionary
   
   - Parameters:
      - prettify: Pretify JSON
   
   - Returns: Optional data as JSON
  */
  public func jsonData(prettify: Bool = false) -> Data? {
    guard JSONSerialization.isValidJSONObject(self) else {
      return nil
    }
    let options = (prettify == true) ?
      JSONSerialization.WritingOptions.prettyPrinted :
      JSONSerialization.WritingOptions()
    
    return try? JSONSerialization.data(withJSONObject: self, options: options)
  }
}

public extension Dictionary where Key == String, Value == Any {
  
  /**
   Decode Dictionary [String: Any] to decodable
   
   - Parameters:
     - type: Decodable type
   
   - Returns: Decoded decodable as given type
  */
  public func decodeAs<T>(_ type: T.Type) throws -> T where T: Decodable {
    let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    let object = try JSONDecoder().decode(type, from: data)
    
    return object
  }
}
