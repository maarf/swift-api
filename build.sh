#!/bin/bash

# Run Node.JS Websockets test server
./run-node-test-app.sh

set -o pipefail && xcodebuild -workspace Example/QminderTVApp.xcworkspace -scheme QminderTVApp -destination 'platform=tvOS Simulator,name=Apple TV 1080p' CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO clean test build | xcpretty
pod lib lint --verbose

# Kill background node server
killall node