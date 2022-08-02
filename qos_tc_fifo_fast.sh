ifconfig s0-eth3 txqueuelen 10
ifconfig s1-eth1 txqueuelen 10

# Delete already existing Traffic Control rules
tc qdisc delete dev s0-eth3 root
tc qdisc delete dev s1-eth1 root
echo "deleting old qdiscs OK"

# Create HTB Queue Disciplines
tc qdisc add dev s0-eth3 root handle 5: htb default 1
tc qdisc add dev s1-eth1 root handle 5: htb default 1
echo "creating qdisc OK"

# Create basic leaf classes
tc class add dev s0-eth3 parent 5: classid 5:1 htb rate 990kbit ceil 990kbit
tc class add dev s1-eth1 parent 5: classid 5:1 htb rate 990kbit ceil 990kbit
echo "creating classes OK"

# Attach basic pfifo qdisc to classes
tc qdisc add dev s0-eth3 parent 5:1 handle 10: pfifo_fast
tc qdisc add dev s1-eth1 parent 5:1 handle 10: pfifo_fast
echo "attaching leaf qdiscs OK"

