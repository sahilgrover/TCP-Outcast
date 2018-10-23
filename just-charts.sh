#!/bin/bash

# Exit on any failure
set -e

# Check for uninitialized variables
set -o nounset

ctrlc() {
	killall -9 python
	mn -c
	exit
}

trap ctrlc SIGINT

bw=100

for dir in $1/*; do
    echo $dir
    python util/plot_rate.py --rx \
        --maxy $bw \
        --xlabel 'Time (s)' \
        --ylabel 'Rate (Mbps)' \
        -i '(s2-eth[1-9].*)|(s1-eth1)' \
        -f $dir/bwm.txt \
        -o $dir/rate.png
    python util/plot_tcpprobe.py \
        -f $dir/tcp_probe.txt \
        -o $dir/cwnd.png
done

echo "Output saved to $1"
