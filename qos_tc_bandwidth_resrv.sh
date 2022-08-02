ifconfig s0-eth3 txqueuelen 1000
ifconfig s1-eth1 txqueuelen 1000

# Delete already existing Traffic Control rules
tc qdisc delete dev s0-eth3 root
tc qdisc delete dev s1-eth1 root
echo "deleting old qdiscs OK"

# Create HTB Queue Disciplines
tc qdisc add dev s0-eth3 root handle 5: htb
tc qdisc add dev s1-eth1 root handle 5: htb
echo "creating qdisc OK"

# Create class hierarchy
tc class add dev s0-eth3 parent 5: classid 5:1 htb rate 990kbit burst 10kbit ceil 990kbit
tc class add dev s0-eth3 parent 5:1 classid 5:10 htb rate 750kbit ceil 750kbit
tc class add dev s0-eth3 parent 5:1 classid 5:11 htb rate 200kbit ceil 200kbit
tc class add dev s0-eth3 parent 5:1 classid 5:12 htb rate 40kbit ceil 40kbit
tc class add dev s1-eth1 parent 5: classid 5:1 htb rate 990kbit burst 10kbit ceil 990kbit
tc class add dev s1-eth1 parent 5:1 classid 5:10 htb rate 750kbit ceil 750kbit
tc class add dev s1-eth1 parent 5:1 classid 5:11 htb rate 200kbit ceil 200kbit
tc class add dev s1-eth1 parent 5:1 classid 5:12 htb rate 40kbit ceil 40kbit
echo "creating classes OK"

# Create class hierarchy filters
tc filter add dev s0-eth3 protocol ip parent 5:0 pref 1 u32 match ip protocol 17 0xff flowid 5:10 # match udp
tc filter add dev s0-eth3 protocol ip parent 5:0 pref 1 u32 match ip protocol 6 0xff flowid 5:11 # match tcp
tc filter add dev s0-eth3 protocol ip parent 5:0 pref 2 u32 match ip protocol 0 0x00 flowid 5:12
tc filter add dev s1-eth1 protocol ip parent 5:0 pref 1 u32 match ip protocol 17 0xff flowid 5:10
tc filter add dev s1-eth1 protocol ip parent 5:0 pref 1 u32 match ip protocol 6 0xff flowid 5:11
tc filter add dev s1-eth1 protocol ip parent 5:0 pref 2 u32 match ip protocol 0 0x00 flowid 5:12
echo "creating filters OK"

# Attach basic pfifo qdisc to classes
tc qdisc add dev s0-eth3 parent 5:10 handle 10: pfifo limit 10
tc qdisc add dev s0-eth3 parent 5:11 handle 20: pfifo limit 10
tc qdisc add dev s0-eth3 parent 5:12 handle 30: pfifo limit 10
tc qdisc add dev s1-eth1 parent 5:10 handle 10: pfifo limit 10
tc qdisc add dev s1-eth1 parent 5:11 handle 20: pfifo limit 10
tc qdisc add dev s1-eth1 parent 5:12 handle 30: pfifo limit 10
echo "attaching leaf qdiscs OK"
