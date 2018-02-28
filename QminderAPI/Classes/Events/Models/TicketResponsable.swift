//
//  TicketResponsable.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 28/02/2018.
//

import Foundation

/// Ticket response container
struct TicketResponsable: EventResponsable, Codable {
  typealias Data = Ticket
  
  var subscriptionId: String
  var messageId: Int
  var data: Data
}
