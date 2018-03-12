//
//  QminderAPIProtocolExtension.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 07/03/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

extension QminderAPIProtocol {
  
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
    
    fetch(.tickets(parameters), decodingType: Tickets.self) { completion($0) }
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
  private func makeRequest(url: String, method: HTTPMethod = .get, parameters: [String: Any] = [:],
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
