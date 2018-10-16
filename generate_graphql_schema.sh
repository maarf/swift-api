#!/bin/bash

npm install -g apollo
apollo schema:download Sources/schema.json --endpoint=https://api.qminder.com/graphql --header="X-Qminder-REST-API-Key: $QMINDER_API_KEY" --header="Content-Type: application/json"
