//
//  ViewController.swift
//  QminderTVApp
//
//  Created by Kristaps Grinbergs on 27/10/2016.
//  Copyright © 2016 Qminder. All rights reserved.
//

import UIKit
import QminderTV
import SwiftyJSON

struct EventInfo {
  var eventName:String
  var json:JSON
}

class ViewController: UIViewController, QminderEventsDelegate, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet var pairingCode: UILabel!
  @IBOutlet var tableView:UITableView?
  
  var eventsArray:[EventInfo] = []
  
  private var timer = Timer()
  private var events:QminderEvents?

  override func viewDidLoad() {
    super.viewDidLoad()
    
  
    if let key = UserDefaults.standard.string(forKey: "API_KEY") {
    
      print("key loaded from UserDefaults")
    
      self.events = QminderEvents(apiKey: key)
      self.events?.delegate = self
      self.events?.openSocket()

    } else {
      QminderAPI.getPairingCodeAndSecret(completionHandler: {
        (code, secret, error) in
        
          self.pairingCode.text = code
        
          print(code)
          print(secret)
        
        
          print(error)
        
          self.timer.invalidate()
        
          self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
            (timer) in

              QminderAPI.pairTV(code: code!, secret: secret!, completionHandler: {
                (status, apiKey, error) in
                  print(status);
                
                
                  if status == "PAIRED" {
                    timer.invalidate()
                    
                    print(apiKey);
                    
                    UserDefaults.standard.set(apiKey, forKey: "API_KEY")
                    
                    if let key = apiKey {
                      self.events = QminderEvents(apiKey: key)
                      self.events?.delegate = self
                      self.events?.openSocket()
                    }
                  }
              })
            
          })
      })
    }
    
    
  }
  
  @available(tvOS 2.0, *)
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let eventInfo:EventInfo = eventsArray[indexPath.row]
    
    var cell = tableView.dequeueReusableCell(withIdentifier: eventInfo.eventName)
    
    if cell == nil {
      cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")
    }
    
    cell?.textLabel?.text = "\(eventInfo.eventName) : \(eventInfo.json["status"].stringValue)"
    
    return cell!
  }

  
  @available(tvOS 2.0, *)
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.eventsArray.count
  }
  

  public func onTicketCreated(ticket: JSON) {
    print(ticket)
  }
  
  

  public func onDisconnected(error: NSError?) {
    print("disconnected")
  }

  public func onConnected() {
    print("connected")
    
    tableView?.isHidden = false
    pairingCode.isHidden = true
    
    self.events?.subscribe(eventName: "TICKET_CREATED", parameters: ["location": "1698"], completionHandler: {
      (data:JSON?, error:NSError?) in
        if error == nil {
          self.messageReceived(event: "TICKET_CREATED", json: data!)
        }
    })
    
    self.events?.subscribe(eventName: "TICKET_CALLED", parameters: ["location": "1698"], completionHandler: {
      (data:JSON?, error:NSError?) in
        if error == nil {
          self.messageReceived(event: "TICKET_CALLED", json: data!)
        }
    })
    
    self.events?.subscribe(eventName: "TICKET_RECALLED", parameters: ["location": "1698"], completionHandler: {
      (data:JSON?, error:NSError?) in
        if error == nil {
          self.messageReceived(event: "TICKET_RECALLED", json: data!)
        }
    })
    
    self.events?.subscribe(eventName: "TICKET_CANCELLED", parameters: ["location": "1698"], completionHandler: {
      (data:JSON?, error:NSError?) in
        if error == nil {
          self.messageReceived(event:"TICKET_CANCELLED", json: data!)
        }
    })
    
    self.events?.subscribe(eventName: "TICKET_SERVED", parameters: ["location": "1698"], completionHandler: {
      (data:JSON?, error:NSError?) in
        if error == nil {
          self.messageReceived(event:"TICKET_SERVED", json: data!)
        }
    })
    
    self.events?.subscribe(eventName: "TICKET_CHANGED", parameters: ["location": "1698"], completionHandler: {
      (data:JSON?, error:NSError?) in
        if error == nil {
          self.messageReceived(event:"TICKET_CHANGED", json: data!)
        }
    })
  }
  
  func messageReceived(event:String, json:JSON) {
    print("TICKET_CHANGED")
    print(json);
    
    self.eventsArray.insert(EventInfo(eventName: event, json: json), at: 0)
    self.tableView?.reloadData()
  }

}
