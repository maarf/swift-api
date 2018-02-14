//
//  QminderAPI.swift
//  Pods
//
//  Created by Qminder on 24/10/2016.
//
//

import Foundation


/// Qminder API for iOS in Swift
open class QminderAPI {

  /// Qminder API key
  fileprivate var apiKey: String?
  
  /// Qminder API address
  fileprivate var serverAddress: String
  
  /// JSON decoder with milliseconds
  fileprivate let jsonDecoderWithMilliseconds = JSONDecoder.withMilliseconds
  
  /**
    Initialize Qminder API without API key
   
    - Parameters:
      - serverAddress: Optional server address (used for tests)
  */
  public init(serverAddress: String = "https://api.qminder.com/v1") {
    self.serverAddress = serverAddress
  }
  
  /**
    Intialize Qminder API
   
    - Parameters:
      - apiKey: Qminder API key
      - serverAddress: Optional server address (used for tests)
  */
  public init(apiKey:String, serverAddress: String = "https://api.qminder.com/v1") {
    self.apiKey = apiKey
    self.serverAddress = serverAddress
  }
  
  // MARK: - Locations
  
  /**
    Get location list
    
    - Parameters:
      - completion: Callback block what is executed when location list is received
  */
  public func getLocationsList(completion: @escaping (Result<[Location]>) -> Void) {
  
    makeRequest(url: "/locations/", completion: {result in
      switch result {
        case .failure(let error):
          return completion(Result.failure(error))
        
        case .success(let data):
          
          guard let locations = try? JSONDecoder().decode(Locations.self, from: data).data else {
            return completion(Result.failure(QminderError.unreadableObject))
          }
          
          return completion(Result.success(locations))
      }
    })
  }
  
  /**
    Get location details
    
    - Parameters:
      - locationId: Location ID
      - completion: Callback block what is executed when location data is received
  */
  public func getLocationDetails(locationId:Int, completion: @escaping (Result<Location>) -> Void) {
  
    makeRequest(url: "/locations/\(locationId)", completion: {result in
      switch result {
        case .failure(let error):
          return completion(Result.failure(error))
        
        case .success(let data):
          
          guard let location = try? JSONDecoder().decode(Location.self, from: data) else {
            return completion(Result.failure(QminderError.unreadableObject))
          }
        
          return completion(Result.success(location))
      }
    })
  }
  
  /**
    Get Location Lines
    
    - Parameters:
      - locationId: Location ID
      - completion: Callback block what is executed when location lines is received
  */
  public func getLocationLines(locationId:Int, completion: @escaping (Result<[Line]>) -> Void) {
    
    makeRequest(url: "/locations/\(locationId)/lines", completion: {result in
      switch result {
        case .failure(let error):
          return completion(Result.failure(error))
        
        case .success(let data):
      
          guard let lines = try? JSONDecoder().decode(Lines.self, from: data).data else {
            return completion(Result.failure(QminderError.unreadableObject))
          }
          
          return completion(Result.success(lines))
        }
      })
  }
  
  /**
    Get location users
    
    - Parameters:
      - locationId: Location ID
      - completion: Callback block what is executed when location users is received
  */
  public func getLocationUsers(locationId: Int, completion: @escaping (Result<[User]>) -> Void) {
    
    makeRequest(url: "/locations/\(locationId)/users", completion: {result in
      switch result {
        case .failure(let error):
          return completion(Result.failure(error))
        
        case .success(let data):
          
          guard let users = try? JSONDecoder().decode(Users.self, from: data).data else {
            return completion(Result.failure(QminderError.unreadableObject))
          }
        
          return completion(Result.success(users))
      }
    })
  }
  
  /**
   Get location desks
   
   - Parameters:
     - locationId: Location ID
     - completion: Callback block what is executed when location users is received
  */
  public func getLocationDesks(locationId: Int, completion: @escaping (Result<[Desk]>) -> Void) {
    makeRequest(url: "/locations/\(locationId)/desks") { result in
      switch result {
      case .failure(let error):
        return completion(Result.failure(error))
        
      case .success(let data):
        guard let desks = try? JSONDecoder().decode(Desks.self, from: data).desks else {
          return completion(Result.failure(QminderError.unreadableObject))
        }
        
        return completion(Result.success(desks))
      }
    }
  }
  
  // MARK: - Lines

  /**
    Get line details
    
    - Parameters:
      - lineId: Line ID
      - completion: Callback block what is executed when line data is received
  */
  public func getLineDetails(lineId:Int, completion: @escaping (Result<Line>) -> Void) {
    
    makeRequest(url: "/lines/\(lineId)", completion: {result in
      switch result {
        case .failure(let error):
          return completion(Result.failure(error))
        
        case .success(let data):
      
          guard let line = try? JSONDecoder().decode(Line.self, from: data) else {
            return completion(Result.failure(QminderError.unreadableObject))
          }
        
          return completion(Result.success(line))
      }
    })
  }
  
