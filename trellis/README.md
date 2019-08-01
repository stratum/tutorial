# Trellis Demo
docker run --privileged --rm -it -v /tmp/mn-stratum:/tmp -v $PWD/topo.py:/tmp/trellis.py -p50001-50030:50001-50030 --name mn-stratum --hostname mn-stratum opennetworking/mn-stratum --mac --custom /tmp/trellis.py --topo trellis

./start-onos.sh

./nc.sh
