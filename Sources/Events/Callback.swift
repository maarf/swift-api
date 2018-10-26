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
  case ticket((QminderResult<Ticket, QminderError>) -> Void)
  
  /// Device callback
  case device((QminderResult<TVDevice?, QminderError>) -> Void)
  
  /// Line callback
  case line((QminderResult<[Line], QminderError>) -> Void)
}
