//
//  EmptyState.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 27/07/2017.
//
//

import Foundation

import ObjectMapper

/// Empty state object
public struct EmptyState: Mappable {
  // layout
  // message
  
  /// Empty state layout
  public var layout: String?
  
  /// Empty state message
  public var message: String?
  
  public init?(map: Map) {}
  
  public mutating func mapping(map: Map) {
    layout <- map["layout"]
    message <- map["message"]
  }

}
