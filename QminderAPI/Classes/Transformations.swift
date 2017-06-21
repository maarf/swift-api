//
//  Transformations.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

import ObjectMapper

/// Transform String to Int
let transformFromStringToInt = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
    // transform value from String? to Int?
    return Int(value!)
}, toJSON: { (value: Int?) -> String? in
    // transform value from Int? to String?
    if let value = value {
        return String(value)
    }
    return nil
})


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
