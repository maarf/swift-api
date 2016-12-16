//
//  Ticket.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

import ObjectMapper

public struct Ticket: Mappable {
  
  public var id: Int?
  public var number: Int?
  public var line: Int?
  
  public var source: String?
  public var status: String?
  
  public var firstName: String?
  public var lastName: String?
  public var phoneNumber: String?
  
  public var created: Created?
  public var called: Called?
  public var served: Served?
  
  public var labels: Array<Label>?
  public var extra: Array<Extra>?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    id <- (map["id"], transformID)
    number <- map["number"]
    line <- map["line"]
    
    source <- map["source"]
    status <- map["status"]
    
    firstName <- map["firstName"]
    lastName <- map["lastName"]
    phoneNumber <- map["phoneNumber"]
    
    created <- map["created"]
    called <- map["called"]
    served <- map["served"]
    
    labels <- map["labels"]
    extra <- map["extra"]
  }
}

public struct Created: Mappable {
  public var date: Date?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    date <- (map["date"], DateTransform())
  }
}

public struct Called: Mappable {
  public var date: Date?
  public var desk: Int?
  public var caller: Int?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    date <- (map["date"], DateTransform())
    desk <- map["desk"]
    caller <- map["caller"]
  }
}

public struct Served: Mappable {
  public var date: Date?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    date <- (map["date"], DateTransform())
  }
}

struct Tickets: Mappable {
  var tickets: Array<Ticket>?
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    tickets <- map["data"]
  }
}

public struct Label: Mappable {
  public var color: String?
  public var value: String?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    color <- map["color"]
    value <- map["value"]
  }
}

public struct Extra: Mappable {
  public var title: String?
  public var value: String?
  public var url: String?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    title <- map["title"]
    value <- map["value"]
    url <- map["url"]
  }
}
