#!/bin/bash

set -o pipefail && xcodebuild -workspace Example/QminderTVApp.xcworkspace -scheme QminderTVApp -destination 'platform=tvOS Simulator,name=Apple TV 1080p' CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO clean test build | xcpretty
pod lib lint --verbose