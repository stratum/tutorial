#!/bin/bash

docker run --privileged --rm -it \
  -v /tmp/mn-stratum:/tmp \
  -p 50001-50030:50001-50030 \
  opennetworking/mn-stratum $@
