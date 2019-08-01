start-mn:	
	docker run --privileged --rm -it \
	  -v /tmp/mn-stratum:/tmp \
	  -p 50001-50030:50001-50030 \
	  opennetworking/mn-stratum
	
p4rt-shell:
	docker run -it --rm \
	  -v $PWD/cfg:/tmp/cfg \
	  p4lang/p4runtime-sh \
	  --grpc-addr host.docker.internal:50001 \
	  --device-id 1 --election-id 0,1 \
	  --config /tmp/cfg/basic_p4info.txt,/tmp/cfg/basic.json

gnmi-cli:
	docker run -it --rm trtc008056/gnmi-tool /gnmi-cli \
	  --grpc-addr host.docker.internal:50001 $@
	
