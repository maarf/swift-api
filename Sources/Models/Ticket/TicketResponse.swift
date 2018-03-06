//
//  TicketResponse.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 14/11/2017.
//

import Foundation

/// Protocl for API Response
protocol Responsable {
  
  /// Status code
  var statusCode: Int { get }
}

/// Protocol to describe API response
protocol ResponsableWithData: Responsable {
  
  /// Data with API request
  associatedtype Data
  
  /// Data from API
  var data: [Data] { get }
}

/// Type for Codable & Responsable
typealias CodableResponsable = (Codable & Responsable)

/// Type for Codable and Responsable With Data
typealias CodableResponsableWithData = (Codable & ResponsableWithData)

/// Tickets object
struct Tickets: CodableResponsableWithData {
  
  typealias Data = Ticket
  
  let statusCode: Int
  let data: [Data]
}
