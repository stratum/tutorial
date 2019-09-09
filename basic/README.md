# Basic Demo

In this demo, you will start a Stratum switch using Mininet. Then, you will connect to the device using the P4Runtime shell and gNMI client. Optionally, you can also connect the device to ONOS.

Each command can be run from a Unix-style shell (e.g. Bash), and the only requirement is `Docker`.

## Start Mininet

By default, Mininet starts a topology with a single switch and two hosts connected to it.

![topo](single-topo.png)

To start the switch, run:

```
$ ./start-mn.sh
```

## P4Runtime Shell

The P4Runtime shell is an interactive Python CLI that will connect to a Stratum switch and can run P4Runtime commands. For example, it can be used to create, read, update, and delete flow table entries.

When the shell is started, we need to pass a P4 pipeline config, mastership arbitration election ID, and a device ID.

In this demo, we will use ONOS' `basic.p4` program, which has a single forwarding table of interest called `table0`. The mastership arbitration election ID can be an arbitraty number greater than 0; if you are running with multiple controllers, you will need to use a mechanism to gain consensus as to which controller is master; that is outside of the scope of this demo. Finally, it is possible for Stratum switches to support multiple forwarding chips (sometimes also called nodes or ASICs). The device ID is used disambiguate between different chips on the same chassis. By default on single chip switches, Stratum uses the device ID of 1.

Note: If you start multiple switches using Mininet, we run a separate instance of Stratum for each switch. Each switch switch will have it's own gRPC server running P4Runtime, and the switch has a single forwarding "chip" (instance of bmv2). To connect to different switches, you will need to vary the gRPC address, but leave the device ID set to 1. 

To start the P4Runtime shell, run the following in a separate shell:

```
$ ./p4rt-shell.sh
```

### Simple Forwarding

Before starting, let's confirm that `h1` and `h2` are not connected.

```
mininet> h1 ping h2
```

You should see the following:

```
PING 10.0.0.2 (10.0.0.2) 56(84) bytes of data.
From 10.0.0.1 icmp_seq=1 Destination Host Unreachable
From 10.0.0.1 icmp_seq=2 Destination Host Unreachable
From 10.0.0.1 icmp_seq=3 Destination Host Unreachable
```

You can leave that command running for now.

-----

In this exercise, we will create two table entries -- the first will forward traffic from port 1 to port 2, and the second will forward traffic from port 2 to port 1.

To create the first entry, you should create a table entry for `table0` with action set to `set_egress_port`.

```
P4Runtime sh >>> te = table_entry["ingress.table0_control.table0"](action = "ingress.table0_control.set_egress_port")
```

Because this is a table that supports ternary (or wildcard matching), we need to set a priority for each table entry.

```
P4Runtime sh >>> te.priority = 1
```

For this entry, we will match on `ingress_port` of `1`:

```
P4Runtime sh >>> te.match["standard_metadata.ingress_port"] = ("1")
```

Next, we will set the egress `port` to `2`:

```
P4Runtime sh >>> te.action['port'] = ("2")
```

Finally, we will insert the entry:

```
P4Runtime sh >>> te.insert()
```

At this point, traffic will be forwarded from port 1 to port 2, but no traffic will flow in the reverse direction. Next, we will install the flow table entry from port 2 to port 1:

```
P4Runtime sh >>> te = table_entry["ingress.table0_control.table0"](action = "ingress.table0_control.set_egress_port")
P4Runtime sh >>> te.priority = 1
P4Runtime sh >>> te.match["standard_metadata.ingress_port"] = ("2")
P4Runtime sh >>> te.action['port'] = ("1")
P4Runtime sh >>> te.insert()
```

At this point, all traffic that enters port 1 will be sent to port 2, and vice-versa.

-----

If you return to your Mininet shell, you should see the following:

```
From 10.0.0.1 icmp_seq=49 Destination Host Unreachable
64 bytes from 10.0.0.2: icmp_seq=50 ttl=64 time=4.36 ms
64 bytes from 10.0.0.2: icmp_seq=51 ttl=64 time=2.53 ms
64 bytes from 10.0.0.2: icmp_seq=52 ttl=64 time=2.48 ms
64 bytes from 10.0.0.2: icmp_seq=53 ttl=64 time=2.20 ms
```

### Reading Table Entries

We can read the tables entries from `table0` by constructing an empty table entry.

```
P4Runtime sh >>> te = table_entry["ingress.table0_control.table0"]
```

Then call `read()` on the table entry, which takes a lambda function that will be run for every entry. In this case, we will just print the entries to the console.

```
P4Runtime sh >>> te.read(lambda x: print(x))
```

You should see the two entries that we installed:

