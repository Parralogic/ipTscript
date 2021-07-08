iptables tutorial script.

This script is meant to be for anyone, starting to use iptables to secure their system.
In order to use this script it is advised that you don't have any set rules,
everything should be at default. Just like bellow. executing sudo iptables -L in terminal.


Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

make ipTscript.sh executable, if not already.
