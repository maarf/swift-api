//
//  QminderGraphQLAPI.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 15/10/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

import Apollo

public struct QminderGraphQLAPI: QminderGraphQLAPIProtocol {
  
  /// Apollo GraphQL client
  private let apolloClient: ApolloClient
  
  /// Queue to return result in
  private var queue = DispatchQueue.main
  
  public init(apiKey: String, serverAddress: String = "https://api.qminder.com/graphql") {
    apolloClient = {
      let configuration = URLSessionConfiguration.default
      configuration.httpAdditionalHeaders = ["X-Qminder-REST-API-Key": apiKey]
      let url = URL(string: serverAddress)!
      return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
    }()
  }
  
  public func locationDetails(_ locationID: Int,
                              completion: @escaping (Result<LocationDetails, QminderError>) -> Void) {
    apolloClient.fetch(query: LocationDetailsQuery(id: GraphQLID(locationID))) { result, error in
      self.queue.async {
        if let error = error {
          completion(Result(QminderError.graphQL(error)))
        } else if let errors = result?.errors {
          completion(Result(QminderError.graphQLErrors(errors)))
        } else if let data = result?.data {
          guard let location = data.location else {
            completion(Result(QminderError.parseRequest))
            return
          }
          
          let lines = location.lines.compactMap { Line( $0) }
          let desks = location.desks?.compactMap { Desk($0) }
          completion(Result(LocationDetails(lines, desks)))
        }
      }
    }
  }
}
