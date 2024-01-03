#!/bin/sh
cpu_threads=$(grep -c '^processor' /proc/cpuinfo)
echo "Start XMRig with Parameters: -a $ALGO -o $POOL_ADDRESS -u LTC:$WALLET_USER.$HOSTNAME#Jumper -p $PASSWORD --threads=$cpu_threads"
#./xmrig -a rx -o stratum+ssl://rx.unmineable.com:443 -u LTC:LNec6RpZxX6Q1EJYkKjUPBTohM7Ux6uMUy.HOSTNAME#Jumper -p x --threads=4
./xmrig -a $ALGO -o $POOL_ADDRESS -u LTC:$WALLET_USER.$HOSTNAME#Jumper -p $PASSWORD --threads=$cpu_threads
