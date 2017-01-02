//
//  Line.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

import ObjectMapper


/// Line Object
public class Line: Mappable {
  
  /// ID of a line
  public var id: Int?
  
  /// Name of a line
  public var name: String?
  
  /// ID of the location this line belongs to
  public var location: Int?
  
  public required init?(map: Map) {}
  
  public func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    location <- map["location"]
  }
}


/// Lines object
struct Lines: Mappable {

  /// Lines array
  var lines: Array<Line>?
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    lines <- map["data"]
  }
}
