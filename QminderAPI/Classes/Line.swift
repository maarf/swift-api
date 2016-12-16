//
//  Line.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

import ObjectMapper

public struct Line: Mappable {
  
  public var id: Int?
  public var name: String?
  
  public var location: Int?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    id <- (map["id"], transformID)
    name <- map["name"]
    location <- map["location"]
  }
}

struct Lines: Mappable {
  var lines: Array<Line>?
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    lines <- map["data"]
  }
}
