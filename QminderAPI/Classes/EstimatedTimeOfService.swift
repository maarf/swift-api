//
//  EstimatedTimeOfService.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 18/07/2017.
//
//

import Foundation

import ObjectMapper

/// Estimated time of service data
public struct EstimatedTimeOfService: Mappable {
  
  /// Estimated time of service
  public var estimatedTimeOfService: Date?
  
  /// Estimated people waiting
  public var estimatedPeopleWaiting: Int?
  
  public init?(map: Map) {}
  
  public mutating func mapping(map: Map) {
    estimatedTimeOfService <- (map["estimatedTimeOfService"], ISO8601DateTransform())
    estimatedPeopleWaiting <- map["estimatedPeopleWaiting"]
  }
}
