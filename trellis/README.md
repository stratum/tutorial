# Trellis Demo

All of the commands for this exercise are located in the `Makefile`. Each command can be run from a Unix-style shell (e.g. Bash), and the only requirements are `make` and `Docker`.

## Starting the Mininet topology

The Trellis topology is defined in `topo.py`. It consists of 4 switches -- 2 leaves and 2 spines. Each leaf has two hosts attached to it.

You can start the topology by running:

```
make start-mn
```

## Starting ONOS

Next, you will need to start ONOS.

In a separate shell, run:

```
make start-onos
```

This will start ONOS with the required applications for Trellis. ONOS will run in the foreground of this shell and will print its log.

## Pushing the `netcfg` file to ONOS

Once you see ONOS' log has quieted down (logging slows), you will push information about the network topology to ONOS. This information is contained in `netcfg.json`.

In a third shell, run:

```
netcfg
```

Now, Stratum, Trellis, and ONOS should be properly configured.

## Exploring the ONOS UI and CLI

To open the ONOS UI, visit [http://localhost:8181/onos/ui](http://localhost:8181/onos/ui) or run the following in the third shell:

```
make onos-ui
```

For both the UI and CLI, the username is `onos` and the password is `rocks`

To run the ONOS CLI, run the following in the third shell:

```
make onos-cli
```