```
table_id: 33561568 ("ingress.table0_control.table0")
match {
  field_id: 1 ("standard_metadata.ingress_port")
  ternary {
    value: "\\x00\\x02"
    mask: "\\x01\\xff"
  }
}
action {
  action {
    action_id: 16822046 ("ingress.table0_control.set_egress_port")
    params {
      param_id: 1 ("None")
      value: "\\x00\\x01"
    }
  }
}
priority: 1

table_id: 33561568 ("ingress.table0_control.table0")
match {
  field_id: 1 ("standard_metadata.ingress_port")
  ternary {
    value: "\\x00\\x01"
    mask: "\\x01\\xff"
  }
}
action {
  action {
    action_id: 16822046 ("ingress.table0_control.set_egress_port")
    params {
      param_id: 1 ("None")
      value: "\\x00\\x02"
    }
  }
}
priority: 1
```

## gNMI

The gNMI CLI is a Python CLI that enables you to make gNMI call to a Stratum device. Each call is 

To list all interfaces on the device, run the following in a new shell:

```
$ ./gnmi-cli.sh get /interfaces/interface[name=*]
```

You should see this response:

```
***************************
RESPONSE
notification {
  timestamp: 1564837983509707400
  update {
    path {
      elem {
        name: "interfaces"
      }
      elem {
        name: "interface"
        key {
          key: "name"
          value: "s1-eth1"
        }
      }
      elem {
        name: "state"
      }
      elem {
        name: "ifindex"
      }
    }
    val {
      uint_val: 1
    }
  }
}
notification {
  timestamp: 1564837983509785700
  update {
    path {
      elem {
        name: "interfaces"
      }
      elem {
        name: "interface"
        key {
          key: "name"
          value: "s1-eth2"
        }
      }
      elem {
        name: "state"
      }
      elem {
        name: "ifindex"
      }
    }
    val {
      uint_val: 2
    }
  }
}

***************************
```

You can see there are two interfaces, and the names and port numbers match the topology above.

-----

Next, we can read the ingress unicast packet counters:

```
$ ./gnmi-cli.sh --interval 1000 sub-sample /interfaces/interface[name=s1-eth1]/state/counters/in-unicast-pkts
```

This command will print the number of packets received on port 1 every second. Here is an example of one response:
```
***************************
RESPONSE
update {
  timestamp: 1564838158894794047
  update {
    path {
      elem {
        name: "interfaces"
      }
      elem {
        name: "interface"
        key {
          key: "name"
          value: "s1-eth1"
        }
      }
      elem {
        name: "state"
      }
      elem {
        name: "counters"
      }
      elem {
        name: "in-unicast-pkts"
      }
    }
    val {
      uint_val: 585
    }
  }
}

***************************
```

You should see the `uint_val` increase by 1 every second if your ping is still running.

-----

Finally, we can demonstrate gNMI set and on-change subscriptions.

Start a subscription for the operational status of port 1:

```
$ ./gnmi-cli.sh sub-onchange /interfaces/interface[name=s1-eth1]/state/oper-status
```

You should see the following response which indicates that port 1 is `UP`:

```
***************************
RESPONSE
update {
  timestamp: 1564838391969398300
  update {
    path {
      elem {
        name: "interfaces"
      }
      elem {
        name: "interface"
        key {
          key: "name"
          value: "s1-eth1"
        }
      }
      elem {
        name: "state"
      }
      elem {
        name: "oper-status"
      }
    }
    val {
      string_val: "UP"
    }
  }
}

***************************
```

Leave this shell open as any updates will be printed here.

In another shell (ideally one that leaves the subscription shell visible), we will run a command to disable port 1:

```
$ ./gnmi-cli.sh set /interfaces/interface[name=s1-eth1]/config/enabled --bool-val false
```

In the subscription shell, you should see:

```
***************************
RESPONSE
update {
  timestamp: 1564838642886678182
  update {
    path {
      elem {
        name: "interfaces"
      }
      elem {
        name: "interface"
        key {
          key: "name"
          value: "s1-eth1"
        }
      }
      elem {
        name: "state"
      }
      elem {
        name: "oper-status"
      }
    }
    val {
      string_val: "DOWN"
    }
  }
}

***************************
```

You should also see the ping stop in the Mininet shell.

In the set shell, you can renable port 1:

```
$ ./gnmi-cli.sh set /interfaces/interface[name=s1-eth1]/config/enabled --bool-val true
```

You should see that the port is back `UP` in the subscribe shell and the ping should resume in the Mininet shell.

## Running ONOS

You can start ONOS to look at the topology using the ONOS UI:

```
$ ./start-onos.sh
```

ONOS will run in the foreground of this shell and will print its log.

### Pushing the `netcfg` file to ONOS

Once you see ONOS' log has quieted down (logging slows), you will push information about the network topology to ONOS. 

In a separate shell, run:

```
$ ./netcfg.sh
```

### Opening the UI

To open the ONOS UI, visit [http://localhost:8181/onos/ui](http://localhost:8181/onos/ui) in your web browser (Google Chrome or Chromium preferred).

ONOS is running with a reactive forwarding application, so you should be able to ping between hosts.
