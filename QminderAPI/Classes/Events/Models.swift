//
//  Models.swift
//  Alamofire
//
//  Created by Kristaps Grinbergs on 06/10/2017.
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

/// Ticket response container
struct TicketResponse: EventResponsable, Codable {
  typealias Data = Ticket
  
  var subscriptionId: String
  var messageId: Int
  var data: Data
}

/// TV device response container
struct DeviceResponse: EventResponsable, Codable {
  typealias Data = TVDevice
  
  var subscriptionId: String
  var messageId: Int
  var data: Data
}

struct LinesResponse: EventResponsable, Codable {
  typealias Data = [String: [Line]]
  
  var subscriptionId: String
  var messageId: Int
  var data: Data
  
  var lines: [Line] {
    guard let lines = data["lines"] else { return [] }
    
    return lines
  }
}


