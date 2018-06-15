//
//  WebsocketMessage.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 12/06/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Websocket message
internal struct WebsocketMessage {
  
  /// Unique subscribtion ID
  var subscriptionId: String
  
  /// Qminder event
  var eventType: QminderWebsocketEvent
  
  /// String message what should be sent to Websocket
  var messageToSend: String
  
  /// Callback block
  var callback: Callback
}
