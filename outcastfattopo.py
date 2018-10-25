import sys
from time import sleep, time
from multiprocessing import Process
from subprocess import Popen
import shlex
from mininet.node import RemoteController
from ripl.dctopo import FatTreeTopo
from mininet.node import CPULimitedHost
from mininet.link import TCLink
from mininet.topo import Topo
from mininet.net import Mininet
from mininet.util import custom, dumpNetConnections

def main():
    k = int(sys.argv[1])
    topo = FatTreeTopo(k=k)

    host = custom(CPULimitedHost, cpu=.5)  # 15% of system bandwidth
    link = custom(TCLink, bw=int(100), delay='.05ms',
                  max_queue_size=200)

    net = Mininet(topo=topo, host=host, link=link, controller=RemoteController,autoSetMacs=True)

    net.start()

    print "*** Dumping network connections:"
    dumpNetConnections(net)
    raw_args = shlex.split("/home/ubuntu/pox/pox.py riplpox.riplpox --topo=ft,%s --routing=random" % k)

    p = Popen(raw_args)

    print "********************************************************"
    print "*******************STARTED RIPLPOX**********************"

    #This sleep 10 is to give the riplpox controller time to start up before you start sending.  Seems to work well.
    sleep(10)


    #Here just use p.terminate() to stop the process when you are done
    net.stop()
    p.terminate()

if __name__ == '__main__':
    main()
