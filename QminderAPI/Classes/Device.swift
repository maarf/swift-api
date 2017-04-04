//
//  Device.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 27/02/2017.
//
//

import Foundation

import ObjectMapper

/// User object
public struct TVDevice: Mappable {

  /// Device ID
  public var id: Int?
  
  /// Device name
  public var name: String?
  
  /// Created data
  public var settings: Settings?
  
  /// Theme
  public var theme: String?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    settings <- map["settings"]
    theme <- map["theme"]
  }

}

/// Created data object
public struct Settings: Mappable {

  /// Selected line ID
  public var selectedLine: Int?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    selectedLine <- map["selectedLine"]
  }
}
