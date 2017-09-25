//
//  QminderAPI.swift
//  Pods
//
//  Created by Qminder on 24/10/2016.
//
//

import Foundation

import Alamofire
import SwiftyJSON


/// Qminder API for iOS in Swift
open class QminderAPI {

  /// Singleton shared instance
  public static let sharedInstance = QminderAPI()

  /// Qminder API key
  private var apiKey: String?
  
  /// Qminder API address
  private var serverAddress = "https://api.qminder.com/v1"
  
  /// JSON decoder with milliseconds
  private let jsonDecoderWithMilliseconds: JSONDecoder = {
    let jsonDecoder = JSONDecoder()
    
    let dateISO8601Formatter = DateFormatter()
    dateISO8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    let dateISO8601MillisecondsFormatter = DateFormatter()
    dateISO8601MillisecondsFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    jsonDecoder.dateDecodingStrategy = .custom({decoder -> Date in
      
      let container = try decoder.singleValueContainer()
      let dateStr = try container.decode(String.self)
      
      // possible date strings: "yyyy-MM-dd'T'HH:mm:ssZ" or "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      
      var tmpDate: Date? = nil
      
      if dateStr.count == 24 {
        tmpDate = dateISO8601MillisecondsFormatter.date(from: dateStr)
      } else {
        tmpDate = dateISO8601Formatter.date(from: dateStr)
      }
      
      guard let date = tmpDate else {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
      }
      
      return date
    })
    
    return jsonDecoder
  }()
  
  /// Qminder request result
  enum QminderRequestResult<Value> {
    case success(Value)
    case failure(Error)
  }
  
  
  /**
    Private init for singleton approach
  */
  private init() {}
  
  /**
    Set Qminder API key
    
    - Parameter key: API key
  */
  open func setup(apiKey:String, serverAddress:String?=nil) {
    self.apiKey = apiKey
    
    guard let address = serverAddress else {
      return
    }
    self.serverAddress = address
  }
  
  // MARK: - Locations
  
