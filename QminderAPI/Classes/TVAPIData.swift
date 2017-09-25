//
//  TVApiData.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 18/07/2017.
//
//

import Foundation

/// TV device API data
public struct TVAPIData: CodableResponsable {
  
  let statusCode: Int
  
  /// "NOT_PAIRED" or "PAIRED"
  public let status: String
  
  /// TV ID. Omitted when status is "NOT_PAIRED"
  public let id: Int?
  
  /// API key. Omitted when status is "NOT_PAIRED"
  public let apiKey: String?
  
  // Location ID. Omitted when status is "NOT_PAIRED"
  public let location: Int?

}
