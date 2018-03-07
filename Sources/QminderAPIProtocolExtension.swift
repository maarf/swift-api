//
//  QminderAPIProtocolExtension.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 07/03/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

extension QminderAPIProtocol {
  
  public func getLocationsList(completion: @escaping (Result<[Location], QminderError>) -> Void) {
    makeRequest(url: "/locations/") { result in
      switch result {
      case let .failure(error):
        return completion(Result.failure(error))
        
      case let .success(data):
        guard let locations = try? JSONDecoder().decode(Locations.self, from: data).data else {
          return completion(Result.failure(QminderError.unreadableObject))
        }
        
        return completion(Result.success(locations))
      }
    }
  }
  
  public func getLocationDetails(locationId: Int, completion: @escaping (Result<Location, QminderError>) -> Void) {
    makeRequest(url: "/locations/\(locationId)") { result in
      switch result {
      case let .failure(error):
        return completion(Result.failure(error))
        
      case let .success(data):
        guard let location = try? JSONDecoder().decode(Location.self, from: data) else {
          return completion(Result.failure(QminderError.unreadableObject))
        }
        
        return completion(Result.success(location))
      }
    }
  }
  
  public func getLocationLines(locationId: Int, completion: @escaping (Result<[Line], QminderError>) -> Void) {
    makeRequest(url: "/locations/\(locationId)/lines") {result in
      switch result {
      case let .failure(error):
        return completion(Result.failure(error))
        
      case let .success(data):
        
        guard let lines = try? JSONDecoder().decode(Lines.self, from: data).data else {
          return completion(Result.failure(QminderError.unreadableObject))
        }
        
        return completion(Result.success(lines))
      }
    }
  }
  
  public func getLocationUsers(locationId: Int, completion: @escaping (Result<[User], QminderError>) -> Void) {
    makeRequest(url: "/locations/\(locationId)/users") {result in
      switch result {
      case let .failure(error):
        return completion(Result.failure(error))
        
      case let .success(data):
        guard let users = try? JSONDecoder().decode(Users.self, from: data).data else {
          return completion(Result.failure(QminderError.unreadableObject))
        }
        
        return completion(Result.success(users))
      }
    }
  }
  
  public func getLocationDesks(locationId: Int, completion: @escaping (Result<[Desk], QminderError>) -> Void) {
    makeRequest(url: "/locations/\(locationId)/desks") { result in
      switch result {
      case let .failure(error):
        return completion(Result.failure(error))
        
      case let .success(data):
        guard let desks = try? JSONDecoder().decode(Desks.self, from: data).desks else {
          return completion(Result.failure(QminderError.unreadableObject))
        }
        
        return completion(Result.success(desks))
      }
    }
  }
  
  public func getLineDetails(lineId: Int, completion: @escaping (Result<Line, QminderError>) -> Void) {
    
    makeRequest(url: "/lines/\(lineId)") { result in
      switch result {
      case let .failure(error):
        return completion(Result.failure(error))
        
      case let .success(data):
        guard let line = try? JSONDecoder().decode(Line.self, from: data) else {
          return completion(Result.failure(QminderError.unreadableObject))
        }
        
        return completion(Result.success(line))
      }
    }
  }
  
  public func searchTickets(locationId: Int? = nil, lineId: [Int]? = nil, status: [Status]? = nil,
                            callerId: Int? = nil, minCreatedTimestamp: Int? = nil, maxCreatedTimestamp: Int? = nil,
                            minCalledTimestamp: Int? = nil, maxCalledTimestamp: Int? = nil,
                            limit: Int? = nil, order: String? = nil, responseScope: [String]? = nil,
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
    
    makeRequest(url: "/tickets/search", parameters: parameters) { result in
      switch result {
      case let .failure(error):
        return completion(Result.failure(error))
        
      case let .success(data):
        guard let tickets = try? JSONDecoder.withMilliseconds.decode(Tickets.self, from: data).data else {
          return completion(Result.failure(QminderError.unreadableObject))
        }
        
        return completion(Result.success(tickets))
      }
    }
  }
  
  public func getTicketDetails(ticketId: String, completion: @escaping (Result<Ticket, QminderError>) -> Void) {
    makeRequest(url: "/tickets/\(ticketId)") { result in
      switch result {
      case let .failure(error):
        return completion(Result.failure(error))
        
      case let .success(data):
        guard let ticket = try? JSONDecoder.withMilliseconds.decode(Ticket.self, from: data) else {
          return completion(Result.failure(QminderError.unreadableObject))
        }
        
        return completion(Result.success(ticket))
      }
    }
  }
  
