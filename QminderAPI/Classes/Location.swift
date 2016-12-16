//
//  Location.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

import ObjectMapper

/// Location object
public struct Location: Mappable {

  /// A unique location ID
  public var id: Int?
  
  /// Name of a location
  public var name: String?
  
  /// Latitude
  public var latitude: Double?
  
  /// Longitude
  public var longitude: Double?
  
  /// Offset from UTC timezone in minutes
  public var timezoneOffset: Int?

  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    latitude <- map["latitude"]
    longitude <- map["longitude"]
    timezoneOffset <- map["timezoneOffset"]
  }
  
}


/// Locations object
struct Locations: Mappable {

  /// Locations array
  var locations: Array<Location>?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    locations <- map["data"]
  }
}
