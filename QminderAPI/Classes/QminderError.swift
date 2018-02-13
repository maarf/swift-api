//
//  Errors.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 05/12/2016.
//
//

import Foundation

/// Qminder API errors
public enum QminderError: Error {

  /// API key is not set
  case apiKeyNotSet
  
  /// Request error
  case request(Error)
  
  /// Cant parse object
  case unreadableObject
  
  /// Status code error
  case statusCode(Int)
  
  /// Can't parse to response
  case parseRequest
}
