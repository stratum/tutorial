#!/bin/bash

docker run -it --rm trtc008056/gnmi-tool /gnmi-cli \
  --grpc-addr host.docker.internal:50001 $@
