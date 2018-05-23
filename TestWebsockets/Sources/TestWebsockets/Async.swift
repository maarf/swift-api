//
//  Async.swift
//  App
//
//  Created by Kristaps Grinbergs on 06/03/2018.
//

import Foundation

// Async
struct Async {
  
  /**
   Execute blocks in waterfall
   
   - Parameters:
     - initialValue: Initial value to start with
     - chain: Array of blocks to execute
     - end: Last block to execute
  */
  static func waterfall(_ initialValue: Any? = nil,_ chain:[(@escaping (Any?) -> (), Any?) throws -> ()], end: @escaping (Error?, Any?) -> () ) {
    
    guard let function = chain.first else {
      end(nil, initialValue)
      return
    }
    
    do {
      try function({ (newResult: Any?) in  waterfall(newResult, Array(chain.dropFirst()), end: end) }, initialValue)
    } catch let error {
      end(error, nil)
    }
  }
}
