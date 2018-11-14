//
//  Responsable.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 09/03/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Protocl for API Response
public protocol Responsable: Codable {
  
  /// Status code
  var statusCode: Int? { get }
}

/// Protocol to describe API response
public protocol ResponsableWithData: Responsable {
  
  /// Data with API request
  associatedtype Data
  
  /// Data container key path
  static var dataContainer: KeyPath<Self, Data> { get }
  
  /// Data object
  var dataObject: Data { get }
}

public extension ResponsableWithData {
  
  /// Data object
  var dataObject: Data {
    return self[keyPath: Self.dataContainer]
  }
}