  public func getUserDetails(userId: Int, completion: @escaping (Result<User, QminderError>) -> Void) {
    makeRequest(url: "/users/\(userId)") { result in
      switch result {
      case let .failure(error):
        return completion(Result.failure(error))
        
      case let .success(data):
        guard let user = try? JSONDecoder().decode(User.self, from: data) else {
          return completion(Result.failure(QminderError.unreadableObject))
        }
        
        return completion(Result.success(user))
      }
    }
  }
  
  public func getPairingCodeAndSecret(completion: @escaping (Result<TVPairingCode, QminderError>) -> Void) {
    makeRequest(url: "/tv/code", apiKeyNeeded: false) { result in
      switch result {
      case let .failure(error):
        return completion(Result.failure(error))
        
      case let .success(data):
        guard let pairingData = try? JSONDecoder().decode(TVPairingCode.self, from: data) else {
          return completion(Result.failure(QminderError.unreadableObject))
        }
        
        return completion(Result.success(pairingData))
      }
    }
  }
  
  public func pairTV(code: String, secret: String, completion: @escaping (Result<TVAPIData, QminderError>) -> Void) {
    
    makeRequest(url: "/tv/code/\(code)", parameters: ["secret": secret], apiKeyNeeded: false) { result in
      switch result {
      case let .failure(error):
        return completion(Result.failure(error))
        
      case let .success(data):
        guard let tvAPIData = try? JSONDecoder().decode(TVAPIData.self, from: data) else {
          return completion(Result.failure(QminderError.unreadableObject))
        }
        
        return completion(Result.success(tvAPIData))
      }
    }
  }
  
  public func tvDetails(id: Int, completion: @escaping (Result<TVDevice, QminderError>) -> Void) {
    makeRequest(url: "/tv/\(id)") { result in
      
      switch result {
      case let .failure(error):
        return completion(Result.failure(error))
        
      case let .success(data):
        guard let device = try? JSONDecoder().decode(TVDevice.self, from: data) else {
          return completion(Result.failure(QminderError.unreadableObject))
        }
        
        return completion(Result.success(device))
      }
    }
  }
  
  public func tvHeartbeat(id: Int, metadata: [String: Any],
                          completion: @escaping (Result<Void?, QminderError>) -> Void) {
    
    let parameters = metadata
    
    makeRequest(url: "/tv/\(id)/heartbeat", method: .post, parameters: parameters, encoding: .json) { result in
      switch result {
      case let .failure(error):
        return completion(Result.failure(error))
        
      case .success:
        return completion(Result.success(nil))
      }
    }
    
  }
  
  public func tvEmptyState(id: Int, language: String,
                           completion: @escaping (Result<EmptyState, QminderError>) -> Void) {
    
    var parameters = [String: Any]()
    parameters.set(value: language, forKey: "language")
    
    makeRequest(url: "/tv/\(id)/emptystate", method: .get, parameters: parameters) { result in
      switch result {
      case let .failure(error):
        return completion(Result.failure(error))
        
      case let .success(data):
        guard let emptyState = try? JSONDecoder().decode(EmptyState.self, from: data) else {
          return completion(Result.failure(QminderError.unreadableObject))
        }
        
        return completion(Result.success(emptyState))
      }
    }
    
  }
  
  func makeRequest(url: String, method: HTTPMethod = .get, parameters: [String: Any] = [:],
                   encoding: ParameterEncoding = .none, apiKeyNeeded: Bool = true,
                   completion: @escaping (Result<Data, QminderError>) -> Void) {
    var url = URLComponents(string: "\(serverAddress)\(url)")!
    
    if encoding == .none {
      url.queryItems = parameters.map {
        URLQueryItem(name: $0, value: String(describing: $1))
      }
    }
    
    var request = URLRequest(url: url.url!)
    request.httpMethod = method.rawValue
    
    if apiKeyNeeded {
      guard let key = apiKey else {
        return completion(Result.failure(QminderError.apiKeyNotSet))
      }
      
      request.setValue(key, forHTTPHeaderField: "X-Qminder-REST-API-Key")
    }
    
    if encoding == .json {
      let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
      
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.setValue("application/json", forHTTPHeaderField: "Accept")
      request.httpBody = jsonData
    }
    
    request.printCurlString()
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      DispatchQueue.main.async {
        if let error = error {
          return completion(Result.failure(QminderError.request(error)))
        } else {
          
          guard let httpResponse = response as? HTTPURLResponse, let resultData = data else {
            return completion(Result.failure(QminderError.parseRequest))
          }
          
          if httpResponse.statusCode != 200 {
            return completion(Result.failure(QminderError.statusCode(httpResponse.statusCode)))
          }
          
          return completion(Result.success(resultData))
        }
      }
      }.resume()
  }
}
