//
//  QminderEventsDelegate.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 26/02/2018.
//

import Foundation

/// QminderEvents delagate methods
public protocol QminderEventsDelegate: class {
  
  /// Called when connected to Websocket
  func onConnected()
  
  /// Called when disconnected from Websocket
  ///
  /// - Parameter error: Error why it got disconnected
  func onDisconnected(error: Error?)
  
}
