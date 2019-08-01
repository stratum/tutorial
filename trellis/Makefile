onos_url := http://localhost:8181/onos
onos_post := curl -sSL --user onos:rocks --noproxy localhost -X POST -H 'Content-Type:application/json'
dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

start-mn:
	docker run --privileged --rm -it \
	  -v /tmp/mn-stratum:/tmp \
          -v ${dir}topo.py:/root/topo.py \
	  -p 50001-50030:50001-50030 \
	  opennetworking/mn-stratum --mac --custom /root/topo.py --topo trellis	

start-onos:
	docker run -it --rm \
	  -e ONOS_APPS=gui,drivers.bmv2,pipelines.fabric,segmentrouting,lldpprovider,hostprovider \
	  -p 8101:8101 -p 8181:8181 \
	  onosproject/onos:2.1.0

onos-cli:
	ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -p 8101 onos@localhost

netcfg:
	${onos_post} ${onos_url}/v1/network/configuration/ -d@${dir}netcfg.json

onos-ui:
	open ${onos_url}/ui
