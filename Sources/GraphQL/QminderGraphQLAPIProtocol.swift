//
//  QminderGraphQLAPIProtocol.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 15/10/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Location details type
public typealias LocationDetails = (lines: [Line], desks: [Desk]?)

/// Qminder GraphQL API protocol
public protocol QminderGraphQLAPIProtocol {
  
  /// Get location details using GraphQL
  ///
  /// - Parameters:
  ///   - locationID: Location ID
  ///   - completion: Closure called when data is retrieved correctly
  func locationDetails(locationID: Int, completion: @escaping (Result<LocationDetails, QminderError>) -> Void)
}
