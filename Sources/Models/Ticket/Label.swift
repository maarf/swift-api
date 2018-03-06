//
//  Label.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 01/02/2018.
//

import Foundation

/// Label object
public struct Label: Codable {
  
  /// Label hex color code
  public let color: String
  
  /// Value
  public let value: String
}
