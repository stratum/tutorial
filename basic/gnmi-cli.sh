#!/bin/bash

docker run -it --rm bocon/gnmi-cli \
  --grpc-addr host.docker.internal:50001 $@
