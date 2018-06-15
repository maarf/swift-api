//
//  DeviceEvent.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 13/06/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Device events
public enum DeviceWebsocketEvent: String {
  
  /// Overview monitor changed
  case overviewMonitorChange = "OVERVIEW_MONITOR_CHANGE"
}
