//
//  LinesResponsable.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 28/02/2018.
//

import Foundation

struct LinesResponsable: EventResponsable, Codable {
  typealias Data = [String: [Line]]
  
  var subscriptionId: String
  var messageId: Int
  var data: Data
  
  /// Lines array
  var lines: [Line] {
    guard let lines = data["lines"] else { return [] }
    
    return lines
  }
}
