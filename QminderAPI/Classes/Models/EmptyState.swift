//
//  EmptyState.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 27/07/2017.
//
//

import Foundation

/// Empty state object
public struct EmptyState: CodableResponsable {
  
  /// Status code from API
  let statusCode: Int
  
  /// Empty state layout
  public let layout: String
  
  /// Empty state message
  public let message: String
}
