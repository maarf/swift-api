//
//  Line.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

/// Line Object
public struct Line: Responsable {
  
  var statusCode: Int?
  
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
