//
//  TicketEventResponse.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 28/02/2018.
//

import Foundation

/// Ticket response container
public struct TicketEventResponse: EventResponsable, Codable {
  public typealias Data = Ticket
  
  public var subscriptionId: String
  public var messageId: Int
  public var data: Data
}
