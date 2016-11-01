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

public class QminderAPI {
  
  static let SERVER = "https://api.qminderapp.com/v1"
  public var API_KEY:String?
  
  
  // get pairing code and secret key
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
  
  
  public class func pairTV(code:String, secret:String, completionHandler: @escaping (_ status:String?, _ apiKey:String?, Error?) -> Void) {
    
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
