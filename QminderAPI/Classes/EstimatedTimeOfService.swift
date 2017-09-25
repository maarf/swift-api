//
//  EstimatedTimeOfService.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 18/07/2017.
//
//

import Foundation

/// Estimated time of service data
public struct EstimatedTimeOfService: Codable {
  
  /// Status code
  let statusCode: Int
  
  /// Estimated time of service
  public let estimatedTimeOfService: Date
  
  /// Estimated people waiting
  public let estimatedPeopleWaiting: Int
}
