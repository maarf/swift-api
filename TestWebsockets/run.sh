#!/bin/sh

echo "Building ..."
swift build

echo "Server started"
.build/debug/TestWebsockets
