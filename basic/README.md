# Basic Demo

## Start Mininet

./start-mn.sh

## P4Runtime Shell

./p4rt-shell.sh

tables
tables["ingress.table0_control.table0"]

### Simple Bridging
te = table_entry["ingress.table0_control.table0"](action = "ingress.table0_control.set_egress_port")
# te?
te.priority = 1
te.match["standard_metadata.ingress_port"] = ("1")
te.action['port'] = ("2")
te.insert()

te.match["standard_metadata.ingress_port"] = ("2")
te.action['port'] = ("1")
te.insert()

### Read Entries
te = table_entry["ingress.table0_control.table0"]
te.read(lambda x: print(x))

### Delete all entries
te = table_entry["ingress.table0_control.table0"]
te.read(lambda x: x.delete())


## gNMI
./gnmi-cli.sh get /interfaces/interface[name=*]
./gnmi-cli.sh --poll-interval 1000 sub-poll /interfaces/interface[name=s1-eth1]/state/counters/in-unicast-pkts
./gnmi-cli.sh set /interfaces/interface[name=s1-eth1]/config/enabled --bool-val false


## Running ONOS