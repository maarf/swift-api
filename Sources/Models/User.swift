//
//  User.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

/// User object
public struct User: Responsable {
  
  internal var statusCode: Int?
  
  /// User ID
  public let id: Int
  
  /// Email address
  public let email: String
  
  /// 	First name
  public let firstName: String
  
  /// Last name
  public let lastName: String
  
  /// Selected desk number
  public let desk: Int?
  
  /// User roles
  public let roles: [Role]?
  
  /// User pictures
  public let picture: [Picture]?
}

/// User role object
public struct Role: Codable {
  
  /// User's role
  public let type: String?
  
  /// The identifier of the location where given role is applicable. Not applicable to all roles
  public let location: Int?
}

/// User image object
public struct Picture: Codable {
  
  /// Picture size
  public let size: String?
  
  /// Picture URL
  public let url: String?
}

/// Tickets object
struct Users: ResponsableWithData {
  
  static var dataContainer = \Users.data
  
  internal let statusCode: Int?
  let data: [User]
}
