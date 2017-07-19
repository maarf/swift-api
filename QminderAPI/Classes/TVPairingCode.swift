//
//  PairingData.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 18/07/2017.
//
//

import Foundation

import ObjectMapper

/// TV pairing code data
public struct TVPairingCode: Mappable {
  
  /// 4-character code for enduser to enter to the Dashboard
  public var code: String?
  
  /// Secret to use for checking the status of the pairing process
  public var secret: String?
  
  
  public init?(map: Map) {}
  
  public mutating func mapping(map: Map) {
    code <- map["code"]
    secret <- map["secret"]
  }
}
