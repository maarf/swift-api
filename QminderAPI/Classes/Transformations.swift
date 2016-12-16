//
//  Transformations.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

import ObjectMapper

let transformID = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
  // transform value from String? to Int?
  return Int(value!)
}, toJSON: { (value: Int?) -> String? in
  // transform value from Int? to String?
  if let value = value {
    return String(value)
  }
  return nil
})
