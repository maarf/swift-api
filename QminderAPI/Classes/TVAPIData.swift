//
//  TVApiData.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 18/07/2017.
//
//

import Foundation

import ObjectMapper

/// TV device API data
public struct TVAPIData: Mappable {
  
  /// "NOT_PAIRED" or "PAIRED"
  public var status: String?
  
  /// TV ID. Omitted when status is "NOT_PAIRED"
  public var id: Int?
  
  /// API key. Omitted when status is "NOT_PAIRED"
  public var apiKey: String?
  
  // Location ID. Omitted when status is "NOT_PAIRED"
  public var locationID: Int?
  
  
  public init?(map: Map) {}
  
  public mutating func mapping(map: Map) {
    status <- map["status"]
    id <- map["id"]
    apiKey <- map["apiKey"]
    locationID <- map["location"]
  }
}
