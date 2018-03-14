//
//  QminderAPIProtocolExtension.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 07/03/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

extension QminderAPIProtocol {
  
  func searchTickets(locationId: Int? = nil, lineId: Set<Int>? = nil, status: Set<Status>? = nil,
                     callerId: Int? = nil, minCreatedTimestamp: Int? = nil, maxCreatedTimestamp: Int? = nil,
                     minCalledTimestamp: Int? = nil, maxCalledTimestamp: Int? = nil,
                     limit: Int? = nil, order: String? = nil, responseScope: Set<String>? = nil,
                     completion: @escaping (Result<[Ticket], QminderError>) -> Void) {
    searchTickets(locationId: locationId, lineId: lineId,
                  status: status, callerId: callerId,
                  minCreatedTimestamp: minCreatedTimestamp, maxCreatedTimestamp: maxCreatedTimestamp,
                  minCalledTimestamp: minCalledTimestamp, maxCalledTimestamp: maxCalledTimestamp,
                  limit: limit, order: order, responseScope: responseScope, completion: completion)
  }
  
  internal func fetch<T: ResponsableWithData>(_ endPoint: QminderAPIEndpoint, decodingType: T.Type,
                                              _ completion: @escaping (Result<T.Data, QminderError>) -> Void) {
    performRequestWith(endPoint) { result in
      switch result {
      case let .success(data):
        completion(data.decode(decodingType))
      case let .failure(error):
        completion(Result(error))
      }
    }
  }
  
  internal func fetch<T: Responsable>(_ endPoint: QminderAPIEndpoint, decodingType: T.Type,
                                      _ completion: @escaping (Result<T, QminderError>) -> Void) {
    performRequestWith(endPoint) { result in
      switch result {
      case let .success(data):
        completion(data.decode(decodingType))
      case let .failure(error):
        completion(Result(error))
      }
    }
  }
  
  internal func fetch(_ endPoint: QminderAPIEndpoint, _ completion: @escaping (Result<Void?, QminderError>) -> Void) {
    performRequestWith(endPoint) { result in
      switch result {
      case .success:
        completion(Result.success(nil))
      case let .failure(error):
        completion(Result(error))
      }
    }
  }

  internal func performRequestWith(_ endPoint: QminderAPIEndpoint,
                                   _ completion: @escaping (Result<Data, QminderError>) -> Void) {
    
    do {
      let request = try endPoint.request(serverAddress: serverAddress, apiKey: apiKey)

      request.printCurlString()
      
      URLSession.shared.dataTask(with: request) { data, response, error in
        self.queue.async {
          if let error = error {
            completion(Result(.request(error)))
          } else {
            
            guard let httpResponse = response as? HTTPURLResponse, let resultData = data else {
              completion(Result(.parseRequest))
              return
            }
            
            if httpResponse.statusCode != 200 {
              completion(Result(.statusCode(httpResponse.statusCode)))
              return
            }
            
            completion(Result(resultData))
          }
        }
      }.resume()
    } catch {
      completion(Result(error.qminderError))
    }
  }

  /**
   Make URL request
   
   - Parameters:
     - url: URL
     - method: HTTP method
     - parameters: Hash of parameters
     - encoding: Parameter encoding
     - apiKeyNeeded: Need API key to make this request
     - completion: Callback block with result
   */
}
