//
//  TicketResponse.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 14/11/2017.
//

import Foundation

/// Tickets object
struct Tickets: ResponsableWithData {
  static var dataContainer = \Tickets.data
  
  internal let statusCode: Int?
  
  let data: [Ticket]
}
