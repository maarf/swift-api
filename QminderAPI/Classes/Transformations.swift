//
//  Transformations.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

import ObjectMapper

/// Transform Int or String to Int
class StringOrIntToInt: TransformType {
	public typealias Object = Int
	public typealias JSON = String
	
  /**
    Transform from JSON
    
    - Parameters:
      - value: Any? value type to transoform
      
    - Returns: Optional transformed to Int
  */
  func transformFromJSON(_ value: Any?) -> Int? {
    // If is already Int
    if let i = value as? Int {
      return i
      
    // If is string
    } else if let i = value as? String {
      return Int(i)
    }
    
    // It's not String nor Int
		return nil
	}
	
  /**
    Transform from to JSON
    
    - Parameters:
      - value: Int to transfer to string
      
    - Returns: Optional transformed string
  */
  func transformToJSON(_ value: Int?) -> String? {
		if let value = value {
			return String(value)
		}
		return nil
	}
}




/// ISO 8601 extended date format transform which contains milliseconds.
class ISO8601ExtendedDateTransform: DateFormatterTransform {
  
  /// Extended date formatter with miliseconds
  let extendedDateFormatter = DateFormatter()
  
  init() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
    extendedDateFormatter.locale = Locale(identifier: "en_US_POSIX")
    extendedDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    super.init(dateFormatter: formatter)
  }
  
  /**
    Transform from JSON
    
    - Parameters:
      - value: Any type to transform
  */
  override func transformFromJSON(_ value: Any?) -> Date? {
		if let dateString = value as? String {
    
      guard let date = extendedDateFormatter.date(from: dateString) else {
        return dateFormatter.date(from: dateString)
      }
    
			return date
		}
		return nil
	}
}
