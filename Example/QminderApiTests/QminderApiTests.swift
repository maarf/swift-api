//
//  QminderApiTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 04/11/2016.
//  Copyright © 2016 Qminder. All rights reserved.
//

import Quick
import Nimble
import QminderAPI

class QminderApiTests : QuickSpec {

  override func spec() {
  
    /// Qminder API client
    let qminderAPI:QminderAPI = QminderAPI()
    
    /// Location ID
    let locationId:Int = Int(ProcessInfo.processInfo.environment["QMINDER_LOCATION_ID"]!)!
    
    /// Line ID
    let lineId:Int = Int(ProcessInfo.processInfo.environment["QMINDER_LINE_ID"]!)!
    
    /// Ticket ID
    var ticketId:Int!
    
    // Create Qminder API client
    beforeSuite {
      if let apiKey = ProcessInfo.processInfo.environment["QMINDER_API_KEY"] {
        qminderAPI.setApiKey(key: apiKey)
      }
    }
    
    describe("Qminder API tests") {
    
      // MARK: - Locations
      
      it("Get location list", closure: {
      
        var locations: Array<Location>?
      
        waitUntil(action: {done in
          qminderAPI.getLocationsList(completionHandler: {(l, error) in
            locations = l
            
            done()
          })
        })
        
        expect(locations).toEventuallyNot(beNil())
        expect(locations).toEventuallyNot(beEmpty())
      })
      
      it("Get location details", closure: {
        
        var details:Location?
        
        waitUntil(action: {done in
          qminderAPI.getLocationDetails(locationId: locationId, completionHandler: {(d, error) in
            details = d
            
            done()
          })
        })
        
        expect(details).notTo(beNil())
        
        expect(details?.id).notTo(beNil())
        expect(details?.name).notTo(beNil())
      })
      
      it("Get list of lines", closure: {
        
        var lines:Array<Line>?
        
        waitUntil(action: {done in
          qminderAPI.getLocationLines(locationId: locationId, completionHandler: {(l, error) in
            
            lines = l
            
            done()
          })
        })
        
        expect(lines).toEventuallyNot(beEmpty())
      })
      
      it("Get location users", closure: {
        var users:Array<User>?
        
        waitUntil(action: {done in
          qminderAPI.getLocationUsers(locationId: locationId, completionHandler: {(u, error) in
          
            users = u
          
            done()
          })
        })
        
        expect(users).toEventuallyNot(beEmpty())
      })
      
      // MARK: - Lines
      
      it("Get line details", closure: {
      
        var details:Line?
        
        waitUntil(action: {done in
          qminderAPI.getLineDetails(lineId: lineId, completionHandler: {(d, error) in
            details = d
            
            done()
          })
        })
        
        expect(details).toEventuallyNot(beNil())
        
        expect(details?.id).toEventuallyNot(beNil())
        expect(details?.name).toEventuallyNot(beNil())
        expect(details?.location).toEventuallyNot(beNil())
      
      })
      
      xit("Get estimated time of service", closure: {
        var estimatedTimeOfService:String?
        var estimatedPeopleWaiting:Int?
        
        waitUntil(action: {done in
          qminderAPI.getEstimatedTimeOfService(lineId: lineId, completionHandler: {(t, people, error) in
          
            estimatedTimeOfService = t
            estimatedPeopleWaiting = people
            
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
        
        waitUntil(action: {done in
          qminderAPI.searchTickets(locationId: locationId, limit: 10, completionHandler: {(t, error) in
            tickets = t
            
            // get first ticket id
            if let ticket = tickets?.first {
              ticketId = ticket.id
            }
            
            done()
          })
        })
        
        expect(tickets).toEventuallyNot(beNil())
        expect(ticketId).toEventuallyNot(beNil())
      })
      
      it("Search tickets with line ID", closure: {
      
        var tickets:Array<Ticket>?
        
        waitUntil(action: {done in
          qminderAPI.searchTickets(locationId: locationId, lineId: [lineId], limit: 10, completionHandler: {(t, error) in
            tickets = t
            
            done()
          })
        })
        
        expect(tickets).toEventuallyNot(beNil())
      })
      
      it("Search tickets with status", closure: {
      
        var tickets:Array<Ticket>?
        
        waitUntil(action: {done in
          qminderAPI.searchTickets(locationId: locationId, status: ["NEW", "CALLED", "CANCELLED", "CANCELLED_BY_CLERK", "NOSHOW", "SERVED"], limit: 10, completionHandler: {(t, error) in
            tickets = t
            
            done()
          })
        })
        
        expect(tickets).toEventuallyNot(beNil())
      })
      
      
      // ticket details
      
      it("Get ticket details", closure: {
        
        var details:Ticket?
        
        waitUntil(action: {done in
          qminderAPI.getTicketDetails(ticketId: ticketId, completionHandler: {(d, error) in
            details = d
            
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
            qminderAPI.getPairingCodeAndSecret(completionHandler: {
              (c, s, e) in
                code = c
                secret = s
                error = e as NSError?
              
                print("TESTS Pairing code: \(code)")
                print("TESTS Secret key: \(secret)")
                print("TESTS Secret key: \(error)")
              
                done()
            })
        })
        
        expect(code).toEventuallyNot(beEmpty())
        expect(secret).toEventuallyNot(beEmpty())
        expect(error).toEventually(beNil())
        
      }
    }
  }
}
