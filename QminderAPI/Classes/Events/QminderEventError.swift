//
//  QminderEventError.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 26/02/2018.
//

import Foundation

/// Qminder Event error
public enum QminderEventError: Error {
  
  /// Simple error
  case error(Error)
  
  /// Parsing error
  case parse
}
