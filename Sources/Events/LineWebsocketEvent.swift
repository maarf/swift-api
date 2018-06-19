//
//  LineEvent.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 13/06/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Line events
public enum LineWebsocketEvent: String {
  
  /// Lines changed
  case changed = "LINES_CHANGED"
}
