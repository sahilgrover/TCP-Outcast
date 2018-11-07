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

start=`date`
exptid=`date +%b%d-%H:%M`
rootdir=outcast-$exptid
bw=100

# Note: you need to make sure you report the results
# for the correct port!
# In this example, we are assuming that each
# client is connected to port 2 on its switch.

routing="hashed";
while getopts r: o
do case "$o" in 
	r)   routing="$OPTARG";;
	esac
done

for n in 4; do
    dir=$rootdir/n$n
    python outcastfattopo.py --bw $bw \
        --dir $dir \
        -t 60 \
        -n $n \
	--routing $routing
    #i=[0-${n-1}]_[0-1]_[0-1]-eth[1-2].
    #i=[0-${n-1}]_[0-1]_[0-1]-eth2
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

echo "Started at" $start
echo "Ended at" `date`
echo "Output saved to $rootdir"
