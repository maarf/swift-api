//
//  Location.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

import ObjectMapper

public struct Location: Mappable {

  public var id: Int?
  public var name: String?
  
  public var latitude: Double?
  public var longitude: Double?
  
  public var timezoneOffset: Int?

  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    id <- (map["id"], transformID)
    name <- map["name"]
    latitude <- map["latitude"]
    longitude <- map["longitude"]
    timezoneOffset <- map["timezoneOffset"]
  }
  
}

struct Locations: Mappable {
  var locations: Array<Location>?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    locations <- map["data"]
  }
}
