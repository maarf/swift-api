//
//  DeviceEventResponse.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 28/02/2018.
//

import Foundation

/// TV device response container
public struct DeviceEventResponse: EventResponsable, Codable {
  public typealias Data = TVDevice
  
  public var subscriptionId: String
  public var messageId: Int
  public var data: Data
}
