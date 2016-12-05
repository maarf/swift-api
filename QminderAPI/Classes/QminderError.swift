//
//  Errors.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 05/12/2016.
//
//

import Foundation

/// Qminder API errors
public enum QminderError : Error {

  /// API key is not set
  case apiKeyNotSet
  
  /// Alamofire error
  case alamofire(Error)
}
