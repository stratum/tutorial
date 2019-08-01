#!/bin/bash

curl -sSL --user onos:rocks --noproxy localhost -X POST -H 'Content-Type:application/json' http://localhost:8181/onos/v1/network/configuration/ -d@netcfg.json
