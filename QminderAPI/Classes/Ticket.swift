//
//  Ticket.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

/// Ticket mapping object
public struct Ticket: Codable {
  
  /// A unique ticket ID
  public let ticketId: String
  
  /// Ticket number
  public let number: Int?
  
  /// Line ID
  public var line: Int
  
  /// Source of the ticket. "MANUAL", "NAME" or "PRINTER". This field will not be present if no source has been specified when creating a ticket.
  public let source: String?
  
  /// Ticket status. "NEW", "CALLED", "CANCELLED", "CANCELLED_BY_CLERK", "NOSHOW" or "SERVED"
  public var status: String
  
  /// First name
  public var firstName: String?
  
  /// 	Last name
  public var lastName: String?
  
  /// Phone number
  public var phoneNumber: Int?
  
  /// Created data
  public var created: Created?
  
  /// Called data
  public var called: Called?
  
  /// Served data
  public var served: Served?
  
  /// Labels
  public var labels: Array<Label>?
  
  /// Extra info
  public var extra: Array<Extra>?
  
  /// Order after
  public var orderAfter: Date?
  
  enum CodingKeys: String, CodingKey {
    case ticketId = "id"
    
    case number
    case line
    case source
    case status
    case firstName
    case lastName
    case phoneNumber
    case created
    case called
    case served
    case labels
    case extra
    case orderAfter
  }
}

// Hack to get ticket ID as int
extension Ticket {
  public var id: Int? {
    guard let id = Int(self.ticketId) else { return nil }
    
    return id
  }
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
struct Tickets: Codable {
  
  /// Status code
  let statusCode: Int
  
  /// Tickets array
  let data: [Ticket]
}
