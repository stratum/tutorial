# Stratum "Getting Started" Tutorial

This tutorial will teach you how to start a Mininet network of Stratum software switches (backed by [bmv2](https://github.com/p4lang/behavioral-model)).

The basic tutorial will show you how to use the [P4Runtime Shell](https://github.com/p4lang/p4runtime-shell) and Stratum's gNMI client to connect to a Stratum switch as well as how to connect the switch to the [ONOS controller](https://github.com/opennetworkinglab/onos).

The Trellis tutorial will show you how to start a 2x2 leaf-spine fabric topology, start ONOS with the required Trellis applicaitons, and push the configuration to get everything connected.

# Starting a Mininet topology of Stratum switches

There is a Docker container with Mininet and the Stratum BMv2 switch preinstalled: `opennetworking/mn-stratum`

We can use the following command to start the container:

```
docker run --privileged --rm -it -p 50001:50001 opennetworking/mn-stratum
```

This will start a single switch and connect two Mininet hosts to switch ports 1 and 2.

Note on the Docker flags:
- `--privileged` is required to create network namespaces and virtual interfaces
- `--rm` will remove the container upon exit
- `-it` will allocate a TTY and run the container in interactive mode
- `-p 50001:50001` will publish the Stratum switch's gRPC port to the host. By default, Mininet will allocate gRPC ports to the switches sequentially starting at 50001.

# Basic Tutorial

You can find the basic tutorial in the [`basic`](basic) directory.

# Trellis Tutorial


---------------

# Start Mininet

./start-mn.sh

# P4Runtime Shell

./p4rt-shell.sh

tables
tables["ingress.table0_control.table0"]

# Simple Bridging
te = table_entry["ingress.table0_control.table0"](action = "ingress.table0_control.set_egress_port")
# te?
te.priority = 1
te.match["standard_metadata.ingress_port"] = ("1")
te.action['port'] = ("2")
te.insert()

te.match["standard_metadata.ingress_port"] = ("2")
te.action['port'] = ("1")
te.insert()

# Read Entries
te = table_entry["ingress.table0_control.table0"]
te.read(lambda x: print(x))

# Delete all entries
te = table_entry["ingress.table0_control.table0"]
te.read(lambda x: x.delete())


# gNMI
./gnmi-cli.sh get /interfaces/interface[name=*]
./gnmi-cli.sh --poll-interval 1000 sub-poll /interfaces/interface[name=s1-eth1]/state/counters/in-unicast-pkts
./gnmi-cli.sh set /interfaces/interface[name=s1-eth1]/config/enabled --bool-val false

# Trellis Demo
docker run --privileged --rm -it -v /tmp/mn-stratum:/tmp -v $PWD/topo.py:/tmp/trellis.py -p50001-50030:50001-50030 --name mn-stratum --hostname mn-stratum opennetworking/mn-stratum --mac --custom /tmp/trellis.py --topo trellis

./start-onos.sh

./nc.sh
