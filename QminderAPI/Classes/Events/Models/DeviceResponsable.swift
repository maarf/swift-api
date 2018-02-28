//
//  DeviceResponsable.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 28/02/2018.
//

import Foundation

/// TV device response container
struct DeviceResponsable: EventResponsable, Codable {
  typealias Data = TVDevice
  
  var subscriptionId: String
  var messageId: Int
  var data: Data
}
