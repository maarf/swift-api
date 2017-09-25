//
//  Device.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 27/02/2017.
//
//

import Foundation

/// User object
public struct TVDevice: CodableResponsable {
  
  let statusCode: Int

  /// Device ID
  public let id: Int
  
  /// Device name
  public let name: String
  
  /// Created data
  public let settings: Settings?
  
  /// Theme
  public let theme: String
}

/// Created data object
public struct Settings: Codable {

  /// Selected line ID
  public let selectedLine: Int?
  
  /// Selected lines ID array
  public let lines: [Int]?
  
  /// Clear tickets afterCalling or afterServing
  public let clearTickets: String?
}
