//
//  Desk.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 29/01/2018.
//

import Foundation

/// Desk object
public struct Desk: Codable {
  
  /// Desk ID
  public let id: Int
  
  /// Desk name
  public let name: String
}

protocol DesksResponsable: Responsable {
  /// Data with API request
  associatedtype Data
  
  /// Desks from API
  var desks: [Data] { get }
}

/// Desks object
struct Desks: ResponsableWithData {
  
  static var dataContainer = \Desks.desks
  
  internal let statusCode: Int?
  let desks: [Desk]
}
