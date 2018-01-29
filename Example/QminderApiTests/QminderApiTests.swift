//
//  QminderApiTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 04/11/2016.
//  Copyright © 2016 Qminder. All rights reserved.
//


import Nimble
import Quick
import QminderAPI

class QminderApiTests : QuickSpec {

  override func spec() {
  
    /// Qminder API client
    var qminderAPI: QminderAPI!
    var events: QminderEvents!
    
    
    /// Location ID
    let locationId:Int = Int(ProcessInfo.processInfo.environment["QMINDER_LOCATION_ID"]!)!
    
    /// Line ID
    let lineId:Int = Int(ProcessInfo.processInfo.environment["QMINDER_LINE_ID"]!)!
    
    /// Ticket ID
    var ticketId:String!
    
    let jsonDecoderWithMilliseconds: JSONDecoder = {
      let jsonDecoder = JSONDecoder()
      
      let dateISO8601ShortFormatter = DateFormatter()
      dateISO8601ShortFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
      
      let dateISO8601Formatter = DateFormatter()
      dateISO8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      
      let dateISO8601MillisecondsFormatter = DateFormatter()
      dateISO8601MillisecondsFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      
      jsonDecoder.dateDecodingStrategy = .custom({decoder -> Date in
        
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)
        
        // possible date strings: "yyyy-MM-dd'T'HH:mm:ssZ" or "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        var tmpDate: Date? = nil
        
        if dateStr.count == 17 {
          tmpDate = dateISO8601ShortFormatter.date(from: dateStr)
        } else if dateStr.count == 24 {
          tmpDate = dateISO8601MillisecondsFormatter.date(from: dateStr)
        } else {
          tmpDate = dateISO8601Formatter.date(from: dateStr)
        }
        
        guard let date = tmpDate else {
          throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
        }
        
        return date
      })
      
      return jsonDecoder
    }()
    
    // Create Qminder API client
    beforeSuite {
      if let apiKey = ProcessInfo.processInfo.environment["QMINDER_API_KEY"] {
        qminderAPI = QminderAPI(apiKey: apiKey)
      }
    }
    
