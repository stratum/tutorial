#!/bin/bash

#FIXME update netcfg file to path based on location of this shell script

curl -sSL --user onos:rocks --noproxy localhost -X POST -H 'Content-Type:application/json' http://localhost:8181/onos/v1/network/configuration/ -d@netcfg-3switch.json
