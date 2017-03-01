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
import ObjectMapper

class QminderApiTests : QuickSpec {

  override func spec() {
  
    /// Qminder API client
    let qminderAPI:QminderAPI = QminderAPI()
    
    var events:QminderEvents?
    
    
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
        events = QminderEvents(apiKey: apiKey, serverAddress: "ws://localhost:8889")
      }
    }
    
    describe("Qminder Events tests") {
    
      let parameters = ["location": locationId]
      var eventsResponses:Array<[String: Any?]> = []
    
      it("Subscribe to events") {
        events?.subscribe(eventName: "TICKET_CREATED", parameters: parameters, callback: {(data, error) in
          if error == nil {
            print(data)
            
            eventsResponses.append(data!)
          }
        })
        
        events?.subscribe(eventName: "TICKET_CALLED", parameters: parameters, callback: {(data, error) in
          if error == nil {
            print(data)
            
            eventsResponses.append(data!)
          }
        })
        
        events?.subscribe(eventName: "TICKET_RECALLED", parameters: parameters, callback: {(data, error) in
          if error == nil {
            print(data)
            
            eventsResponses.append(data!)
          }
        })
        
        events?.subscribe(eventName: "TICKET_CANCELLED", parameters: parameters, callback: {(data, error) in
          if error == nil {
            print(data)
            
            eventsResponses.append(data!)
          }
        })
        
        events?.subscribe(eventName: "TICKET_SERVED", parameters: parameters, callback: {(data, error) in
          if error == nil {
            print(data)
            
            eventsResponses.append(data!)
          }
        })
        
        events?.subscribe(eventName: "TICKET_CHANGED", parameters: parameters, callback: {(data, error) in
          if error == nil {
            print(data)
            
            eventsResponses.append(data!)
          }
        })
        
        
      }
      
      it("Get response from Websockets"){
        // Test run #1
        // Ticket created
        expect(eventsResponses).toEventually(containElementSatisfying({data -> Bool in
        
          guard let ticket = Ticket(JSON: data) else {
            return false
          }
          
          return ticket.id == 23853943 && ticket.status == "NEW" && ticket.firstName == "Name" && ticket.lastName == "Surname"
          
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket created")
        
        // Ticket edited
        expect(eventsResponses).toEventually(containElementSatisfying({data -> Bool in
          guard let ticket = Ticket(JSON: data) else {
            return false
          }
          
          return ticket.id == 23853943 && ticket.status == "NEW" && ticket.firstName == "Name2" && ticket.lastName == "Surname2"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")
        
        // Ticket deleted
        expect(eventsResponses).toEventually(containElementSatisfying({data -> Bool in
          guard let ticket = Ticket(JSON: data) else {
            return false
          }
          
          return ticket.id == 23853943 && ticket.status == "CANCELLED_BY_CLERK" && ticket.firstName == "Name2" && ticket.lastName == "Surname2"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")
        
        
        // Test run #2
        // Ticket created
        expect(eventsResponses).toEventually(containElementSatisfying({data -> Bool in
          guard let ticket = Ticket(JSON: data) else {
            return false
          }
          
          return ticket.id == 23856820 && ticket.status == "NEW" && ticket.firstName == "Name1" && ticket.lastName == "Surname1"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")
        
        // Ticket edited
        expect(eventsResponses).toEventually(containElementSatisfying({data -> Bool in
          guard let ticket = Ticket(JSON: data) else {
            return false
          }
          
          return ticket.id == 23856820 && ticket.status == "NEW" && ticket.firstName == "Name" && ticket.lastName == "Surname"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")
        
        // Ticket edited
        expect(eventsResponses).toEventually(containElementSatisfying({data -> Bool in
          guard let ticket = Ticket(JSON: data) else {
            return false
          }
          
          return ticket.id == 23856820 && ticket.status == "NEW" && ticket.firstName == "Name" && ticket.lastName == "Surname"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")
        
        // Ticket called
        expect(eventsResponses).toEventually(containElementSatisfying({data -> Bool in
          guard let ticket = Ticket(JSON: data) else {
            return false
          }
          
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
          guard let date = formatter.date(from: "2017-02-06T13:36:11Z") else {
            return false
          }
          
          guard let calledDate = ticket.called?.date else {
            return false
          }
          
          return ticket.id == 23856820 && ticket.status == "CALLED" && ticket.firstName == "Name" && ticket.lastName == "Surname" && date.compare(calledDate) == ComparisonResult.orderedSame
          
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")
        
        // Ticket re-called
        expect(eventsResponses).toEventually(containElementSatisfying({data -> Bool in
          guard let ticket = Ticket(JSON: data) else {
            return false
          }
          
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
          guard let date = formatter.date(from: "2017-02-06T13:36:21Z") else {
            return false
          }
          
          guard let calledDate = ticket.called?.date else {
            return false
          }
          
          return ticket.id == 23856820 && ticket.status == "CALLED" && ticket.firstName == "Name" && ticket.lastName == "Surname" && date.compare(calledDate) == ComparisonResult.orderedSame
          
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")
        
        // Ticket served
        expect(eventsResponses).toEventually(containElementSatisfying({data -> Bool in
          guard let ticket = Ticket(JSON: data) else {
            return false
          }
          
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
          guard let date = formatter.date(from: "2017-02-06T13:36:36Z") else {
            return false
          }
          
          guard let servedDate = ticket.served?.date else {
            return false
          }
          
          return ticket.id == 23856820 && ticket.status == "SERVED" && ticket.firstName == "Name" && ticket.lastName == "Surname" && date.compare(servedDate) == ComparisonResult.orderedSame
          
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")
        
      }
    }
    
    describe("Qminder API tests") {
    
      // MARK: - Locations
      
      it("Get location list", closure: {
      
        var locations: Array<Location>?
        var location: Location?
      
        waitUntil(action: {done in
          qminderAPI.getLocationsList(completionHandler: {(l, error) in
            locations = l
            
            location = locations?.first
            
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
        
        var lines: Array<Line>?
        var line: Line?
        
        waitUntil(action: {done in
          qminderAPI.getLocationLines(locationId: locationId, completionHandler: {(l, error) in
            
            lines = l
            
            line = lines?.first
            
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
          qminderAPI.getLocationUsers(locationId: locationId, completionHandler: {(u, error) in
          
            users = u
            
            user = users?.first
          
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
        var ticket: Ticket?
        
        waitUntil(action: {done in
          qminderAPI.searchTickets(locationId: locationId, limit: 10, completionHandler: {(t, error) in
            tickets = t
            
            // get first ticket id
            ticket = tickets?.first
            
            ticketId = ticket?.id
            
            done()
          })
        })
        
        expect(tickets).toEventuallyNot(beNil())
        expect(ticketId).toEventuallyNot(beNil())
        
        expect(ticket?.line).toEventuallyNot(beNil())
        expect(ticket?.source).toEventuallyNot(beNil())
        expect(ticket?.status).toEventuallyNot(beEmpty())
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
          qminderAPI.tvDetails(id: 666, completionHandler: {d, e in
            device = d
            error = e as? NSError
            
            done()
          })
        })
        
        expect(error).toEventuallyNot(beNil())
      }
      
      it("Send TV heartbeat even if it doesn't exist") {
        var error: NSError?
        
        waitUntil(action: {done in
          qminderAPI.tvHeartbeat(id: 666, metadata: ["foo": "bar"], completionHandler: {e in
            error = e as? NSError
            
            done()
          })
        })
        
        expect(error).toEventuallyNot(beNil())
      }
    }
  }
}
