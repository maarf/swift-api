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
    let qminderAPI = QminderAPI.sharedInstance
    let events = QminderEvents.sharedInstance
    
    
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
        qminderAPI.setup(apiKey: apiKey)
        events.setup(apiKey: apiKey, serverAddress: "ws://localhost:8889")
      }
    }
    
    describe("Qminder Events tests") {

      let parameters = ["location": locationId]
      var eventsResponses: [Ticket] = []

      it("Subscribe to events") {
        
        events.subscribe(toTicketEvent: .ticketCreated, parameters: parameters, callback: { result in
          switch result {
          case .success(let ticket):
            print(ticket)
            
            eventsResponses.append(ticket)
          default:
            break
          }
        })
        
        events.subscribe(toTicketEvent: .ticketCalled, parameters: parameters, callback: { result in
          switch result {
          case .success(let ticket):
            print(ticket)
            
            eventsResponses.append(ticket)
          default:
            break
          }
        })
        
        events.subscribe(toTicketEvent: .ticketRecalled, parameters: parameters, callback: { result in
          switch result {
          case .success(let ticket):
            print(ticket)
            
            eventsResponses.append(ticket)
          default:
            break
          }
        })
        
        events.subscribe(toTicketEvent: .ticketCancelled, parameters: parameters, callback: { result in
          switch result {
          case .success(let ticket):
            print(ticket)
            
            eventsResponses.append(ticket)
          default:
            break
          }
        })
        
        events.subscribe(toTicketEvent: .ticketServed, parameters: parameters, callback: { result in
          switch result {
          case .success(let ticket):
            print(ticket)
            
            eventsResponses.append(ticket)
          default:
            break
          }
        })
        
        events.subscribe(toTicketEvent: .ticketChanged, parameters: parameters, callback: { result in
          switch result {
          case .success(let ticket):
            print(ticket)
            
            eventsResponses.append(ticket)
          default:
            break
          }
        })
      }

      it("Get response from Websockets"){
        // Test run #1
        // Ticket created

        expect(eventsResponses).toEventually(containElementSatisfying({ticket -> Bool in
          ticket.id == "23853943" && ticket.status == "NEW" && ticket.firstName == "Name" && ticket.lastName == "Surname"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket created")

        // Ticket edited
        expect(eventsResponses).toEventually(containElementSatisfying({ticket -> Bool in
          return ticket.id == "23853943" && ticket.status == "NEW" && ticket.firstName == "Name2" && ticket.lastName == "Surname2"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")

        // Ticket deleted
        expect(eventsResponses).toEventually(containElementSatisfying({ticket -> Bool in
          return ticket.id == "23853943" && ticket.status == "CANCELLED_BY_CLERK" && ticket.firstName == "Name2" && ticket.lastName == "Surname2"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")


        // Test run #2
        // Ticket created
        expect(eventsResponses).toEventually(containElementSatisfying({ticket -> Bool in
          return ticket.id == "23856820" && ticket.status == "NEW" && ticket.firstName == "Name1" && ticket.lastName == "Surname1"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")

        // Ticket edited
        expect(eventsResponses).toEventually(containElementSatisfying({ticket -> Bool in
          return ticket.id == "23856820" && ticket.status == "NEW" && ticket.firstName == "Name" && ticket.lastName == "Surname"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")

        // Ticket edited
        expect(eventsResponses).toEventually(containElementSatisfying({ticket -> Bool in
          return ticket.id == "23856820" && ticket.status == "NEW" && ticket.firstName == "Name" && ticket.lastName == "Surname"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")

        // Ticket called
        expect(eventsResponses).toEventually(containElementSatisfying({ticket -> Bool in
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
          guard let date = formatter.date(from: "2017-02-06T13:36:11Z") else {
            return false
          }

          guard let calledDate = ticket.called?.date else {
            return false
          }

          return ticket.id == "23856820" && ticket.status == "CALLED" && ticket.firstName == "Name" && ticket.lastName == "Surname" && date.compare(calledDate) == ComparisonResult.orderedSame

        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")

        // Ticket re-called
        expect(eventsResponses).toEventually(containElementSatisfying({ticket -> Bool in
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
          guard let date = formatter.date(from: "2017-02-06T13:36:21Z") else {
            return false
          }

          guard let calledDate = ticket.called?.date else {
            return false
          }

          return ticket.id == "23856820" && ticket.status == "CALLED" && ticket.firstName == "Name" && ticket.lastName == "Surname" && date.compare(calledDate) == ComparisonResult.orderedSame

        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")

        // Ticket served
        expect(eventsResponses).toEventually(containElementSatisfying({ticket -> Bool in
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
          guard let date = formatter.date(from: "2017-02-06T13:36:36Z") else {
            return false
          }

          guard let servedDate = ticket.served?.date else {
            return false
          }

          return ticket.id == "23856820" && ticket.status == "SERVED" && ticket.firstName == "Name" && ticket.lastName == "Surname" && date.compare(servedDate) == ComparisonResult.orderedSame

        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")

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
        expect(ticket?.status).toEventuallyNot(beEmpty())
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
    
    // MARK: - Test models
    describe("Test models") {
  
      //MARK: Ticket model
      describe("test ticket model") {
      
        var data: [String: Any] = [
          "status" : "NEW",
          "source" : "MANUAL",
          "firstName" : "Name",
          "id" : "999",
          "created" : [
            "date" : "2017-02-06T12:35:29Z"
          ],
          "line" : 333,
          "lastName" : "Surname"
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
      
        it("parse without milliseconds") {
          let ticket = try? jsonDecoderWithMilliseconds.decode(Ticket.self, from: jsonData!)
        
          expect(ticket?.id).to(equal("999"))
          expect(ticket?.source).to(equal("MANUAL"))
          expect(ticket?.status).to(equal("NEW"))
          expect(ticket?.firstName).to(equal("Name"))
          expect(ticket?.lastName).to(equal("Surname"))
          expect(ticket?.line).to(equal(333))
          expect(ticket?.created?.date).toNot(beNil())
        }
        
        it ("parse with milliseconds") {
          
          data["created"] = ["date" : "2017-02-06T12:35:29.123Z"]
          
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        
          let ticket = try? jsonDecoderWithMilliseconds.decode(Ticket.self, from: jsonData!)

          expect(ticket?.created?.date).toNot(beNil())
        }
        
        it ("should parse order after without milliseconds") {
          data["orderAfter"] = "2017-02-06T12:35:29Z"
        
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
          
          let ticket = try? jsonDecoderWithMilliseconds.decode(Ticket.self, from: jsonData!)

          expect(ticket?.orderAfter).toNot(beNil())
        }
        
        it ("should parse order after with milliseconds") {
          data["orderAfter"] = "2017-02-06T12:35:29.123Z"
        
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
          
          let ticket = try? jsonDecoderWithMilliseconds.decode(Ticket.self, from: jsonData!)

          expect(ticket?.orderAfter).toNot(beNil())
        }
        
        it ("should parse called date, user id, desk") {
          data["called"] = ["date": "2017-02-06T12:35:29Z", "caller": 444, "desk": 3]
        
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
          
          let ticket = try? jsonDecoderWithMilliseconds.decode(Ticket.self, from: jsonData!)

          expect(ticket?.called?.date).toNot(beNil())
          expect(ticket?.called?.caller).to(equal(444))
          expect(ticket?.called?.desk).to(equal(3))
        }
        
        it ("should parse served date") {
          data["served"] = ["date": "2017-02-06T12:35:29Z"]
        
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
          
          let ticket = try? jsonDecoderWithMilliseconds.decode(Ticket.self, from: jsonData!)

          expect(ticket?.served?.date).toNot(beNil())
        }
        
        it ("should parse labels") {
          data["labels"] = [["color": "#000000", "value": "Test"]]
        
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
          
          let ticket = try? jsonDecoderWithMilliseconds.decode(Ticket.self, from: jsonData!)
          
          expect(ticket?.labels).toNot(beNil())
          
          
          expect(ticket?.labels).to(containElementSatisfying({label in
            return label.color == "#000000" && label.value == "Test"
          }))
        }
        
        it ("should parse extra fields") {
          data["extra"] = [["title": "Title", "value": "Test", "url": "http://www.google.com"]]
        
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
          
          let ticket = try? jsonDecoderWithMilliseconds.decode(Ticket.self, from: jsonData!)
          
          expect(ticket?.extra).toNot(beNil())
          
          
          expect(ticket?.extra).to(containElementSatisfying({extra in
            return extra.title == "Title" //&& extra.value == "Test" && extra.url == "http://www.google.com"
          }))
          
          expect(ticket?.extra).to(containElementSatisfying({extra in
            return extra.value == "Test" && extra.url == "http://www.google.com"
          }))
        }
      }
      
      
      //MARK: Line model
      describe ("Test line model") {
        var data: [String: Any] = [
          "id" : 999,
          "name" : "Line name",
          "location" : 333
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        
        it ("should parse normal data") {
          let line = try? JSONDecoder().decode(Line.self, from: jsonData!)
          
          expect(line?.id).to(equal(999))
          expect(line?.name).to(equal("Line name"))
          expect(line?.location).to(equal(333))
        }
        
        it ("should parse id and location as string") {
        
          data["id"] = 999
          data["location"] = 333
          
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        
          let line = try? JSONDecoder().decode(Line.self, from: jsonData!)
          
          expect(line?.id).to(equal(999))
          expect(line?.location).to(equal(333))
        }
      }
      
      
      // MARK: Location model
      describe ("Test location model") {
        let data: [String: Any] = [
          "id": 999,
          "name": "Location name",
          "latitude": 25.5555,
          "longitude": 24.666,
          "timezoneOffset": 4
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        
        it ("should parse normal data") {
          
          let location = try? JSONDecoder().decode(Location.self, from: jsonData!)
          
          expect(location?.id).to(equal(999))
          expect(location?.name).to(equal("Location name"))
          expect(location?.timezoneOffset).to(equal(4))
          expect(location?.latitude).to(equal(25.5555))
          expect(location?.longitude).to(equal(24.666))
        }
      }
      
      
      // MARK: TV device model
      describe("Test TV device model") {
        var data: [String: Any] = [
          "statusCode": 200,
          "id": 999,
          "name": "Apple TV",
          "settings": ["lines": [1, 2, 3], "clearTickets": "afterCalling"],
          "theme": "Default"
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        
        it ("should parse normal data") {
          let device = try? JSONDecoder().decode(TVDevice.self, from: jsonData!)
        
          expect(device?.id).to(equal(999))
          expect(device?.name).to(equal("Apple TV"))
          expect(device?.theme).to(equal("Default"))
          expect(device?.settings).toNot(beNil())
          expect(device?.settings?.lines).toNot(beEmpty())
          expect(device?.settings?.clearTickets).to(equal("afterCalling"))
          
          expect(device?.settings?.lines).to(containElementSatisfying({line in
            return line == 1
          }))
          
          expect(device?.settings?.lines).to(containElementSatisfying({line in
            return line == 2
          }))
          
          expect(device?.settings?.lines).to(containElementSatisfying({line in
            return line == 3
          }))
        }
        
        it ("should parse without settings") {
          data["settings"] = nil
          
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
          
          let device = try? JSONDecoder().decode(TVDevice.self, from: jsonData!)
          
          expect(device?.settings).to(beNil())
          expect(device?.settings?.lines).to(beNil())
        }
      }
      
      
      // MARK: User model
      describe("Test User model") {
        let data: [String: Any] = [
          "id": 999,
          "email": "john@example.com",
          "firstName": "John",
          "lastName": "Appleseed",
          "desk": 1,
          "roles": [["type": "MANAGER", "location": 3245], ["type": "USER", "location": 1265]],
          "picture": [["size": "medium", "url": "http://www.google.com/"]]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        
        it("should parse normal data") {
          let user = try? JSONDecoder().decode(User.self, from: jsonData!)
          
          expect(user?.id).to(equal(999))
          expect(user?.email).to(equal("john@example.com"))
          expect(user?.firstName).to(equal("John"))
          expect(user?.lastName).to(equal("Appleseed"))
          expect(user?.desk).to(equal(1))
          
          expect(user?.roles).toNot(beEmpty())
          
          expect(user?.roles).to(containElementSatisfying({role in
            return role.type == "MANAGER" && role.location == 3245
          }))
          
          expect(user?.roles).to(containElementSatisfying({role in
            return role.type == "USER" && role.location == 1265
          }))
          
          expect(user?.picture).toNot(beEmpty())
          
          expect(user?.picture).to(containElementSatisfying({picture in
            return picture.size == "medium"
          }))
          
          expect(user?.picture).to(containElementSatisfying({picture in
            return picture.url == "http://www.google.com/"
          }))
        }
      }
      
      // MARK: Estimated time of service
      describe("Test Estimated time of service model") {
        let data: [String: Any] = [
          "statusCode": 200,
          "estimatedTimeOfService": "2013-07-03T16:27Z",
          "estimatedPeopleWaiting": 3
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        
        it("should parse normal data") {
          let estimatedTimeOfService = try? jsonDecoderWithMilliseconds.decode(EstimatedTimeOfService.self, from: jsonData!)
          
          expect(estimatedTimeOfService?.estimatedTimeOfService).toNot(beNil())
          expect(estimatedTimeOfService?.estimatedPeopleWaiting).to(equal(3))
        }
      }
      
      
      // MARK: TV API data
      describe("Test TV API data model") {
        it("Should parse normal data PAIRED") {
          let data: [String: Any] = [
            "statusCode": 200,
            "status": "PAIRED",
            "id": 41078,
            "apiKey": "804ef75ba9b6b5264c96150b457f8f30",
            "location": 666
          ]
          
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
          
          let tvAPIData = try? JSONDecoder().decode(TVAPIData.self, from: jsonData!)
          
          expect(tvAPIData?.status).to(equal("PAIRED"))
          expect(tvAPIData?.id).to(equal(41078))
          expect(tvAPIData?.apiKey).to(equal("804ef75ba9b6b5264c96150b457f8f30"))
          expect(tvAPIData?.location).to(equal(666))
        }
        
        it("Should parse normal data NOT_PAIRED") {
          let data: [String: Any] = [
            "statusCode": 200,
            "status": "NOT_PAIRED"
          ]
          
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
          
          let tvAPIData = try? JSONDecoder().decode(TVAPIData.self, from: jsonData!)
          
          expect(tvAPIData?.status).to(equal("NOT_PAIRED"))
          expect(tvAPIData?.id).to(beNil())
          expect(tvAPIData?.apiKey).to(beNil())
          expect(tvAPIData?.location).to(beNil())
        }
      }
      
      
      // MARK: TV Pairing code
      describe("Test TV pairing code model") {
        let data : [String: Any] = [
          "statusCode": 200,
          "code": "PW3R",
          "secret": "75aa16d7923ac707cc302e1ce7c81e8a"
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        
        it("should parse normal data") {
          let tvPairingCode = try? JSONDecoder().decode(TVPairingCode.self, from: jsonData!)
          
          expect(tvPairingCode?.code).to(equal("PW3R"))
          expect(tvPairingCode?.secret).to(equal("75aa16d7923ac707cc302e1ce7c81e8a"))
        }
      }
    }
  }
}
