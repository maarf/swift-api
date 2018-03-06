//
//  Result.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 18/07/2017.
//
//

import Foundation

/// Qminder result
public enum Result<Value, Error: Swift.Error>: ResultProtocol {
  
  /// Success
  case success(Value)
  
  /// Failure with Error
  case failure(Error)
}
