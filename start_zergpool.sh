#!/bin/sh
cpu_threads=$(grep -c '^processor' /proc/cpuinfo)
echo "Start XMRig with Parameters: -a $ALGO -o $POOL_ADDRESS -u $WALLET_USER -p $PASSWORD,id=$HOSTNAME --threads=$cpu_threads --no-color"
exec ./xmrig -a "$ALGO" -o "$POOL_ADDRESS" -u "$WALLET_USER" -p "$PASSWORD,id=$HOSTNAME" --threads="$cpu_threads" --no-color
