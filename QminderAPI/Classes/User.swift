//
//  User.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

import ObjectMapper

/// User object
public struct User: Mappable {
  
  /// User ID
  public var id: Int?
  
  /// Email address
  public var email: String?
  
  /// 	First name
  public var firstName: String?
  
  /// Last name
  public var lastName: String?
  
  /// Selected desk number
  public var desk: Int?
  
  /// User roles
  public var roles: Array<Role>?
  
  /// User pictures
  public var picture: Array<Picture>?
  
  public init?(map: Map) {}
  
  public mutating func mapping(map: Map) {
    id <- map["id"]
    email <- map["email"]
    firstName <- map["firstName"]
    lastName <- map["lastName"]
    desk <- map["desk"]
    roles <- map["roles"]
    picture <- map["picture"]
  }
}

/// User role object
public struct Role: Mappable {
  
  /// User's role
  public var type: String?
  
  /// The identifier of the location where given role is applicable. Not applicable to all roles
  public var location: Int?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    type <- map["type"]
    location <- map["location"]
  }
}

/// User image object
public struct Picture: Mappable {
  
  /// Picture size
  public var size: String?
  
  /// Picture URL
  public var url: String?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    size <- map["size"]
    url <- map["url"]
  }
}

/// Users object
struct Users: Mappable {

  /// Users array
  var users: Array<User>?
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    users <- map["data"]
  }
}
