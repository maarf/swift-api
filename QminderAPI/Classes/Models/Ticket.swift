//
//  Ticket.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

//MARK: - Protocols

/// Protocl for API Response
protocol Responsable {
  
  /// Status code
  var statusCode: Int { get }
}

/// Protocol to describe API response
protocol ResponsableWithData: Responsable {
  
  /// Data with API request
  associatedtype Data
  
  /// Data from API
  var data: [Data] { get }
}

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


/// Type for Codable & Responsable
typealias CodableResponsable = (Codable & Responsable)

/// Type for Codable and Responsable With Data
typealias CodableResponsableWithData = (Codable & ResponsableWithData)

/// Ticket describing protocol
public protocol Ticketable {
  
  /// A unique ticket ID
  var id: String { get }
  
  /// Ticket number
  var number: Int? { get }
  
  /// Line ID
  var line: Int { get set }
  
  /// Source of the ticket. "MANUAL", "NAME" or "PRINTER". This field will not be present if no source has been specified when creating a ticket.
  var source: Source? { get }
  
  /// Ticekt status
  var status: Status { get set }
  
  /// First name
  var firstName: String? { get set }
  
  /// Last name
  var lastName: String? { get set }
  
  /// Phone number
  var phoneNumber: Int? { get set }
  
  /// Created data
  var created: Created? { get }
  
  /// Called data
  var called: Called? { get set }
  
  /// Served data
  var served: Served? { get set }
  
  /// Labels
  var labels: Array<Label>? { get set }
  
  /// Extra info
  var extra: Array<Extra>? { get set }
  
  /// Order after
  var orderAfter: Date? { get set }
}

/// Type for Codable and Ticketable conformance
typealias CodableTicket = (Codable & Ticketable)

//MARK: - Structs
/// Ticket mapping object
public struct Ticket: CodableTicket {
  public let id: String
  public let number: Int?
  public var line: Int
  public let source: Source?
  public var status: Status
  public var firstName: String?
  public var lastName: String?
  public var phoneNumber: Int?
  public var created: Created?
  public var called: Called?
  public var served: Served?
  public var labels: Array<Label>?
  public var extra: Array<Extra>?
  public var orderAfter: Date?
}

/// Created data object
public struct Created: Codable {

  /// Time when ticket was created
  public var date: Date?
}

/// Called data
public struct Called: Codable {

  /// Call date
  public var date: Date?
  
  /// Desk number
  public var desk: Int?
  
  /// User ID of a clerk who called the ticket
  public var caller: Int?
}

/// Served object
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

/// Extra object
public struct Extra: Codable {

  /// Title
  public let title: String?
  
  /// Value
  public let value: String?
  
  /// URL if there is
  public let url: String?
}

/// Tickets object
struct Tickets: CodableResponsableWithData {
  
  typealias Data = Ticket
  
  let statusCode: Int
  let data: [Data]
}
