//
//  Ticket.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

import ObjectMapper

/// Ticket mapping object
public struct Ticket: Mappable {
  
  /// A unique ticket ID
  public var id: Int?
  
  /// Ticket number
  public var number: Int?
  
  /// Line ID
  public var line: Int?
  
  /// Source of the ticket. "MANUAL", "NAME" or "PRINTER". This field will not be present if no source has been specified when creating a ticket.
  public var source: String?
  
  /// Ticket status. "NEW", "CALLED", "CANCELLED", "CANCELLED_BY_CLERK", "NOSHOW" or "SERVED"
  public var status: String?
  
  /// First name
  public var firstName: String?
  
  /// 	Last name
  public var lastName: String?
  
  /// Phone number
  public var phoneNumber: Int?
  
  /// Created data
  public var created: Created?
  
  /// Called data
  public var called: Called?
  
  /// Served data
  public var served: Served?
  
  /// Labels
  public var labels: Array<Label>?
  
  /// Extra info
  public var extra: Array<Extra>?
  
  /// Order after
  public var orderAfter: Date?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    id <- (map["id"], transformFromStringToInt)
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
    
    // need to parse also miliseconds
    orderAfter <- (map["orderAfter"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"))
    
    labels <- map["labels"]
    extra <- map["extra"]
  }
}

/// Created data object
public struct Created: Mappable {

  /// Time when ticket was created
  public var date: Date?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    date <- (map["date"], ISO8601DateTransform())
  }
}

/// Called data
public struct Called: Mappable {

  /// Call date
  public var date: Date?
  
  /// Desk number
  public var desk: Int?
  
  /// User ID of a clerk who called the ticket
  public var caller: Int?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    date <- (map["date"], ISO8601DateTransform())
    desk <- map["desk"]
    caller <- map["caller"]
  }
}

/// Served object
public struct Served: Mappable {

  /// Date of the end of the service
  public var date: Date?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    date <- (map["date"], ISO8601DateTransform())
  }
}

/// Label object
public struct Label: Mappable {

  /// Label hex color code
  public var color: String?
  
  /// Value
  public var value: String?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    color <- map["color"]
    value <- map["value"]
  }
}

/// Extra object
public struct Extra: Mappable {

  /// Title
  public var title: String?
  
  /// Value
  public var value: String?
  
  /// URL if there is
  public var url: String?
  
  public init?(map: Map) {}
  
  mutating public func mapping(map: Map) {
    title <- map["title"]
    value <- map["value"]
    url <- map["url"]
  }
}


/// Tickets object
struct Tickets: Mappable {
  
  /// Tickets array
  var tickets: Array<Ticket>?
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    tickets <- map["data"]
  }
}
