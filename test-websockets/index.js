var http = require("http");
var url = require("url");
var ws = require('ws');
var async = require('async');

var WebSocketServer = require('ws').Server;
var wss = new WebSocketServer({ port: 8889 });

wss.on('connection', function (ws) {
  console.log("\nConnection opened");
  console.log(ws.upgradeReq.headers);

  var events = [];
  let neededEvents = ["TICKET_CREATED", "TICKET_CALLED", "TICKET_RECALLED", "TICKET_CANCELLED", "TICKET_SERVED", "TICKET_CHANGED"];

  var subscriptions = [];

  let timeoutInterval = 3000;

  ws.on('message', function (data) {

    //Show the message object in the console
    var message = JSON.parse(data);
    console.log("\nWS Message received from client:");
    console.log(message);

    // Reply to subsription
    ws.send("");

    if (message.subscribe) {
      events.push(message.subscribe);
      subscriptions[message.subscribe] = message.id;

      // If app subscribed to all events, start running tests
      if (events.sort().join("") == neededEvents.sort().join("")) {
        console.log("Start test");

        async.waterfall([
          // Ticket created
          function(callback) {
            setTimeout(function(){

              var ticket = {
                "subscriptionId": subscriptions["TICKET_CREATED"],
                "messageId" : 1,
                "data" : {
                  "status" : "NEW",
                  "source" : "MANUAL",
                  "firstName" : "Name",
                  "id" : "23853943",
                  "created" : {
                    "date" : "2017-02-06T12:35:29Z"
                  },
                  "line" : 62633,
                  "lastName" : "Surname"
                }
              };

              console.log("TICKET_CREATED");

              ws.send(JSON.stringify(ticket));

              callback(null, ws);
            }, timeoutInterval);
          },

          // Ticket changed
          function(ws, callback) {
            setTimeout(function(){
              var ticket = {
                "subscriptionId" : subscriptions["TICKET_CHANGED"],
                "messageId" : 2,
                "data" : {
                  "status" : "NEW",
                  "source" : "MANUAL",
                  "firstName" : "Name2",
                  "id" : "23853943",
                  "created" : {
                    "date" : "2017-02-06T12:35:29Z"
                  },
                  "line" : 62633,
                  "lastName" : "Surname2"
                }
              };

              console.log("TICKET_CHANGED");

              ws.send(JSON.stringify(ticket));

              callback(null, ws);
            }, timeoutInterval);
          },

          // TIcket removed
          function(ws, callback) {
            setTimeout(function(){
              var ticket = {
                "subscriptionId" : subscriptions["TICKET_CANCELLED"],
                "messageId" : 3,
                "data" : {
                  "status" : "CANCELLED_BY_CLERK",
                  "source" : "MANUAL",
                  "firstName" : "Name2",
                  "id" : "23853943",
                  "created" : {
                    "date" : "2017-02-06T12:35:29Z"
                  },
                  "line" : 62633,
                  "lastName" : "Surname2"
                }
              };

              console.log("TICKET_CANCELLED");

              ws.send(JSON.stringify(ticket));

              callback(null, ws);
            }, timeoutInterval);
          },

          // Ticket created
          function(ws, callback) {
            setTimeout(function(){
              var ticket = {
                "subscriptionId" : subscriptions["TICKET_CREATED"],
                "messageId" : 4,
                "data" : {
                  "status" : "NEW",
                  "source" : "MANUAL",
                  "firstName" : "Name1",
                  "id" : "23856820",
                  "created" : {
                    "date" : "2017-02-06T13:35:31Z"
                  },
                  "line" : 62633,
                  "lastName" : "Surname1"
                }
              };

              console.log("TICKET_CREATED");

              ws.send(JSON.stringify(ticket));

              callback(null, ws);
            }, timeoutInterval);
          },

          // Ticket changed
          function(ws, callback) {
            setTimeout(function(){
              var ticket = {
                "subscriptionId" : subscriptions["TICKET_CHANGED"],
                "messageId" : 5,
                "data" : {
                  "status" : "NEW",
                  "source" : "MANUAL",
                  "firstName" : "Name",
                  "id" : "23856820",
                  "created" : {
                    "date" : "2017-02-06T13:35:31Z"
                  },
                  "line" : 62633,
                  "lastName" : "Surname"
                }
              };

              console.log("TICKET_CHANGED");

              ws.send(JSON.stringify(ticket));

              callback(null, ws);
            }, timeoutInterval);
          },

          // Ticket called
          function(ws, callback) {
            setTimeout(function(){
              var ticket = {
                "subscriptionId" : subscriptions["TICKET_CALLED"],
                "messageId" : 7,
                "data" : {
                  "status" : "CALLED",
                  "source" : "MANUAL",
                  "firstName" : "Name",
                  "id" : "23856820",
                  "called" : {
                    "date" : "2017-02-06T13:36:11Z",
                    "caller" : 891
                  },
                  "created" : {
                    "date" : "2017-02-06T13:35:31Z"
                  },
                  "line" : 62633,
                  "lastName" : "Surname"
                }
              };

              console.log("TICKET_CALLED");

              ws.send(JSON.stringify(ticket));

              callback(null, ws);
            }, timeoutInterval);
          },

          // Ticket recalled
          function(ws, callback) {
            setTimeout(function(){
              var ticket = {
                "subscriptionId" : subscriptions["TICKET_RECALLED"],
                "messageId" : 8,
                "data" : {
                  "status" : "CALLED",
                  "source" : "MANUAL",
                  "firstName" : "Name",
                  "id" : "23856820",
                  "called" : {
                    "date" : "2017-02-06T13:36:21Z",
                    "caller" : 891
                  },
                  "created" : {
                    "date" : "2017-02-06T13:35:31Z"
                  },
                  "line" : 62633,
                  "lastName" : "Surname"
                }
              };

              console.log("TICKET_RECALLED");

              ws.send(JSON.stringify(ticket));

              callback(null, ws);
            }, timeoutInterval);
          },

          // Ticket served
          function(ws, callback) {
            setTimeout(function(){
              var ticket = {
                "subscriptionId" : subscriptions["TICKET_SERVED"],
                "messageId" : 9,
                "data" : {
                  "status" : "SERVED",
                  "source" : "MANUAL",
                  "firstName" : "Name",
                  "id" : "23856820",
                  "called" : {
                    "date" : "2017-02-06T13:36:21Z",
                    "caller" : 891
                  },
                  "served" : {
                    "date" : "2017-02-06T13:36:36Z"
                  },
                  "created" : {
                    "date" : "2017-02-06T13:35:31Z"
                  },
                  "line" : 62633,
                  "lastName" : "Surname"
                }
              };

              console.log("TICKET_SERVED");

              ws.send(JSON.stringify(ticket));

              callback(null);
            }, timeoutInterval);
          }
        ],
        function(err, results) {
          // end test and clear all events and subscriptions
          events = [];
          subscriptions = [];
        });
      }
    }
  });
});
