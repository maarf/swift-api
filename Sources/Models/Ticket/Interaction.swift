//
//  Interaction.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 01/02/2018.
//

import Foundation

/// Ticket interaction
public struct Interaction: Codable {
  
  /// Interaction start
  public let start: Date
  
  /// Interaction end
  public let end: Date?
  
  /// Line ID
  public let line: Int
  
  /// Desk ID
  public let desk: Int?
  
  /// User ID
  public let user: Int?
  
}
