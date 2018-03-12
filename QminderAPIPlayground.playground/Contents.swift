//: Playground - noun: a place where people can play


import QminderAPI
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// Load API key from file
// Put your API key in apiKey.txt
var apiKey: String = ""
do {
  let url = Bundle.main.url(forResource: "apiKey", withExtension: "txt")
  apiKey = try String.init(contentsOf: url!).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
} catch {
  print("Can't set API key")
}

let qminderAPI = QminderAPI(apiKey: apiKey)

qminderAPI.getLocationsList {
  let result = prettyPrint("Locations list", $0)
}

qminderAPI.getLocationDetails(locationId: 9135) {
  let result = prettyPrint("Location details", $0)
}

qminderAPI.getLocationLines(locationId: 9135) {
  let result = prettyPrint("Location lines", $0)
}

qminderAPI.getLocationUsers(locationId: 9135) {
  let result = prettyPrint("Location users", $0)
}

qminderAPI.getLocationDesks(locationId: 9135) {
  let result = prettyPrint("Location desks", $0)
}

qminderAPI.getLineDetails(lineId: 64612) {
  let result = prettyPrint("Line details", $0)
}

qminderAPI.searchTickets(locationId: 9135, status: [.new], limit: 50, responseScope: ["INTERACTIONS"]) {
  let result = prettyPrint("Tickets", $0)
}

qminderAPI.getTicketDetails(ticketId: "35604156") {
  let result = prettyPrint("Ticket details", $0)
}

qminderAPI.getUserDetails(userId: 891) {
  let result = prettyPrint("User details", $0)
}

qminderAPI.getPairingCodeAndSecret {
  let result = prettyPrint("Pairing code", $0)
}

qminderAPI.pairTV(code: "XXX", secret: "YYY") {
  let result = prettyPrint("Pairing status", $0)
}

qminderAPI.tvDetails(id: 11389) {
  let result = prettyPrint("TV details", $0)
}

qminderAPI.tvEmptyState(id: 11389, language: "en") {
  let result = prettyPrint("TV empty state", $0)
}

qminderAPI.tvHeartbeat(id: 11389, metadata: ["test": "test"]) {
  let result = prettyPrint("TV heartbeat", $0)
}
