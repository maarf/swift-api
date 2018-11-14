//
//  TVApiData.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 18/07/2017.
//
//

import Foundation

/// TV API data status
public enum TVAPIDataStatus: String, Codable {
  
  /// Not paired
  case notPaired = "NOT_PAIRED"
  
  /// Paired
  case paired = "PAIRED"
}

/// TV device API data
public struct TVAPIData: Responsable {
  
  public var statusCode: Int?
  
  /// TV API data status
  public let status: TVAPIDataStatus
  
  /// TV ID. Omitted when status is "NOT_PAIRED"
  public let id: Int?
  
  /// API key. Omitted when status is "NOT_PAIRED"
  public let apiKey: String?
  
  /// Location ID. Omitted when status is "NOT_PAIRED"
  public let location: Int?

}
