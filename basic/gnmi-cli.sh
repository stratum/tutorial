#!/bin/bash

docker run -it --rm \
  --network=host \
  bocon/gnmi-cli \
  --grpc-addr 127.0.0.1:50001 $@
