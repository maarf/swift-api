//
//  QminderEventType.swift
//  Alamofire
//
//  Created by Kristaps Grinbergs on 06/10/2017.
//

import Foundation

/// Qminder Websocket Event type
public enum QminderWebsocketEvent {
  
  /// Ticket events
  case ticket(TicketWebsocketEvent)
  
  /// Device events
  case device(DeviceWebsocketEvent)
  
  /// Line events
  case line(LineWebsocketEvent)
}

extension QminderWebsocketEvent: CustomStringConvertible {
  public var description: String {
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
