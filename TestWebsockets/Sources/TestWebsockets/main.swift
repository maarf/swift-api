import WebSocket

let group = MultiThreadedEventLoopGroup(numberOfThreads: 8)

let ws = HTTPServer.webSocketUpgrader(shouldUpgrade: { req in
  [:]
}, onUpgrade: { ws, req in
  let qminderTester = QminderEventsTester(ws: ws)
  ws.onText { ws, string in
    qminderTester.parseInput(string)
  }
})

struct WebsocketResponder: HTTPServerResponder {
  func respond(to request: HTTPRequest, on worker: Worker) -> EventLoopFuture<HTTPResponse> {
    let res = HTTPResponse(status: .ok, body: "This is a Qminder Test WebSocket server")
    return worker.eventLoop.newSucceededFuture(result: res)
  }
}

let server = try HTTPServer.start(
  hostname: "127.0.0.1",
  port: 8889,
  responder: WebsocketResponder(),
  upgraders: [ws],
  on: group
) { error in
  print("error")
}.wait()

try server.onClose.wait()
