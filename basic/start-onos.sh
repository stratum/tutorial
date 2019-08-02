#!/bin/bash

docker run -it --rm \
  -e ONOS_APPS=gui2,drivers.bmv2,pipelines.basic,lldpprovider,hostprovider,fwd \
  -p 8101:8101 -p 8181:8181 \
  onosproject/onos:2.1.0