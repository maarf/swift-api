//
//  LinesEventResponse.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 28/02/2018.
//

import Foundation

public struct LinesEventResponse: EventResponsable, Codable {
  public typealias Data = [String: [Line]]
  
  public var subscriptionId: String
  public var messageId: Int
  public var data: Data
  
  /// Lines array
  public var lines: [Line] {
    return data["lines"] ?? []
  }
}
