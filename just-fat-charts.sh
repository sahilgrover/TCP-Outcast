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
    n=${dir:22}
    i=[0-$((n-1))]_[0-1]_1-eth4
    python util/plot_rate.py --rx \
        --maxy $bw \
	--maxx 60 \
	--metric 'max' \
        --xlabel 'Time (s)' \
        --ylabel 'Rate (Mbps)' \
        -i $i \
        -f $dir/bwm.txt \
        -o $dir/rate.png
    python util/plot_tcpprobe.py \
        -f $dir/tcp_probe.txt \
        -o $dir/cwnd.png
done

echo "Output saved to $1"
