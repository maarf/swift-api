//: Playground - noun: a place where people can play

import QminderAPI
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let qminderAPI = QminderAPI(apiKey: "API_KEY")

qminderAPI.getLocationsList {
  prettyPrint("Locations list", $0)
}

qminderAPI.getLocationDetails(locationId: 9135) {
  prettyPrint("Location details", $0)
}

qminderAPI.getLocationLines(locationId: 9135) {
  prettyPrint("Location lines", $0)
}

qminderAPI.getLineDetails(lineId: 64612) {
  prettyPrint("Line details", $0)
}

