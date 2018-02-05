//
//  QminderModelTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 25/01/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import QminderAPI
import Quick
import Nimble

class QminderModelTests : QuickSpec {
  
  override func spec() {
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
    
    // MARK: - Empty state
    describe("Parsing empty state") {
      
      it("Closed empty state") {
        let data: [String: Any] = [
          "statusCode": 200,
          "layout": "closed",
          "message": "closed message"
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        let emptyState = try? JSONDecoder().decode(EmptyState.self, from: jsonData!)

        expect(emptyState?.message).to(equal("closed message"))
        expect(emptyState?.layout).to(equal(.closed))
      }
      
      it("Other empty state") {
        let data: [String: Any] = [
          "statusCode": 200,
          "layout": "other",
          "message": "other message"
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        let emptyState = try? JSONDecoder().decode(EmptyState.self, from: jsonData!)
        
        expect(emptyState?.message).to(equal("other message"))
        expect(emptyState?.layout).to(equal(.other))
      }
    }
    
    // MARK: - Test models
    describe("Test models") {
      
      let dateISO8601Formatter = DateFormatter()
      dateISO8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      
      let dateISO8601MillisecondsFormatter = DateFormatter()
      dateISO8601MillisecondsFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      
      //MARK: Ticket model
      describe("test ticket model") {
        
        let createdDateString = "2017-02-06T12:35:29Z"
        
        var data: [String: Any] = [
          "status" : "NEW",
          "source" : "MANUAL",
          "firstName" : "Name",
          "id" : "999",
          "created" : [
            "date" : createdDateString
          ],
          "line" : 333,
          "lastName" : "Surname"
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        
        it("parse without milliseconds") {
          let ticket = try? jsonDecoderWithMilliseconds.decode(Ticket.self, from: jsonData!)
          
          expect(ticket?.id).to(equal("999"))
          expect(ticket?.source).to(equal(.manual))
          expect(ticket?.status).to(equal(.new))
          expect(ticket?.firstName).to(equal("Name"))
          expect(ticket?.lastName).to(equal("Surname"))
          expect(ticket?.line).to(equal(333))
          expect(ticket?.createdDate).to(equal(dateISO8601Formatter.date(from: createdDateString)))
        }
        
        it ("parse with milliseconds") {
          
          let createdDateString = "2017-02-06T12:35:29.123Z"
          data["created"] = ["date" : createdDateString]
          
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
          
          let ticket = try? jsonDecoderWithMilliseconds.decode(Ticket.self, from: jsonData!)
          
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
          
          expect(ticket?.createdDate).to(equal(dateISO8601MillisecondsFormatter.date(from: createdDateString)))
        }
        
        it ("should parse order after without milliseconds") {
          let orderAfterDateString = "2017-02-06T12:35:29Z"
          data["orderAfter"] = orderAfterDateString
          
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
          
          let ticket = try? jsonDecoderWithMilliseconds.decode(Ticket.self, from: jsonData!)
          
          expect(ticket?.orderAfter).toNot(beNil())
          expect(ticket?.orderAfter).to(equal(dateISO8601Formatter.date(from: orderAfterDateString)))
        }
        
        it ("should parse order after with milliseconds") {
          let orderAfterDateString = "2017-02-06T12:35:29.123Z"
          data["orderAfter"] = orderAfterDateString
          
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
          
          let ticket = try? jsonDecoderWithMilliseconds.decode(Ticket.self, from: jsonData!)
          
          expect(ticket?.orderAfter).toNot(beNil())
          expect(ticket?.orderAfter).to(equal(dateISO8601MillisecondsFormatter.date(from: orderAfterDateString)))
        }
        
        it ("should parse called date, user id, desk") {
          let calledDateString = "2017-02-06T12:35:29Z"
          data["interactions"] = [
            ["start": calledDateString,
             "line": 62633,
             "desk": 1,
             "user": 444
            ]
          ]
          
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
          
          let ticket = try? jsonDecoderWithMilliseconds.decode(Ticket.self, from: jsonData!)
          
          expect(ticket?.calledDate).toNot(beNil())
          expect(ticket?.calledDate).to(equal(dateISO8601Formatter.date(from: calledDateString)))
          expect(ticket?.calledUserID).to(equal(444))
          expect(ticket?.calledDeskID).to(equal(1))
        }
        
        it ("should parse served date") {
          let servedDateString = "2017-02-06T12:35:29Z"
          data["served"] = ["date": servedDateString]
          
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
          
          let ticket = try? jsonDecoderWithMilliseconds.decode(Ticket.self, from: jsonData!)
          
          expect(ticket?.servedDate).toNot(beNil())
          expect(ticket?.servedDate).to(equal(dateISO8601Formatter.date(from: servedDateString)))
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
        
        it ("Ticket with interactions data") {
          data["interactions"] = [
            ["start": "2018-01-29T12:55:46Z",
             "end": "2018-01-29T12:55:51Z",
             "line": 62633,
             "desk": 6202,
             "user": 891
            ]
          ]
          
          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
          
          let ticket = try? jsonDecoderWithMilliseconds.decode(Ticket.self, from: jsonData!)
          
          expect(ticket?.interactions).toNot(beNil())
          
          let interaction = ticket?.interactions?.first
          expect(interaction?.start).to(equal(dateISO8601Formatter.date(from: "2018-01-29T12:55:46Z")))
          expect(interaction?.end).to(equal(dateISO8601Formatter.date(from: "2018-01-29T12:55:51Z")))
          expect(interaction?.line).to(equal(62633))
          expect(interaction?.desk).to(equal(6202))
          expect(interaction?.user).to(equal(891))
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
