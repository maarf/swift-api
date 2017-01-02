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
public class User: Mappable {
  
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
  
  /// User role
  public var roles: Array<Role>?
  
  public required init?(map: Map) {}
  
  public func mapping(map: Map) {
    id <- map["id"]
    email <- map["email"]
    firstName <- map["firstName"]
    lastName <- map["lastName"]
    desk <- (map["desk"], transformFromStringToInt)
    roles <- map["roles"]
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

/// Users object
struct Users: Mappable {

  /// Users array
  var users: Array<User>?
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    users <- map["data"]
  }
}
