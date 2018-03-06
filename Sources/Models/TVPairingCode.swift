//
//  PairingData.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 18/07/2017.
//
//

import Foundation

/// TV pairing code data
public struct TVPairingCode: CodableResponsable {
  
  let statusCode: Int
  
  /// Pairing code for enduser to enter to the Dashboard
  public let code: String
  
  /// Secret to use for checking the status of the pairing process
  public let secret: String
}
