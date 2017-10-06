//
//  Line.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

/// Line Object
public struct Line: Codable {
  
  /// ID of a line
  public let id: Int
  
  /// Name of a line
  public let name: String
  
  /// ID of the location this line belongs to
  public let location: Int?
}


/// Lines object
struct Lines: CodableResponsableWithData {
  
  typealias Data = Line

  /// Status code from API
  let statusCode: Int
  
  /// Lines array
  var data: [Data]
  
}
