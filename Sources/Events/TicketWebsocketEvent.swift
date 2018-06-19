//
//  TicketEvent.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 13/06/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Ticket events
public enum TicketWebsocketEvent: String {
  
  /// Ticket created
  case created = "TICKET_CREATED"
  
  /// Ticket called
  case called = "TICKET_CALLED"
  
  /// Ticke recalled
  case recalled = "TICKET_RECALLED"
  
  /// Ticket cancelled
  case cancelled = "TICKET_CANCELLED"
  
  /// Ticket served
  case served = "TICKET_SERVED"
  
  /// Ticket changed
  case changed = "TICKET_CHANGED"
}
