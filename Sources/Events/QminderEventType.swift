//
//  QminderEventType.swift
//  Alamofire
//
//  Created by Kristaps Grinbergs on 06/10/2017.
//

import Foundation

/// Qminder Event type
public enum QminderEvent: String {
  /// Ticket created
  case ticketCreated = "TICKET_CREATED"
  
  /// Ticket called
  case ticketCalled = "TICKET_CALLED"
  
  /// Ticke recalled
  case ticketRecalled = "TICKET_RECALLED"
  
  /// Ticket cancelled
  case ticketCancelled = "TICKET_CANCELLED"
  
  /// Ticket served
  case ticketServed = "TICKET_SERVED"
  
  /// Ticket changed
  case ticketChanged = "TICKET_CHANGED"
  
  /// Overview monitor change
  case overviewMonitorChange = "OVERVIEW_MONITOR_CHANGE"
  
  /// Lines changed
  case linesChanged = "LINES_CHANGED"
}
