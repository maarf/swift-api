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
public class QminderAPI {
  
  /// Qminder API server address
  static let SERVER = "https://api.qminderapp.com/v1"
  
  /// Qminder API key
  public var API_KEY:String?
  
  
  /**
    Gets pairing code and secred key
    
    - Parameters:
      - completionHandler: Callback block what is executed when pairing code and secret key is received from server
        - code: Pairing code
        - secret: Secret key
  */
  public class func getPairingCodeAndSecret(completionHandler: @escaping (_ code:String?, _ secret:String?, Error?) -> Void) {
  
    Alamofire.request("\(self.SERVER)/tv/code").responseJSON {
      response in
      
        var parsedResponse = validateRequest(response: response)
      
        if parsedResponse.valid {
          completionHandler(parsedResponse.json?["code"].string, parsedResponse.json?["secret"].string, nil)
        } else {
          completionHandler(nil, nil, parsedResponse.error)
        }
    }
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
  public class func pairTV(code:String, secret:String, completionHandler: @escaping (_ status:String?, _ apiKey:String?, _ error:Error?) -> Void) {
    
    Alamofire.request("\(self.SERVER)/tv/code/\(code)", parameters: ["secret": secret]).responseJSON {
      response in
      
        var parsedResponse = validateRequest(response: response)
      
        if parsedResponse.valid {
          completionHandler(parsedResponse.json?["status"].string, parsedResponse.json?["apiKey"].string, nil)
        } else {
          completionHandler(nil, nil, parsedResponse.error)
        }
    }
  }
  
  // MARK: - Additonal methods
  
  /**
    Validate request
    
    - Parameters:
      - response: Data response to validate
        - valid: Returns if response is valid
        - json: JSON data
        - error: Validation errors
   
  */
  class func validateRequest(response:DataResponse<Any>) -> (valid:Bool, json:JSON?, error:Error?) {
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
  
}
