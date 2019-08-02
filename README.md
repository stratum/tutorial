# Stratum "Getting Started" Tutorial

This tutorial will teach you how to start a [Mininet](https://github.com/mininet/mininet) network of Stratum software switches (backed by [bmv2](https://github.com/p4lang/behavioral-model)).

The basic tutorial will show you how to use the [P4Runtime shell](https://github.com/p4lang/p4runtime-shell) and Stratum's gNMI client to connect to a Stratum switch as well as how to connect the switch to the [ONOS controller](https://github.com/opennetworkinglab/onos).

The Trellis tutorial will show you how to start a 2x2 leaf-spine fabric topology, start ONOS with the required Trellis applicaitons, and push the configuration to get everything connected.

## Starting a Mininet topology of Stratum switches

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

You can also pass standard Mininet arguments. For example to start a 3 switch linear topology, append: `--topo linear,3`

To see a full list of Mininet arguments by appending `-h` to the Docker command.

## Basic Tutorial

You can find the basic tutorial in the [`basic`](basic) directory.

## Trellis Tutorial

You can find the Trellis tutorial in the [`trellis`](trellis) directory.