  /**
   Get estimated time of service
   
   - Parameters:
     - lineId:  line ID
     - completion: Callback block what is executed when estimated time of service is received
  */
  public func getEstimatedTimeOfService(lineId: Int, completion: @escaping (Result<EstimatedTimeOfService>) -> Void) {
    
    makeRequest(url: "/lines/\(lineId)/estimated-time", completion: {result in
      switch result {
        case .failure(let error):
          return completion(Result.failure(error))
        
        case .success(let data):
          
          let jsonDecoder = JSONDecoder()
          jsonDecoder.dateDecodingStrategy = .iso8601
        
          guard let estimatedTimeOfService = try? jsonDecoder.decode(EstimatedTimeOfService.self, from: data) else {
            return completion(Result.failure(QminderError.unreadableObject))
          }
          
          return completion(Result.success(estimatedTimeOfService))
      }
    })
  }
  
  
  // MARK: - Tickets
  
  /**
    Search tickets
    
    - Parameters:
      - locationId: Optional parameter for searching tickets in specified location
      - lineId: Optional array of line ID's
      - status: Optional array of statuses "NEW", "CALLED", "CANCELLED", "CANCELLED_BY_CLERK", "NOSHOW" or "SERVED"
      - callerId: Optional parameter for searching tickets which were called by specified user ID
      - minCreatedTimestamp: Optional parameter for searching tickets which are created after specified time. UTF Unix timestamp or ISO 8601
      - maxCreatedTimestamp: Optional parameter for searching tickets which are created before specified time. UTF Unix timestamp or ISO 8601
      - minCalledTimestamp: Optional parameter for searching tickets which are called after specified time. UTF Unix timestamp or ISO 8601
      - maxCalledTimestamp: Optional parameter for searching tickets which are called before specified time. UTF Unix timestamp or ISO 8601
      - limit: Optional parameter for limiting number of search results. Value has to be between 1 and 10000. If no limit is specified, 1000 will be used
      - order: Optional parameter for ordering results. Valid values are "id", "number", "created" and "called". It's allowed to specify asc or desc ordering. Eg. "id ASC", "created DESC"
      - responseScope: Optional parameter for additional details about the found tickets. Value "MESSAGES" will also include ticket messages with response. Value "INTERACTIONS" will also include ticket interactions with response.
      - completion: Callback block executed when tickets are received back
  */
  public func searchTickets(locationId: Int? = nil, lineId: [Int]? = nil, status: [String]? = nil, callerId: Int? = nil, minCreatedTimestamp: Int? = nil, maxCreatedTimestamp: Int? = nil, minCalledTimestamp: Int? = nil, maxCalledTimestamp: Int? = nil, limit: Int? = nil, order: String? = nil, responseScope: [String]? = nil, completion: @escaping (Result<[Ticket]>) -> Void) {
  
    var parameters = [String: Any]()
    
    parameters.set(value: locationId, forKey: "location")
    parameters.set(value: lineId?.flatMap({ String($0) }).joined(separator: ","), forKey: "line")
    parameters.set(value: status?.joined(separator: ","), forKey: "status")
    parameters.set(value: callerId, forKey: "caller")
    parameters.set(value: minCreatedTimestamp, forKey: "minCreated")
    parameters.set(value: maxCreatedTimestamp, forKey: "maxCreated")
    parameters.set(value: minCalledTimestamp, forKey: "minCalled")
    parameters.set(value: maxCalledTimestamp, forKey: "maxCalled")
    parameters.set(value: limit, forKey: "limit")
    parameters.set(value: order, forKey: "order")
    parameters.set(value: responseScope?.flatMap({ String($0) }).joined(separator: ","), forKey: "responseScope")
    
    makeRequest(url: "/tickets/search", parameters: parameters, completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(Result.failure(error))
        
        case .success(let data):
          
          guard let tickets = try? self.jsonDecoderWithMilliseconds.decode(Tickets.self, from: data).data else {
            return completion(Result.failure(QminderError.unreadableObject))
          }
        
          return completion(Result.success(tickets))
      }
    })
  }
  
  /**
    Get ticket details
    
    - Parameters:
      - ticketId: Ticket ID
      - completion: Callback block when ticket details are received
  */
  public func getTicketDetails(ticketId:String, completion: @escaping (Result<Ticket>) -> Void) {
    
    makeRequest(url: "/tickets/\(ticketId)", completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(Result.failure(error))
        
        case .success(let data):
          
          guard let ticket = try? self.jsonDecoderWithMilliseconds.decode(Ticket.self, from: data) else {
            return completion(Result.failure(QminderError.unreadableObject))
          }
      
          return completion(Result.success(ticket))
      }
    })
  }
  
  
  // MARK: - Users
  
  /**
    Get user details
    
    - Parameters:
      - userId: User ID
      - completion: Callback block when user details are received
  */
  public func getUserDetails(userId:Int, completion: @escaping (Result<User>) -> Void) {
    makeRequest(url: "/users/\(userId)", completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(Result.failure(error))
        
        case .success(let data):
          
          guard let user = try? JSONDecoder().decode(User.self, from: data) else {
            return completion(Result.failure(QminderError.unreadableObject))
          }
          
          return completion(Result.success(user))
      }
    })
  }
  
  // MARK: - Devices
  
  /**
    Gets pairing code and secred key
    
    - Parameters:
      - completion: Callback block what is executed when pairing code and secret key is received from server
  */
  public func getPairingCodeAndSecret(completion: @escaping (Result<TVPairingCode>) -> Void) {
  
    makeRequest(url: "/tv/code", apiKeyNeeded: false, completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(Result.failure(error))
          
        case .success(let data):
        
          guard let pairingData = try? JSONDecoder().decode(TVPairingCode.self, from: data) else {
            return completion(Result.failure(QminderError.unreadableObject))
          }
        
          return completion(Result.success(pairingData))
      }
    })
  }
  
  /**
    Pair TV with code.
    
    - Parameters:
      - code: Pairing code
      - secret: Secret key
      - completion: Callback block when pairing is done on server:
  */
  public func pairTV(code:String, secret:String, completion: @escaping (Result<TVAPIData>) -> Void) {
    
    makeRequest(url: "/tv/code/\(code)",
      parameters: ["secret": secret], apiKeyNeeded: false, completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(Result.failure(error))
          
        case .success(let data):
        
          guard let tvAPIData = try? JSONDecoder().decode(TVAPIData.self, from: data) else {
            return completion(Result.failure(QminderError.unreadableObject))
          }
          
          return completion(Result.success(tvAPIData))
      }
    })
  }
  
  /**
    Get a details of a TV
   
    - Parameters:
      - tvID: TV ID
      - completion: Callback block when TV details are received
  */
  public func tvDetails(id:Int, completion: @escaping (Result<TVDevice>) -> Void) {
    makeRequest(url: "/tv/\(id)", completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(Result.failure(error))
        
        case .success(let data):
          
          guard let device = try? JSONDecoder().decode(TVDevice.self, from: data) else {
            return completion(Result.failure(QminderError.unreadableObject))
          }
      
          return completion(Result.success(device))
      }
    })
  }
  
  /**
    Update the heartbeat of the TV and add optional metadata in JSON format
   
    - Parameters:
      - id: TV ID
      - metadata: Dictionary of metadata to send with heartbeat
      - completion: Callback block when TV heartbeat is received
  */
  public func tvHeartbeat(id:Int, metadata: [String: Any], completion: @escaping (Result<Void?>) -> Void) {
    let parameters = metadata
    
    makeRequest(url: "/tv/\(id)/heartbeat", method: .post, parameters: parameters, encoding: .json) { result in
      switch result {
        case .failure(let error):
          return completion(Result.failure(error))
      
        case .success:
          return completion(Result.success(nil))
      }
    }
    
  }
  
  /**
    Empty state text message for TV
    
    - Parameters:
      - id: TV ID
      - completion: Callback block when empty state is received
  */
  public func tvEmptyState(id: Int, language: String, completion: @escaping (Result<EmptyState>) -> Void) {
    
    var parameters = [String: Any]()
    parameters.set(value: language, forKey: "language")
    
    makeRequest(url: "/tv/\(id)/emptystate", method: .get, parameters: parameters, completion: {result in
      switch result {
        case .failure(let error):
          return completion(Result.failure(error))
          
        case .success(let data):
          
          guard let emptyState = try? JSONDecoder().decode(EmptyState.self, from: data) else {
            return completion(Result.failure(QminderError.unreadableObject))
          }
          
          return completion(Result.success(emptyState))
      }
    })
      
  }
  
  // MARK: - Additonal methods
  
  /**
    Make URL request with Alamofire
    
    - Parameters:
      - url: URL
      - completion: Callback block with result
  */
  fileprivate func makeRequest(url:String, method:HTTPMethod = .get, parameters: [String: Any] = [:], encoding:ParameterEncoding = .none, apiKeyNeeded:Bool = true, completion: @escaping (Result<Data>) -> Void) {
    
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
