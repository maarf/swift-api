//
//  QminderWebsocketTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 29/01/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import Foundation

import Quick
import Nimble
import QminderAPI

class QminderWebsocketTests : QuickSpec {
  override func spec() {
    
    /// Qminder API client
    var qminderAPI: QminderAPI!
    var events: QminderEvents!
    
    /// Location ID
    let locationId:Int = Int(ProcessInfo.processInfo.environment["QMINDER_LOCATION_ID"]!)!
    
    // Create Qminder API client
    beforeSuite {
      if let apiKey = ProcessInfo.processInfo.environment["QMINDER_API_KEY"] {
        qminderAPI = QminderAPI(apiKey: apiKey)
        events = QminderEvents(apiKey: apiKey, serverAddress: "ws://localhost:8889")
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
          guard ticket.status == .new else { return false }
          
          return ticket.id == "23853943"  && ticket.firstName == "Name" && ticket.lastName == "Surname"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket created")
        
        // Ticket edited
        expect(eventsResponses).toEventually(containElementSatisfying({ticket -> Bool in
          guard ticket.status == .new else { return false }
          
          return ticket.id == "23853943"  && ticket.firstName == "Name2" && ticket.lastName == "Surname2"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")
        
        // Ticket deleted
        expect(eventsResponses).toEventually(containElementSatisfying({ticket -> Bool in
          guard ticket.status == .cancelledByClerk else { return false }
          
          return ticket.id == "23853943" && ticket.firstName == "Name2" && ticket.lastName == "Surname2"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")
        
        
        // Test run #2
        // Ticket created
        expect(eventsResponses).toEventually(containElementSatisfying({ticket -> Bool in
          guard ticket.status == .new else { return false }
          
          return ticket.id == "23856820"  && ticket.firstName == "Name1" && ticket.lastName == "Surname1"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")
        
        // Ticket edited
        expect(eventsResponses).toEventually(containElementSatisfying({ticket -> Bool in
          guard ticket.status == .new else { return false }
          
          return ticket.id == "23856820" && ticket.firstName == "Name" && ticket.lastName == "Surname"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")
        
        // Ticket edited
        expect(eventsResponses).toEventually(containElementSatisfying({ticket -> Bool in
          guard ticket.status == .new else { return false }
          
          return ticket.id == "23856820" && ticket.firstName == "Name" && ticket.lastName == "Surname"
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")
        
        // Ticket called
        expect(eventsResponses).toEventually(containElementSatisfying({ticket -> Bool in
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
          guard let date = formatter.date(from: "2017-02-06T13:36:11Z") else {
            return false
          }
          
          guard let calledDate = ticket.calledDate else {
            return false
          }
          
          return ticket.id == "23856820" && ticket.status == .called && ticket.firstName == "Name" && ticket.lastName == "Surname" && date.compare(calledDate) == ComparisonResult.orderedSame
          
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")
        
        // Ticket re-called
        expect(eventsResponses).toEventually(containElementSatisfying({ticket -> Bool in
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
          guard let date = formatter.date(from: "2017-02-06T13:36:21Z") else {
            return false
          }
          
          guard let calledDate = ticket.calledDate else {
            return false
          }
          
          return ticket.id == "23856820" && ticket.status == .called && ticket.firstName == "Name" && ticket.lastName == "Surname" && date.compare(calledDate) == ComparisonResult.orderedSame
          
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
          
          return ticket.id == "23856820" && ticket.status == .served && ticket.firstName == "Name" && ticket.lastName == "Surname" && date.compare(servedDate) == ComparisonResult.orderedSame
          
        }), timeout: 30.0, pollInterval: 3.0, description: "Ticket edited")
        
      }
    }
    
  }
}
