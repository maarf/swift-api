//
//  Location.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

/// Location object
public struct Location: Responsable {
  
  internal var statusCode: Int?

  /// A unique location ID
  public let id: Int?
  
  /// Name of a location
  public let name: String?
  
  /// Latitude
  public let latitude: Double?
  
  /// Longitude
  public let longitude: Double?
  
  /// Offset from UTC timezone in minutes
  public let timezoneOffset: Int?
  
}

/// Locations object
struct Locations: ResponsableWithData {

  static var dataContainer = \Locations.data
  
  /// Status code from API
  internal let statusCode: Int?

  /// Locations data from API
  let data: [Location]
}
