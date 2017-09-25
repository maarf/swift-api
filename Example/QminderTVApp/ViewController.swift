//
//  ViewController.swift
//  QminderTVApp
//
//  Created by Kristaps Grinbergs on 27/10/2016.
//  Copyright © 2016 Qminder. All rights reserved.
//

import UIKit
import QminderAPI

struct EventInfo {
  var eventName:String
  var data:Dictionary<String, Any>
}

/// Demonstrates Qminder iOS API usage in Apple TV
class ViewController: UIViewController, QminderEventsDelegate, UITableViewDelegate, UITableViewDataSource {
  
  /// Events array
  private var eventsArray:[EventInfo] = []
  
  /// Timer to check pair status
  private var timer = Timer()
  
  /// Qminder API provider
  private var qminderAPI = QminderAPI.sharedInstance
  
  /// Qminder Websockets provider
  private var events = QminderEvents.sharedInstance
  
  /// JSON decoder with milliseconds
  private let jsonDecoderWithMilliseconds: JSONDecoder = {
    let jsonDecoder = JSONDecoder()
    
    let dateISO8601Formatter = DateFormatter()
    dateISO8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    let dateISO8601MillisecondsFormatter = DateFormatter()
    dateISO8601MillisecondsFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    jsonDecoder.dateDecodingStrategy = .custom({decoder -> Date in
      
      let container = try decoder.singleValueContainer()
      let dateStr = try container.decode(String.self)
      
      // possible date strings: "yyyy-MM-dd'T'HH:mm:ssZ" or "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      
      var tmpDate: Date? = nil
      
      if dateStr.count == 24 {
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
  
  /// Pairing code label
  @IBOutlet var pairingCode: UILabel!
  
  /// Events table view
  @IBOutlet var tableView:UITableView?
  
  /// Offline label
  @IBOutlet var offlineLabel: UILabel!
  
  /// Online label
  @IBOutlet var onlineLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let key = UserDefaults.standard.string(forKey: "API_KEY")
  
    if key != nil && UserDefaults.standard.object(forKey: "LOCATION_ID") != nil {
    
      print("API key loaded from UserDefaults")
      
      qminderAPI.setup(apiKey: key!)

      qminderAPI.getLocationsList(completion: {result in
        switch result {
          case .failure(let error):
            print("Can't get location list \(error)")
          
          case .success(let locations):
            print(locations)
        }
      })
    
      events.setup(apiKey: key!)
//      self.events = QminderEvents(apiKey: key!)
      events.delegate = self
      events.openSocket()
      
      let locationId = UserDefaults.standard.integer(forKey: "LOCATION_ID")
      
      setEvents(locationId: locationId)
      
    } else {
      qminderAPI.getPairingCodeAndSecret(completion: {result in
      
        switch result {
          case .failure(let error):
            print("Can't get pairing code and secret \(error)")
          
          case .success(let pairingData):
            self.pairingCode.text = pairingData.code
    
            self.timer.invalidate()
        
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
              (timer) in

                self.qminderAPI.pairTV(code: pairingData.code, secret: pairingData.secret, completion: {result in

                  switch result {
                    case .failure(let error):
                      print("Can't pair TV \(error)")
                    
                    case .success(let tvData):
                  
                      if tvData.status == "PAIRED" {
                        timer.invalidate()
                      
                        UserDefaults.standard.set(tvData.apiKey, forKey: "API_KEY")
                        UserDefaults.standard.set(tvData.id, forKey: "TV_ID")
                        UserDefaults.standard.set(tvData.location, forKey: "LOCATION_ID")
                      
                        if let key = tvData.apiKey {
                          self.events.setup(apiKey: key)
                          self.events.delegate = self
                          self.events.openSocket()
                          
                          self.setEvents(locationId: tvData.location!)
                        }
                      }
                  }
                })
              
            })
        }
      })
    }
  }
  
  func setEvents(locationId:Int) {
    
    let parameters = ["location": locationId]
  
    events.subscribe(eventName: "TICKET_CREATED", parameters: parameters, callback: {(data, error) in
      if error == nil {
        self.messageReceived(event: "TICKET_CREATED", data: data!)
      }
    })
    
    events.subscribe(eventName: "TICKET_CALLED", parameters: parameters, callback: {(data, error) in
      if error == nil {
        self.messageReceived(event: "TICKET_CALLED", data: data!)
      }
    })
    
    events.subscribe(eventName: "TICKET_RECALLED", parameters: parameters, callback: {(data, error) in
      if error == nil {
        self.messageReceived(event: "TICKET_RECALLED", data: data!)
      }
    })
    
    events.subscribe(eventName: "TICKET_CANCELLED", parameters: parameters, callback: {(data, error) in
      if error == nil {
        self.messageReceived(event:"TICKET_CANCELLED", data: data!)
      }
    })
    
    events.subscribe(eventName: "TICKET_SERVED", parameters: parameters, callback: {(data, error) in
      if error == nil {
        self.messageReceived(event:"TICKET_SERVED", data: data!)
      }
    })
    
    events.subscribe(eventName: "TICKET_CHANGED", parameters: parameters, callback: {(data, error) in
      if error == nil {
        self.messageReceived(event:"TICKET_CHANGED", data: data!)
      }
    })
  }
  
  @available(tvOS 2.0, *)
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let eventInfo:EventInfo = eventsArray[indexPath.row]
    
    var cell = tableView.dequeueReusableCell(withIdentifier: eventInfo.eventName)
    
    if cell == nil {
      cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")
    }
    
    
    if let status = eventInfo.data["status"] {
      cell?.textLabel?.text = "\(eventInfo.eventName) : \(status)"
    }
    
    return cell!
  }

  
  @available(tvOS 2.0, *)
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.eventsArray.count
  }
  

  public func onTicketCreated(ticket: Ticket) {
    print(ticket)
  }
  
  public func onDisconnected(error: NSError?) {
    print("disconnected")
    
    onlineLabel.isHidden = true
    offlineLabel.isHidden = false
  }

  public func onConnected() {
    print("connected")
    
    onlineLabel.isHidden = false
    offlineLabel.isHidden = true
    
    tableView?.isHidden = false
    pairingCode.isHidden = true
  }
  
  func messageReceived(event:String, data:Dictionary<String, Any>) {
    
    guard let ticket = try? jsonDecoderWithMilliseconds.decode(Ticket.self, from: NSKeyedArchiver.archivedData(withRootObject: data)) else { return }
  
    print(ticket)
    
    self.eventsArray.insert(EventInfo(eventName: event, data: data), at: 0)
    self.tableView?.reloadData()
  }

}
