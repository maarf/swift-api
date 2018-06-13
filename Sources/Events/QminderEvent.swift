//
//  QminderEventType.swift
//  Alamofire
//
//  Created by Kristaps Grinbergs on 06/10/2017.
//

import Foundation

/// Qminder Event type
public enum QminderEvent {
  
  /// Ticket events
  case ticket(TicketEvent)
  
  /// Device events
  case device(DeviceEvent)
  
  /// Line events
  case line(LineEvent)
  
  /// String value for event
  var value: String {
    switch self {
    case .ticket(let ticketEvent):
      return ticketEvent.rawValue
    case .device(let deviceEvent):
      return deviceEvent.rawValue
    case .line(let lineEvent):
      return lineEvent.rawValue
    }
  }
}
