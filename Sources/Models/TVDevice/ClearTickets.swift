//
//  ClearTickets.swift
//  QminderAPI-iOS
//
//  Created by Kristaps Grinbergs on 17/04/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Clear tickets from screen
public enum ClearTickets: String, Codable {
  
  /// After calling
  case afterCalling
  
  /// After serving
  case afterServing
}
