//
//  User.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

/// User object
public struct User: Codable {
  
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
  public let roles: Array<Role>?
  
  /// User pictures
  public let picture: Array<Picture>?
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
struct Users: CodableResponsableWithData {
  typealias Data = User
  
  let statusCode: Int
  let data: [Data]
}
