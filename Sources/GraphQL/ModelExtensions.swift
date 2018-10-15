//
//  ModelExtensions.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 15/10/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

import Apollo

extension Line {
  
  /// Initialize Line using GraphQL Line object
  ///
  /// - Parameter line: GraphQL line object
  init?(_ line: LocationDetailsQuery.Data.Location.Line) {
    guard let lineID = Int(line.id) else {
      return nil
    }
    
    self.id = lineID
    self.name = line.name
    self.location = nil
    self.statusCode = nil
  }
}

extension Desk {
  
  /// Initialize Desk using GraphQL Desk object
  ///
  /// - Parameter desk: GraphQL desk object
  init?(_ desk: LocationDetailsQuery.Data.Location.Desk) {
    guard let deskID = Int(desk.id) else {
      return nil
    }
    
    self.id = deskID
    self.name = desk.name
  }
}
