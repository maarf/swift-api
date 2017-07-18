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
import ObjectMapper


/// Qminder API for iOS in Swift
open class QminderAPI {

  /// Qminder API key
  private var apiKey: String?
  
  /// Qminder request result
  enum QminderRequestResult<Value> {
    case success(Value)
    case failure(Error)
  }
  
  
  /**
    Public init function
    
    - Returns: Qminder API object
  */
  public init() {}
  
  /**
    Set Qminder API key
    
    - Parameter key: API key
  */
  open func setApiKey(key:String) {
    apiKey = key
  }
  
  // MARK: - Locations
  
  /**
    Get location list
    
    - Parameters:
      - completionHandler: Callback block what is executed when location list is received
      - locations: Array data of locations {id, name, latitude, longitude}
      - error: Error
  */
  open func getLocationsList(completion: @escaping (QminderResult<Array<Location>>) -> Void) {
  
    makeRequest(url: "/locations/", completion: {result in
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let json):
          guard let locations = Locations(JSON: json)?.locations else {
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
  
    makeRequest(url: "/locations/\(locationId)", completion: {result in
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let json):
          guard let location = Location(JSON: json) else {
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
  public func getLocationLines(locationId:Int, completion: @escaping (QminderResult<Array<Line>>) -> Void) {
    
    makeRequest(url: "/locations/\(locationId)/lines", completion: {result in
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let json):
      
          guard let lines = Lines(JSON: json)?.lines else {
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
  public func getLocationUsers(locationId:Int, completion: @escaping (QminderResult<Array<User>>) -> Void) {
    
    makeRequest(url: "/locations/\(locationId)/users", completion: {result in
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let json):
          guard let users = Users(JSON: json)?.users else {
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
    
    makeRequest(url: "/lines/\(lineId)", completion: {result in
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let json):
      
          guard let line = Line(JSON: json) else {
            return completion(QminderResult.failure(QminderError.unreadableObject))
          }
        
          return completion(QminderResult.success(line))
      }
    })
  }
  
  public func getEstimatedTimeOfService(lineId:Int, completion: @escaping (QminderResult<EstimatedTimeOfService>) -> Void) {
    
    makeRequest(url: "/lines/\(lineId)/estimated-time", completion: {result in
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let json):
        
          guard let estimatedTimeOfService = EstimatedTimeOfService(JSON: json) else {
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
  public func searchTickets(locationId:Int? = nil, lineId:Array<Int>? = nil, status:Array<String>? = nil, callerId:Int? = nil, minCreatedTimestamp:Int? = nil, maxCreatedTimestamp:Int? = nil, minCalledTimestamp:Int? = nil, maxCalledTimestamp:Int? = nil, limit:Int? = nil, order:String? = nil, completion: @escaping (QminderResult<Array<Ticket>>) -> Void) {
  
    var parameters:Parameters = Parameters()
    
    // check if parameters exist and add them to url
    addParameter(value: locationId, name: "location", parameters: &parameters)
    addParameter(value: lineId?.flatMap({ String($0) }).joined(separator: ","), name: "line", parameters: &parameters)
    addParameter(value: status?.joined(separator: ","), name: "status", parameters: &parameters)
    addParameter(value: callerId, name: "caller", parameters: &parameters)
    addParameter(value: minCreatedTimestamp, name: "minCreated", parameters: &parameters)
    addParameter(value: maxCreatedTimestamp, name: "maxCreated", parameters: &parameters)
    addParameter(value: minCalledTimestamp, name: "minCalled", parameters: &parameters)
    addParameter(value: maxCalledTimestamp, name: "maxCalled", parameters: &parameters)
    addParameter(value: limit, name: "limit", parameters: &parameters)
    addParameter(value: order, name: "order", parameters: &parameters)
    
    
    makeRequest(url: "/tickets/search", parameters: parameters, completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let json):
          guard let tickets = Tickets(JSON: json)?.tickets else {
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
    
    makeRequest(url: "/tickets/\(ticketId)", completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let json):
          guard let ticket = Ticket(JSON: json) else {
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
    makeRequest(url: "/users/\(userId)", completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
        
        case .success(let json):
          guard let user = User(JSON: json) else {
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
  
    makeRequest(url: "/tv/code", apiKeyNeeded: false, completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
          
        case .success(let json):
        
          guard let pairingData = TVPairingCode(JSON: json) else {
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
    
    makeRequest(url: "/tv/code/\(code)",
      parameters: ["secret": secret], apiKeyNeeded: false, completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
          
        case .success(let json):
        
          guard let tvAPIData = TVAPIData(JSON: json) else {
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
    makeRequest(url: "/tv/\(id)", completion: {result in
    
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
          
        case .success(let json):
          guard let device = TVDevice(JSON: json) else {
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
  public func tvHeartbeat(id:Int, metadata:Dictionary<String, Any>, completion: @escaping (QminderResult<Void>) -> Void) {
    let parameters: Parameters = metadata
    
    makeRequest(url: "/tv/\(id)/heartbeat", method: .post, parameters: parameters, encoding: JSONEncoding.default, completion: {result in
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
      
        case .success:
          return completion(QminderResult.success())
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
  public func tvEmptyState(id: Int, completion: @escaping (QminderResult<String>) -> Void) {
    makeRequest(url: "/tv/\(id)/emptystate", method: .get, encoding: JSONEncoding.default, completion: {result in
      switch result {
        case .failure(let error):
          return completion(QminderResult.failure(error))
          
        case .success(let json):
          guard let message = json["message"] as? String else {
            return completion(QminderResult.failure(QminderError.unreadableObject))
          }
          
          return completion(QminderResult.success(message))
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
    
    Alamofire.request("https://api.qminder.com/v1\(url)", method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: { response in
      
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
  
  /**
    Add URL parameter and check if it exists (?parameterName=parameter
    
    - Parameters:
      - parameterValue: Parameter value object
      - parameterName: Parameter name
  */
  private func addParameter(value:Any?, name:String, parameters: inout Dictionary<String, Any>) {
    guard let val = value else {
      return
    }
    
    parameters[name] = val
  }
  
}
