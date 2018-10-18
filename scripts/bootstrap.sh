#!/bin/sh

#!/bin/bash

carthage update --no-build

rm "Carthage/Checkouts/SQLite.swift/SQLite.xcodeproj/xcshareddata/xcschemes/SQLite Mac.xcscheme"
rm "Carthage/Checkouts/SQLite.swift/SQLite.xcodeproj/xcshareddata/xcschemes/SQLite tvOS.xcscheme"
rm "Carthage/Checkouts/SQLite.swift/SQLite.xcodeproj/xcshareddata/xcschemes/SQLite iOS.xcscheme"
rm "Carthage/Checkouts/SQLite.swift/SQLite.xcodeproj/xcshareddata/xcschemes/SQLite watchOS.xcscheme"

rm "Carthage/Checkouts/apollo-ios/ApolloSQLite.xcodeproj/xcshareddata/xcschemes/ApolloSQLite.xcscheme"
rm "Carthage/Checkouts/apollo-ios/ApolloWebSocket.xcodeproj/xcshareddata/xcschemes/ApolloWebSocket.xcscheme"
rm "Carthage/Checkouts/apollo-ios/Apollo.xcodeproj/xcshareddata/xcschemes/ApolloPerformanceTests.xcscheme"

carthage build

cp Cartfile.resolved Carthage
