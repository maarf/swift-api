//
//  Location.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

/// Location object
public struct Location: Codable {

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
struct Locations: CodableResponsableWithData {

  typealias Data = Location
  
  let statusCode: Int

  let data: [Data]
}
