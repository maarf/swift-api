import Vapor
import App

let drop = try Droplet()

let qminderWebsocket = QminderWebsocketController(drop: drop)

try drop.run()
