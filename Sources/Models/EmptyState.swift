//
//  EmptyState.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 27/07/2017.
//
//

import Foundation

/// Empty state layout
public enum EmptyStateLayout: String, Codable {
  
  /// Closed
  case closed = "CLOSED"
  
  /// Simple
  case simple = "SIMPLE"
  
  /// Other (not specified)
  case other
  
  public init?(rawValue: String) {
    switch rawValue.lowercased() {
    case "simple":
      self = .simple
    case "closed":
      self = .closed
    default:
      self = .other
    }
  }
}

/// Empty state object
public struct EmptyState: Responsable {
  
  internal let statusCode: Int?
  
  /// Empty state layout
  public let layout: EmptyStateLayout
  
  /// Empty state message
  public let message: String
}
