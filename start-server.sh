#!/bin/bash

cd test-server
vapor build --verbose
vapor run &
