//
//  QminderGraphQLAPIProtocol.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 15/10/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Location details type
public struct LocationDetails {
  public let lines: [Line]
  public let desks: [Desk]?
  
  init(_ lines: [Line], _ desks: [Desk]?) {
    self.lines = lines
    self.desks = desks
  }
}

/// Qminder GraphQL API protocol
public protocol QminderGraphQLAPIProtocol {
  
  /// Get location details using GraphQL
  ///
  /// - Parameters:
  ///   - locationID: Location ID
  ///   - completion: Closure called when data is retrieved correctly
  func locationDetails(_ locationID: Int, completion: @escaping (Result<LocationDetails, QminderError>) -> Void)
}
