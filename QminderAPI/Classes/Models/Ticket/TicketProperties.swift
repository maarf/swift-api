//
//  TicketProperties.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 14/11/2017.
//

import Foundation

/// Ticket status. "NEW", "CALLED", "CANCELLED", "CANCELLED_BY_CLERK", "NOSHOW" or "SERVED"
public enum Status: String, Codable {
  /// New
  case new = "NEW"
  
  /// Called
  case called = "CALLED"
  
  /// Cancelled
  case cancelled = "CANCELLED"
  
  /// Cancelled by clerk
  case cancelledByClerk = "CANCELLED_BY_CLERK"
  
  /// No Show
  case noShow = "NOSHOW"
  
  /// Served
  case served = "SERVED"
}

/// Ticket source
public enum Source: String, Codable {
  
  /// Manual
  case manual = "MANUAL"
  
  /// Name
  case name = "NAME"
  
  /// Printer
  case printer = "PRINTER"
  
  /// Other (not specified)
  case other
  
  public init?(rawValue: String) {
    switch rawValue.lowercased() {
    case "manual":
      self = .manual
    case "name":
      self = .name
    case "printer":
      self = .printer
    default:
      self = .other
    }
  }
}

/// Created date
public struct Created: Codable {
  
  /// Time when ticket was created
  public var date: Date
}

/// Called date
public struct Called: Codable {
  
  /// Call date
  public var date: Date?
  
  /// Desk number
  public var desk: Int?
  
  /// User ID of a clerk who called the ticket
  public var caller: Int?
}

/// Served
public struct Served: Codable {
  
  /// Date of the end of the service
  public let date: Date?
}

/// Label object
public struct Label: Codable {
  
  /// Label hex color code
  public let color: String
  
  /// Value
  public let value: String
}

/// Extra
public struct Extra: Codable {
  
  /// Title
  public let title: String?
  
  /// Value
  public let value: String?
  
  /// URL if there is
  public let url: String?
}

/// Ticket interaction
public struct Interaction: Codable {
  
  /// Interaction start
  public let start: Date
  
  /// Interaction end
  public let end: Date?
  
  /// Line ID
  public let line: Int
  
  /// Desk ID
  public let desk: Int?
  
  /// User ID
  public let user: Int?
  
}
