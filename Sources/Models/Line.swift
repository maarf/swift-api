//
//  Line.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 15/10/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Line Object
public struct Line: Responsable {
  
  public var statusCode: Int?
  
  /// ID of a line
  public let id: Int
  
  /// Name of a line
  public let name: String
  
  /// ID of the location this line belongs to
  public let location: Int?
}

/// Lines object
struct Lines: ResponsableWithData {
  
  static var dataContainer = \Lines.data
  
  /// Status code from API
  internal let statusCode: Int?
  
  /// Lines array
  let data: [Line]
}
