//
//  EventResponsable.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 28/02/2018.
//

import Foundation

/// Protocol to conform to event response
public protocol EventResponsable {
  associatedtype Data
  
  /// Subscription ID
  var subscriptionId: String { get }
  
  /// Message ID
  var messageId: Int { get }
  
  /// Cata event containts
  var data: Data { get }
}
