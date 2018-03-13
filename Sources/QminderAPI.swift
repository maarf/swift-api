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
  
  public func getLocationsList(completion: @escaping (Result<[Location], QminderError>) -> Void) {
    fetch(.locations, decodingType: Locations.self) { completion($0) }
  }
  
  public func getLocationDetails(locationId: Int, completion: @escaping (Result<Location, QminderError>) -> Void) {
    fetch(.location(locationId), decodingType: Location.self) { completion($0) }
  }
  
  public func getLocationLines(locationId: Int, completion: @escaping (Result<[Line], QminderError>) -> Void) {
    fetch(.lines(locationId), decodingType: Lines.self) { completion($0) }
  }
  
  public func getLocationUsers(locationId: Int, completion: @escaping (Result<[User], QminderError>) -> Void) {
    fetch(.users(locationId), decodingType: Users.self) { completion($0) }
  }
  
  public func getLocationDesks(locationId: Int, completion: @escaping (Result<[Desk], QminderError>) -> Void) {
    fetch(.desks(locationId), decodingType: Desks.self) { completion($0) }
  }
  
  public func getLineDetails(lineId: Int, completion: @escaping (Result<Line, QminderError>) -> Void) {
    fetch(.line(lineId), decodingType: Line.self) { completion($0) }
  }
  
  public func searchTickets(locationId: Int? = nil, lineId: Set<Int>? = nil, status: Set<Status>? = nil,
                            callerId: Int? = nil, minCreatedTimestamp: Int? = nil, maxCreatedTimestamp: Int? = nil,
                            minCalledTimestamp: Int? = nil, maxCalledTimestamp: Int? = nil,
                            limit: Int? = nil, order: String? = nil, responseScope: Set<String>? = nil,
                            completion: @escaping (Result<[Ticket], QminderError>) -> Void) {
    
    var parameters = [String: Any]()
    
    parameters.set(value: locationId, forKey: "location")
    parameters.set(value: lineId?.flatMap({ String($0) }).joined(separator: ","), forKey: "line")
    parameters.set(value: status?.flatMap({ $0.rawValue }).joined(separator: ","), forKey: "status")
    parameters.set(value: callerId, forKey: "caller")
    parameters.set(value: minCreatedTimestamp, forKey: "minCreated")
    parameters.set(value: maxCreatedTimestamp, forKey: "maxCreated")
    parameters.set(value: minCalledTimestamp, forKey: "minCalled")
    parameters.set(value: maxCalledTimestamp, forKey: "maxCalled")
    parameters.set(value: limit, forKey: "limit")
    parameters.set(value: order, forKey: "order")
    parameters.set(value: responseScope?.flatMap({ String($0) }).joined(separator: ","), forKey: "responseScope")
    
    fetch(.tickets(parameters), decodingType: Tickets.self) { completion($0) }
  }
  
  public func getTicketDetails(ticketId: String, completion: @escaping (Result<Ticket, QminderError>) -> Void) {
    fetch(.ticket(ticketId), decodingType: Ticket.self) { completion($0) }
  }
  
  public func getUserDetails(userId: Int, completion: @escaping (Result<User, QminderError>) -> Void) {
    fetch(.user(userId), decodingType: User.self) { completion($0) }
  }
  
  public func getPairingCodeAndSecret(completion: @escaping (Result<TVPairingCode, QminderError>) -> Void) {
    fetch(.tvCode, decodingType: TVPairingCode.self) { completion($0) }
  }
  
  public func pairTV(code: String, secret: String, completion: @escaping (Result<TVAPIData, QminderError>) -> Void) {
    fetch(.tvPairingStatus(code, ["secret": secret]), decodingType: TVAPIData.self) { completion($0) }
  }
  
  public func tvDetails(id: Int, completion: @escaping (Result<TVDevice, QminderError>) -> Void) {
    fetch(.tvDetails(id), decodingType: TVDevice.self) { completion($0) }
  }
  
  public func tvHeartbeat(id: Int, metadata: [String: Any],
                          completion: @escaping (Result<Void?, QminderError>) -> Void) {
    fetch(.tvHeartbeat(id, metadata)) { completion($0) }
  }
  
  public func tvEmptyState(id: Int, language: String,
                           completion: @escaping (Result<EmptyState, QminderError>) -> Void) {
    fetch(.tvEmptyState(id, ["language": language]), decodingType: EmptyState.self) { completion($0) }
  }
}
