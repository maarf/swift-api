//: Playground - noun: a place where people can play

import UIKit
import Foundation

var socketRetriedConnections = 20
var timeoutMult = floor(Double(socketRetriedConnections / 10))

var newTimeout = min(5 + timeoutMult * 1, 6)

