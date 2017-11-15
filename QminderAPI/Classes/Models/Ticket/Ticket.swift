//
//  Ticket.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

//MARK: - Protocols

/// Ticket describing protocol
public protocol Ticketable: Codable {
  
  /// A unique ticket ID
  var id: String { get }
  
  /// Ticket number
  var number: Int? { get }
  
  /// Line ID
  var line: Int { get set }
  
  /// Source of the ticket. "MANUAL", "NAME" or "PRINTER". This field will not be present if no source has been specified when creating a ticket.
  var source: Source { get }
  
  /// Ticket status
  var status: Status { get set }
  
  /// First name
  var firstName: String? { get set }
  
  /// Last name
  var lastName: String? { get set }
  
  /// Phone number
  var phoneNumber: Int? { get set }
  
  /// Created date
  var created: Created { get }
  
  /// Called date
  var called: Called? { get set }
  
  /// Served date
  var served: Served? { get set }
  
  /// Labels
  var labels: Array<Label>? { get set }
  
  /// Extra info
  var extra: Array<Extra>? { get set }
  
  /// Order after
  var orderAfter: Date? { get set }
}

public extension Ticketable {
  
  /// Creted date
  public var createdDate: Date {
    return created.date
  }
  
  /// Called date
  public var calledDate: Date? {
    return called?.date
  }
  
  /// Served date
  public var servedDate: Date? {
    return served?.date
  }
}

//MARK: - Structs
/// Ticket mapping object
public struct Ticket: Ticketable {
  public let id: String
  public let number: Int?
  public var line: Int
  public let source: Source
  public var status: Status
  public var firstName: String?
  public var lastName: String?
  public var phoneNumber: Int?
  public var created: Created
  public var called: Called?
  public var served: Served?
  public var labels: Array<Label>?
  public var extra: Array<Extra>?
  public var orderAfter: Date?
}
