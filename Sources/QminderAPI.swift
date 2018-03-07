//
//  QminderAPI.swift
//  Pods
//
//  Created by Qminder on 24/10/2016.
//
//

import Foundation

/// Qminder API
public struct QminderAPI: QminderAPIProtocol {
  
  internal var apiKey: String?
  internal var serverAddress: String
  
  public init(apiKey: String? = nil, serverAddress: String = "https://api.qminder.com/v1") {
    self.apiKey = apiKey
    self.serverAddress = serverAddress
  }
}
