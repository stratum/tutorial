#!/bin/bash

#FIXME update cfg directory to path based on location of this shell script

docker run -it --rm \
  -v $PWD/cfg:/tmp/cfg \
  --network=host \
  p4lang/p4runtime-sh \
  --grpc-addr 127.0.0.1:50001 \
  --device-id 1 --election-id 0,1 \
  --config /tmp/cfg/basic_p4info.txt,/tmp/cfg/basic.json
