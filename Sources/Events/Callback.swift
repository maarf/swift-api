//
//  Callback.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 12/06/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Qminder events callback
internal enum Callback {
  
  /// Ticket callback
  case ticket(EventsCallbackType<Ticket>)
  
  /// Device callback
  case device(EventsCallbackType<TVDevice?>)
  
  /// Line callback
  case line(EventsCallbackType<[Line]>)
}
