//
//  Extensions.swift
//  Alamofire
//
//  Created by Kristaps Grinbergs on 26/09/2017.
//

import Foundation

public extension JSONDecoder {
  convenience init(withMilliseconds: Bool = true) {
    self.init()
    
    let dateISO8601Formatter = DateFormatter()
    dateISO8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    let dateISO8601MillisecondsFormatter = DateFormatter()
    dateISO8601MillisecondsFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    self.dateDecodingStrategy = .custom({decoder -> Date in
      
      let container = try decoder.singleValueContainer()
      let dateStr = try container.decode(String.self)
      
      // possible date strings: "yyyy-MM-dd'T'HH:mm:ssZ" or "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      
      var tmpDate: Date? = nil
      
      if dateStr.count == 24 {
        tmpDate = dateISO8601MillisecondsFormatter.date(from: dateStr)
      } else {
        tmpDate = dateISO8601Formatter.date(from: dateStr)
      }
      
      guard let date = tmpDate else {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
      }
      
      return date
    })
  }
}

public extension String {
  
  /**
   Create random string for subscription ID
   
   - Returns: String random ID
   */
  static func random(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let randomLength = UInt32(letters.characters.count)
    
    let randomString: String = (0 ..< length).reduce(String()) { accum, _ in
      let randomOffset = arc4random_uniform(randomLength)
      let randomIndex = letters.index(letters.startIndex, offsetBy: Int(randomOffset))
      return accum.appending(String(letters[randomIndex]))
    }
    
    return randomString
  }
}
