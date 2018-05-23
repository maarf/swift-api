//
//  QminderEventsProtocol.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 10/05/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Callback type when subscrubing to evenets
public typealias EventsCallbackType<T> = (Result<T, QminderError>) -> Void

/// Qminder Events protocol
public protocol QminderEventsProtocol {
  /// Class delegate
  var delegate: QminderEventsDelegate? { get set }
  
  /**
   Open websocket
  */
  func openSocket()
  
  /**
   Reopen websocket
  */
  func reOpenSocket()
  
  /**
   Close websocket connection
  */
  func closeConnection()
  
  /**
   Subscribe to ticket event
   
   - Parameters:
   - eventType: Event type to subscribe
   - parameters: Dictionary of parameters
   - callback: Callback executed when response got from Websocket
   */
  func subscribe(toTicketEvent eventType: QminderEvent,
                 parameters: [String: Any], callback: @escaping EventsCallbackType<Ticket>)
  
  /**
   Subscribe to device event
   
   - Parameters:
   - eventType: Event type to subscribe
   - parameters: Dictionary of parameters
   - callback: Callback executed when response got from Websocket
   */
  func subscribe(toDeviceEvent eventType: QminderEvent,
                 parameters: [String: Any], callback: @escaping EventsCallbackType<TVDevice?>)
  
  /**
   Subscribe to lines event
   
   - Parameters:
   - eventType: Event type to subscribe
   - parameters: Dictionary of parameters
   - callback: Callback executed when response got from Websocket
   */
  func subscribe(toLineEvent eventType: QminderEvent,
                 parameters: [String: Any], callback: @escaping EventsCallbackType<[Line]>)
}