    describe("Qminder API tests") {
      
      // MARK: - Locations
      
      it("Get location list", closure: {
      
        var locations: [Location]?
        var location: Location?
      
        waitUntil(action: {done in
          qminderAPI.getLocationsList(completion: {result in
          
            if result.isSuccess {
              locations = result.value
              location = (locations?.first)!
            }
          
            done()
          })
        })
        
        expect(locations).toEventuallyNot(beNil())
        expect(locations).toEventuallyNot(beEmpty())
        
        expect(location).toEventuallyNot(beNil())
        expect(location?.id).toEventuallyNot(beNil())
        expect(location?.name).toEventuallyNot(beEmpty())
      })
      
      it("Get location details", closure: {
        
        var details: Location?
        
        waitUntil(action: {done in
          qminderAPI.getLocationDetails(locationId: locationId, completion: {result in
          
            if result.isSuccess {
              details = result.value
            }
            
            done()
          })
        })
        
        expect(details).notTo(beNil())
        
        expect(details?.id).notTo(beNil())
        expect(details?.name).notTo(beNil())
      })
      
      it("Get list of lines", closure: {
        
        var lines: Array<Line>?
        var line: Line?
        
        waitUntil(action: {done in
          qminderAPI.getLocationLines(locationId: locationId, completion: {result in
            
            if result.isSuccess {
            
              lines = result.value
            
              line = lines?.first
            }
            
            done()
          })
        })
        
        expect(lines).toEventuallyNot(beEmpty())
        
        expect(line).toEventuallyNot(beNil())
        expect(line?.id).toEventuallyNot(beNil())
        expect(line?.name).toEventuallyNot(beEmpty())
      })
      
      it("Get location users", closure: {
        
        var users: Array<User>?
        var user: User?
        
        waitUntil(action: {done in
          qminderAPI.getLocationUsers(locationId: locationId, completion: {result in
          
            if result.isSuccess {
          
              users = result.value
            
              user = users?.first
            }
          
            done()
          })
        })
        
        expect(users).toEventuallyNot(beEmpty())
        
        expect(user).toEventuallyNot(beNil())
        expect(user?.id).toEventuallyNot(beNil())
        expect(user?.firstName).toEventuallyNot(beEmpty())
        expect(user?.lastName).toEventuallyNot(beEmpty())
        expect(user?.email).toEventuallyNot(beEmpty())
      })
      
      it("Get location desks") {
        var desks: [Desk]?
        var desk: Desk?
        
        waitUntil(action: { done in
          qminderAPI.getLocationDesks(locationId: locationId, completion: { result in
            if result.isSuccess {
              desks = result.value
              desk = desks?.first
            }
            
            done()
          })
        })
        
        expect(desks).toEventuallyNot(beEmpty())
        expect(desk).toEventuallyNot(beNil())
        expect(desk?.id).toEventuallyNot(beNil())
        expect(desk?.name).toEventuallyNot(beNil())
      }
      
      // MARK: - Lines
      
      it("Get line details", closure: {
      
        var details:Line?
        
        waitUntil(action: {done in
          qminderAPI.getLineDetails(lineId: lineId, completion: {result in
            
            if result.isSuccess {
              details = result.value
            }
            
            done()
          })
        })
        
        expect(details).toEventuallyNot(beNil())
        
        expect(details?.id).toEventuallyNot(beNil())
        expect(details?.name).toEventuallyNot(beNil())
        expect(details?.location).toEventuallyNot(beNil())
      
      })
      
      xit("Get estimated time of service", closure: {
        var estimatedTimeOfService:Date?
        var estimatedPeopleWaiting:Int?
        
        waitUntil(action: {done in
          qminderAPI.getEstimatedTimeOfService(lineId: lineId, completion: {result in
          
            if result.isSuccess {
              estimatedTimeOfService = result.value?.estimatedTimeOfService
              estimatedPeopleWaiting = result.value?.estimatedPeopleWaiting
            }
            
            done()
          })
        })
        
        expect(estimatedTimeOfService).toEventuallyNot(beNil())
        expect(estimatedPeopleWaiting).toEventuallyNot(beNil())
        
      })
      
      
      // MARK: - Tickets
      
      // search tickets
      it("Search tickets with location ID", closure: {
      
        var tickets: Array<Ticket>?
        var ticket: Ticket?
        
        waitUntil(action: {done in
          qminderAPI.searchTickets(locationId: locationId, limit: 10, completion: {result in
            
            if result.isSuccess {
              tickets = result.value
            
              // get first ticket id
              ticket = tickets?.first
            
              ticketId = ticket?.id
            }
            
            done()
          })
        })
        
        expect(tickets).toEventuallyNot(beNil())
        expect(ticketId).toEventuallyNot(beNil())
        
        expect(ticket?.line).toEventuallyNot(beNil())
        expect(ticket?.source).toEventuallyNot(beNil())
      })
      
      it("Search tickets with line ID", closure: {
      
        var tickets:Array<Ticket>?
        
        waitUntil(action: {done in
          qminderAPI.searchTickets(locationId: locationId, lineId: [lineId], limit: 10, completion: {result in
            if result.isSuccess {
              tickets = result.value
            }
            
            done()
          })
        })
        
        expect(tickets).toEventuallyNot(beNil())
      })
      
      it("Search tickets with status", closure: {
      
        var tickets:Array<Ticket>?
        
        waitUntil(action: {done in
          qminderAPI.searchTickets(locationId: locationId, status: ["NEW", "CALLED", "CANCELLED", "CANCELLED_BY_CLERK", "NOSHOW", "SERVED"], limit: 10, completion: {result in
            if result.isSuccess {
              tickets = result.value
            }
            
            done()
          })
        })
        
        expect(tickets).toEventuallyNot(beNil())
      })
      
      
      // ticket details
      
      it("Get ticket details", closure: {
        
        var details:Ticket?
        
        waitUntil(action: {done in
          qminderAPI.getTicketDetails(ticketId: ticketId, completion: {result in
            
            if result.isSuccess {
              details = result.value
            }
            
            done()
          })
        })
        
        expect(details).toEventuallyNot(beNil())
        
        expect(details?.id).toEventuallyNot(beNil())
        expect(details?.source).toEventuallyNot(beNil())
        expect(details?.status).toEventuallyNot(beNil())
        expect(details?.line).toEventuallyNot(beNil())
        expect(details?.created).toEventuallyNot(beNil())
      })

      
      // MARK: - Devices
      it("Getting pairing code and secret") {
        
        var code:String?
        var secret:String?
        var error:NSError?
        
        waitUntil(action: {
          done in
            qminderAPI.getPairingCodeAndSecret(completion: {result in
              
              if result.isSuccess {
                code = result.value?.code
                secret = result.value?.secret
              } else {
                error = result.error as NSError?
              }
              
              done()
            })
        })
        
        expect(code).toEventuallyNot(beEmpty())
        expect(secret).toEventuallyNot(beEmpty())
        expect(error).toEventually(beNil())
        
      }
      
      it("Getting TV details even if it doesn't exist") {
        var device: TVDevice?
        var error: NSError?
        
        waitUntil(action: {done in
          qminderAPI.tvDetails(id: 666, completion: {result in
            if result.isSuccess {
              device = result.value
            } else {
              error = result.error as NSError?
            }
            
            done()
          })
        })
        
        expect(error).toEventuallyNot(beNil())
        expect(device).toEventually(beNil())
      }
      
      it("Send TV heartbeat even if it doesn't exist") {
        var error: NSError?
        
        waitUntil(action: {done in
          qminderAPI.tvHeartbeat(id: 666, metadata: ["foo": "bar"], completion: {result in
            
            if result.isFailure {
              error = result.error as NSError?
            }
            
            done()
          })
        })
        
        expect(error).toEventuallyNot(beNil())
      }
    }
  }
}
