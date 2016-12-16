//
//  User.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

import ObjectMapper

public struct User: Mappable {
  
  public var id: Int?
  public var email: String?
  public var firstName: String?
  public var lastName: String?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    id <- (map["id"], transformID)
    email <- map["email"]
    firstName <- map["firstName"]
    lastName <- map["lastName"]
  }
}

struct Users: Mappable {
  var users: Array<User>?
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    users <- map["data"]
  }
}
