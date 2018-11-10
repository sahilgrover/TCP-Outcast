### For the Linear topology

1.  Create an instance using this template to get the configuration desired
_Note: newer versions of Mininet have changed the queue drop mechanism away from tail drop.  This experiment will NOT work with these_
2. Clone the repository at https://github.com/sahilgrover/TCP-Outcast
3. As root, run `./outcast-sweep.sh`.  This should take about 5 minutes to do runs for n=2, 6, and 12 based on the topology described above.

### For the FatTree topology:

1. Create an instance using this template to get the configuration desired.
2. The project requires RipL and POX to run.  Clone the repository at https://github.com/brandonheller/riplpox and follow the setup instructions in INSTALL.
3. Clone the repository at https://github.com/sahilgrover/TCP-Outcast
4. Disable MPTCP and DCTCP if your machine supports it:
`sysctl -w net.ipv4.tcp_dctcp_enable=0`
`sysctl -w net.ipv4.tcp_ecn=0`
5. As root, run `./fattree-sweep.sh`.  This should take about 5 minutes to do a run for a Fat Tree topology of k=4
6. To use spanning tree as the routing algorithm, run `./fattree-sweep.sh -r st`
_In case you get stuck on ‘0_0_2 waiting to listen to port 5001’ just restart the experiment as this is pox+mininet+ripl strange state land_