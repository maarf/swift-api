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

  /// Qminder API key
  private var apiKey: String?
  
  
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
  open func getLocationsList(completionHandler: @escaping (_ locations:Array<Any>?, _ error:Error?) -> Void) {
  
    makeRequest(url: "/locations/",
      callback: { json in
        completionHandler(json["data"].arrayObject, nil)
      },
      errorCallback: { error in
        completionHandler(nil, error)
      }
    )
  }
  
  /**
    Get location details
    
    - Parameters:
      - locationId: Location ID
      - completionHandler: Callback block what is executed when location data is received
      - details: Location details in Dictionary object {id, name, timezoneOffset}
      - error: Error
  */
  public func getLocationDetails(locationId:Int, completionHandler: @escaping (_ details:Dictionary<String, Any>?, _ error:Error?) -> Void) {
  
    makeRequest(url: "/locations/\(locationId)",
      callback: { json in
        completionHandler(json.dictionaryObject, nil)
      },
      errorCallback: { error in
        completionHandler(nil, error)
      }
    )
  }
  
  /**
    Get Location Lines
    
    - Parameters:
      - locationId: Location ID
      - completionHandler: Callback block what is executed when location lines is received
      - lines: Array of lines {id, name}
      - error: Error
  */
  public func getLocationLines(locationId:Int, completionHandler: @escaping (_ lines:Array<Any>?, _ error:Error?) -> Void) {
    
    makeRequest(url: "/locations/\(locationId)/lines",
      callback: { json in
        completionHandler(json["data"].arrayObject, nil)
      },
      errorCallback: { error in
        completionHandler(nil, error)
      }
    )
  }
  
  /**
    Get location users
    
    - Parameters:
      - locationId: Location ID
      - completionHandler: Callback block what is executed when location users is received
      - lines: Array of users {id, email, firstName, lastName}
      - error: Error
  */
  public func getLocationUsers(locationId:Int, completionHandler: @escaping (_ users:Array<Any>?, _ error:Error?) -> Void) {
    
    makeRequest(url: "/locations/\(locationId)/users",
      callback: { json in
        completionHandler(json["data"].arrayObject, nil)
      },
      errorCallback: { error in
        completionHandler(nil, error)
      }
    )
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
  public func getLineDetails(lineId:Int, completionHandler: @escaping (_ details:Dictionary<String, Any>?, _ error:Error?) -> Void) {
    
    makeRequest(url: "/lines/\(lineId)",
      callback: { json in
        completionHandler(json.dictionaryObject, nil)
      },
      errorCallback: { error in
        completionHandler(nil, error)
      }
    )
  }
  
  public func getEstimatedTimeOfService(lineId:Int, completionHandler: @escaping (_ estimatedTimeOfService:String?, _ estimatedPeopleWaiting:Int?, _ error:Error?) -> Void) {
    
    makeRequest(url: "/lines/\(lineId)/estimated-time",
      callback: { json in
        completionHandler(json["estimatedTimeOfService"].string, json["estimatedPeopleWaiting"].int, nil)
      },
      errorCallback: { error in
        completionHandler(nil, nil, error)
      }
    )
  }
  
  
  // MARK: - Tickets
  
  /**
    Search tickets
    
    - Parameters:
      - locationId: Optional parameter for searching tickets in specified location
      - lineId: Optional comma separated list of lines to search tickets from
      - status: Optional parameter for searching tickets with specified status(es). Comma separated list of "NEW", "CALLED", "CANCELLED", "CANCELLED_BY_CLERK", "NOSHOW" or "SERVED"
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
  public func searchTickets(locationId:Int? = nil, lineId:Int? = nil, status:String? = nil, callerId:Int? = nil, minCreatedTimestamp:Int? = nil, maxCreatedTimestamp:Int? = nil, minCalledTimestamp:Int? = nil, maxCalledTimestamp:Int? = nil, limit:Int? = nil, order:String? = nil, completionHandler: @escaping (_ tickets:Array<Any>?, _ error:Error?) -> Void) {
  
    var parameters:Parameters = Parameters()
    
    // check if parameters exist and add them to url
    addParameter(value: locationId, name: "location", parameters: &parameters)
    addParameter(value: lineId, name: "line", parameters: &parameters)
    addParameter(value: status, name: "status", parameters: &parameters)
    addParameter(value: callerId, name: "caller", parameters: &parameters)
    addParameter(value: minCreatedTimestamp, name: "minCreated", parameters: &parameters)
    addParameter(value: maxCreatedTimestamp, name: "maxCreated", parameters: &parameters)
    addParameter(value: minCalledTimestamp, name: "minCalled", parameters: &parameters)
    addParameter(value: maxCalledTimestamp, name: "maxCalled", parameters: &parameters)
    addParameter(value: limit, name: "limit", parameters: &parameters)
    addParameter(value: order, name: "order", parameters: &parameters)
    
    
    makeRequest(url: "/tickets/search", parameters: parameters,
      callback: { json in
        completionHandler(json["data"].arrayObject, nil)
      },
      errorCallback: { error in
        completionHandler(nil, error)
      }
    )
  }
  
  /**
    Get ticket details
    
    - Parameters:
      - ticketId: Ticket ID
      - completionHandler: Callback block when ticket details are received
      - details: Ticket details object
      - error: Error
  */
  public func getTicketDetails(ticketId:Int, completionHandler: @escaping (_ details:Dictionary<String, Any>?, _ error:Error?) -> Void) {
    
    makeRequest(url: "/tickets/\(ticketId)",
      callback: { json in
        completionHandler(json.dictionaryObject, nil)
      },
      errorCallback: { error in
        completionHandler(nil, error)
      }
    )
  }
  
  
  // MARK: - Users
  
  /**
    Get user details
    
    - Parameters:
      - userId: User ID
      - completionHandler: Callback block when user details are received
      - details: User details object {id, email, firstName, lastName, desk, roles}
      - error: Error
  */
  public func getUserDetails(userId:Int, completionHandler: @escaping (_ details:Dictionary<String, Any>?, _ error:Error?) -> Void) {
    makeRequest(url: "/users/\(userId)",
      callback: { json in
        completionHandler(json.dictionaryObject, nil)
      },
      errorCallback: { error in
        completionHandler(nil, error)
      }
    )
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
  public func getPairingCodeAndSecret(completionHandler: @escaping (_ code:String?, _ secret:String?, _ error:Error?) -> Void) {
  
    makeRequest(url: "/tv/code",
      callback: { json in
        completionHandler(json["code"].string, json["secret"].string, nil)
      },
      errorCallback: { error in
        completionHandler(nil, nil, error)
      },
      apiKeyNeeded: false
    )
  }
  
  /**
    Pair TV with code.
    
    - Parameters:
      - code: Pairing code
      - secret: Secret key
      - completionHandler: Callback block when pairing is done on server:
      - status: Status if TV is paired
      - apiKey: Qminder API key
      - error: Error with pairing process
   
  */
  public func pairTV(code:String, secret:String, completionHandler: @escaping (_ status:String?, _ apiKey:String?, _ location:Int?, _ error:Error?) -> Void) {
    
    makeRequest(url: "/tv/code/\(code)",
      parameters: ["secret": secret]
      ,callback: { json in
        completionHandler(json["status"].string, json["apiKey"].string, json["location"].int, nil)
      },
      errorCallback: { error in
        completionHandler(nil, nil, nil, error)
      },
      apiKeyNeeded: false
    )
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
  private func makeRequest(url:String, parameters:Parameters? = nil, callback: @escaping ((_ json:JSON) -> Void), errorCallback: @escaping ((_ error:QminderError) -> Void), apiKeyNeeded:Bool = true) {
  
    var headers: HTTPHeaders = [:]
  
    if apiKeyNeeded {
      guard let key = self.apiKey else {
        errorCallback(QminderError.apiKeyNotSet)
        return
      }
      
      headers["X-Qminder-REST-API-Key"] = key
    }
    
    Alamofire.request("https://api.qminderapp.com/v1\(url)", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: { response in
      
        let parsedResponse = self.validateRequest(response: response)
      
        if parsedResponse.valid {
          callback(parsedResponse.json!)
        } else {
          errorCallback(QminderError.alamofire(parsedResponse.error!))
        }
        
    })
  }
  
  /**
    Validate request
    
    - Parameters:
      - response: Data response to validate
        - valid: Returns if response is valid
        - json: JSON data
        - error: Validation errors
   
  */
  private func validateRequest(response:DataResponse<Any>) -> (valid:Bool, json:JSON?, error:Error?) {
    if let responseValue = response.result.value {
      let swiftyJson = JSON(responseValue)
          
      if swiftyJson["statusCode"].intValue == 200 {
        return (true, swiftyJson, nil)
      } else {
        return (false, nil, NSError(domain: "qminder", code: swiftyJson["statusCode"].intValue, userInfo: nil))
      }
    } else {
      return (false, nil, response.result.error)
    }
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
