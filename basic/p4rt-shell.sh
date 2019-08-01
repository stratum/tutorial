#!/bin/bash

docker run -it --rm \
  -v $PWD/cfg:/tmp/cfg \
  p4lang/p4runtime-sh \
  --grpc-addr host.docker.internal:50001 \
  --device-id 1 --election-id 0,1 \
  --config /tmp/cfg/basic_p4info.txt,/tmp/cfg/basic.json