  /**
    Get location list
    
    - Parameters:
      - completionHandler: Callback block what is executed when location list is received
      - locations: Array data of locations {id, name, latitude, longitude}
      - error: Error
  */
  open func getLocationsList(completion: @escaping (QminderResult<[Location]>) -> Void) {
  
    makeDataRequest(url: "/locations/", completion: {result in
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let data):
          
          guard let locations = try? JSONDecoder().decode(Locations.self, from: data).data else {
            return completion(QminderResult.failure(QminderError.unreadableObject))
          }
          
          return completion(QminderResult.success(locations))
      }
    })
  }
  
  /**
    Get location details
    
    - Parameters:
      - locationId: Location ID
      - completionHandler: Callback block what is executed when location data is received
      - details: Location details in Dictionary object {id, name, timezoneOffset}
      - error: Error
  */
  public func getLocationDetails(locationId:Int, completion: @escaping (QminderResult<Location>) -> Void) {
  
    makeDataRequest(url: "/locations/\(locationId)", completion: {result in
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let data):
          
          guard let location = try? JSONDecoder().decode(Location.self, from: data) else {
            return completion(QminderResult.failure(QminderError.unreadableObject))
          }
        
          return completion(QminderResult.success(location))
      }
    })
  }
  
  /**
    Get Location Lines
    
    - Parameters:
      - locationId: Location ID
      - completionHandler: Callback block what is executed when location lines is received
      - lines: Array of lines {id, name}
      - error: Error
  */
  public func getLocationLines(locationId:Int, completion: @escaping (QminderResult<[Line]>) -> Void) {
    
    makeDataRequest(url: "/locations/\(locationId)/lines", completion: {result in
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let data):
      
          guard let lines = try? JSONDecoder().decode(Lines.self, from: data).data else {
            return completion(QminderResult.failure(QminderError.unreadableObject))
          }
          
          return completion(QminderResult.success(lines))
        }
      })
  }
  
  /**
    Get location users
    
    - Parameters:
      - locationId: Location ID
      - completionHandler: Callback block what is executed when location users is received
      - lines: Array of users {id, email, firstName, lastName}
      - error: Error
  */
  public func getLocationUsers(locationId:Int, completion: @escaping (QminderResult<[User]>) -> Void) {
    
    makeDataRequest(url: "/locations/\(locationId)/users", completion: {result in
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let data):
          
          guard let users = try? JSONDecoder().decode(Users.self, from: data).data else {
            return completion(QminderResult.failure(QminderError.unreadableObject))
          }
        
          return completion(QminderResult.success(users))
      }
    })
  }
  
  // MARK: - Lines

  /**
    Get line details
    
    - Parameters:
      - lineId: Line ID
      - completionHandler: Callback block what is executed when line data is received
      - details: Location details in Dictionary object {id, name, location id}
      - error: Error
  */
  public func getLineDetails(lineId:Int, completion: @escaping (QminderResult<Line>) -> Void) {
    
    makeDataRequest(url: "/lines/\(lineId)", completion: {result in
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let data):
      
          guard let line = try? JSONDecoder().decode(Line.self, from: data) else {
            return completion(QminderResult.failure(QminderError.unreadableObject))
          }
        
          return completion(QminderResult.success(line))
      }
    })
  }
  
  public func getEstimatedTimeOfService(lineId:Int, completion: @escaping (QminderResult<EstimatedTimeOfService>) -> Void) {
    
    makeDataRequest(url: "/lines/\(lineId)/estimated-time", completion: {result in
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let data):
          
          let jsonDecoder = JSONDecoder()
          jsonDecoder.dateDecodingStrategy = .iso8601
        
          guard let estimatedTimeOfService = try? jsonDecoder.decode(EstimatedTimeOfService.self, from: data) else {
            return completion(QminderResult.failure(QminderError.unreadableObject))
          }
          
          return completion(QminderResult.success(estimatedTimeOfService))
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
      - completionHandler: Callback block executed when tickets are received back
      - tickets: Tickets Array
      - error: Error
  */
  public func searchTickets(locationId:Int? = nil, lineId:[Int]? = nil, status:[String]? = nil, callerId:Int? = nil, minCreatedTimestamp:Int? = nil, maxCreatedTimestamp:Int? = nil, minCalledTimestamp:Int? = nil, maxCalledTimestamp:Int? = nil, limit:Int? = nil, order:String? = nil, completion: @escaping (QminderResult<[Ticket]>) -> Void) {
  
    var parameters = Parameters()
    
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
    
    makeDataRequest(url: "/tickets/search", parameters: parameters, completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let data):
          
          guard let tickets = try? self.jsonDecoderWithMilliseconds.decode(Tickets.self, from: data).data else {
            return completion(QminderResult.failure(QminderError.unreadableObject))
          }
        
          return completion(QminderResult.success(tickets))
      }
    })
  }
  
  /**
    Get ticket details
    
    - Parameters:
      - ticketId: Ticket ID
      - completionHandler: Callback block when ticket details are received
      - details: Ticket details object
      - error: Error
  */
  public func getTicketDetails(ticketId:Int, completion: @escaping (QminderResult<Ticket>) -> Void) {
    
    makeDataRequest(url: "/tickets/\(ticketId)", completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let data):
          
          guard let ticket = try? self.jsonDecoderWithMilliseconds.decode(Ticket.self, from: data) else {
            return completion(QminderResult.failure(QminderError.unreadableObject))
          }
      
          return completion(QminderResult.success(ticket))
      }
    })
  }
  
  
  // MARK: - Users
  
  /**
    Get user details
    
    - Parameters:
      - userId: User ID
      - completionHandler: Callback block when user details are received
      - details: User details object {id, email, firstName, lastName, desk, roles, image}
      - error: Error
  */
  public func getUserDetails(userId:Int, completion: @escaping (QminderResult<User>) -> Void) {
    makeDataRequest(url: "/users/\(userId)", completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let data):
          
          guard let user = try? JSONDecoder().decode(User.self, from: data) else {
            return completion(QminderResult.failure(QminderError.unreadableObject))
          }
          
          return completion(QminderResult.success(user))
      }
    })
  }
  
  // MARK: - Devices
  
  /**
    Gets pairing code and secred key
    
    - Parameters:
      - completionHandler: Callback block what is executed when pairing code and secret key is received from server
      - code: Pairing code
      - secret: Secret key
      - error: Error
  */
  public func getPairingCodeAndSecret(completion: @escaping (QminderResult<TVPairingCode>) -> Void) {
  
    makeDataRequest(url: "/tv/code", apiKeyNeeded: false, completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
          
        case .success(let data):
        
          guard let pairingData = try? JSONDecoder().decode(TVPairingCode.self, from: data) else {
            return completion(QminderResult.failure(QminderError.unreadableObject))
          }
        
          return completion(QminderResult.success(pairingData))
      }
    })
  }
  
  /**
    Pair TV with code.
    
    - Parameters:
      - code: Pairing code
      - secret: Secret key
      - completionHandler: Callback block when pairing is done on server:
      - status: Status if TV is paired
      - id: TV ID
      - apiKey: Qminder API key
      - error: Error with pairing process
   
  */
  public func pairTV(code:String, secret:String, completion: @escaping (QminderResult<TVAPIData>) -> Void) {
    
    makeDataRequest(url: "/tv/code/\(code)",
      parameters: ["secret": secret], apiKeyNeeded: false, completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
          
        case .success(let data):
        
          guard let tvAPIData = try? JSONDecoder().decode(TVAPIData.self, from: data) else {
            return completion(QminderResult.failure(QminderError.unreadableObject))
          }
          
          return completion(QminderResult.success(tvAPIData))
      }
    })
  }
  
  /**
    Get a details of a TV
   
    - Parameters:
      - tvID: TV ID
      - name: Name of a TV
      - error: Error
  */
  public func tvDetails(id:Int, completion: @escaping (QminderResult<TVDevice>) -> Void) {
    makeDataRequest(url: "/tv/\(id)", completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(QminderError.alamofire(error)))
          
        case .success(let data):
          
          let str = String(data: data, encoding: String.Encoding.utf8)
          
          guard let device = try? JSONDecoder().decode(TVDevice.self, from: data) else {
            return completion(QminderResult.failure(QminderError.unreadableObject))
          }
      
          return completion(QminderResult.success(device))
      }
    })
  }
  
  /**
    Update the heartbeat of the TV and add optional metadata in JSON format
   
    - Parameters:
      - id: TV ID
      - metadata: Dictionary of metadata to send with heartbeat
      - error: Error
  */
  public func tvHeartbeat(id:Int, metadata:Dictionary<String, Any>, completion: @escaping (QminderResult<Void?>) -> Void) {
    let parameters: Parameters = metadata
    
    makeDataRequest(url: "/tv/\(id)/heartbeat", method: .post, parameters: parameters, encoding: JSONEncoding.default, completion: {result in
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
      
        case .success:
          return completion(QminderResult.success(nil))
      }
    })
    
  }
  
  /**
    Empty state text message for TV
    
    - Parameters:
      - id: TV ID
      - message: Empty state message
      - error: Error
  */
  public func tvEmptyState(id: Int, completion: @escaping (QminderResult<EmptyState>) -> Void) {
    makeDataRequest(url: "/tv/\(id)/emptystate", method: .get, encoding: JSONEncoding.default, completion: {result in
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
          
        case .success(let data):
          
          guard let emptyState = try? JSONDecoder().decode(EmptyState.self, from: data) else {
            return completion(QminderResult.failure(QminderError.unreadableObject))
          }
          
          return completion(QminderResult.success(emptyState))
      }
    })
      
  }
  
  // MARK: - Additonal methods
  
  /**
    Make URL request with Alamofire
    
    - Parameters:
      - url: URL
      - callback: Callback when everything is OK
        - json: JSON object
      - errorCallback: Error callback
        - error: Error
  */
  private func makeRequest(url:String, method:HTTPMethod = .get, parameters:Parameters? = nil, encoding:ParameterEncoding = URLEncoding.default, apiKeyNeeded:Bool = true, completion: @escaping (QminderRequestResult<[String: Any]>) -> Void) {
  
    var headers: HTTPHeaders = [:]
  
    if apiKeyNeeded {
      guard let key = self.apiKey else {
        return completion(QminderRequestResult.failure(QminderError.apiKeyNotSet))
      }
      
      headers["X-Qminder-REST-API-Key"] = key
    }
    
    Alamofire.request("\(serverAddress)\(url)", method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: { response in
      
      switch response.result {
        case .failure(let error):
          return completion(QminderRequestResult.failure(QminderError.alamofire(error)))
        
        case .success(let value):
          let json = JSON(value)
          
          guard json["statusCode"].intValue == 200, let dictionary = json.dictionaryObject else {
            return completion(QminderRequestResult.failure(NSError(domain: "qminder", code: json["statusCode"].intValue, userInfo: nil)))
          }
          
          return completion(QminderRequestResult.success(dictionary))
      }
    })
  }
  
  private func makeDataRequest(url:String, method:HTTPMethod = .get, parameters:Parameters? = nil, encoding:ParameterEncoding = URLEncoding.default, apiKeyNeeded:Bool = true, completion: @escaping (QminderRequestResult<Data>) -> Void) {
    
    var headers: HTTPHeaders = [:]
    
    if apiKeyNeeded {
      guard let key = self.apiKey else {
        return completion(QminderRequestResult.failure(QminderError.apiKeyNotSet))
      }
      
      headers["X-Qminder-REST-API-Key"] = key
    }
    
    Alamofire.request("\(serverAddress)\(url)", method: method, parameters: parameters, encoding: encoding, headers: headers).responseData(completionHandler: { response in
      
      let statusCode = response.response?.statusCode
      
      if statusCode != 200 {
        return completion(QminderRequestResult.failure(QminderError.error(statusCode!)))
      }
      
      switch response.result {
        case .failure(let error):
          return completion(QminderRequestResult.failure(QminderError.alamofire(error)))
        
        case .success(let value):
          return completion(QminderRequestResult.success(value))
      }
    })
  }
}

extension Dictionary where Key == String, Value == Any {
  mutating func set(value optionalValue: Any?, forKey key: String) {
    guard let value = optionalValue else { return }
    
    self[key] = value
  }
}
