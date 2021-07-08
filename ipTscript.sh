#!/bin/bash
#Creator:David Parra-Sandoval
#Date:07/06/2021
#Last modified:07/07/2021
clear

if [[ ${UID} != 0 ]]; then
echo Please run as root/sudo!
exit 1
fi

INPUT () {
echo _________________________________________________________________________________
iptables -L INPUT
echo _________________________________________________________________________________
echo
until [[ $(iptables -L INPUT | head -n 1 | cut -d " " -f 4 | cut -d ")" -f 1) = DROP ]]; do
if [[ $(iptables -L INPUT | head -n 1 | cut -d " " -f 4 | cut -d ")" -f 1) = ACCEPT ]]; then
echo -e "The current policy is [ACCEPT]\n"
echo -e "There's two types of POLICIES to use ACCEPT or DROP"
echo -e "[ACCEPT]: It is the default, will allow any connections to your system/machine/box!\n"
echo -e "[REJECT]: Will send an icmp packet back to the source IP address, that the connection is not approved/accepted!"
echo -e "REJECT is used when adding rules, as well as ACCEPT and DROP, but for [Policy] only ACCEPT and DROP!\n"
echo -e "[DROP]: Your system will appear as if it's offline/not alive; No icmp packet notification/reply to the source!\n"
echo -e "Based on my research and experience, most individuals will obviously wanna change the policy to [DROP];"
echo -e "I AGREE, work from there, to add rules on whats allowed to pass through netfilter.\n"
echo -e "The command to change the policy is: iptables -P INPUT DROP"
echo -e "Capital -P for policy or --policy then the Chain, which is INPUT, then policy type [ACCEPT or DROP] CAPITAL letters."
read -p "Try it out, input the command: " INPUTPOLICY
echo
$INPUTPOLICY
if [[ $? != 0 ]]; then
sleep 3
clear
else
echo
echo _________________________________________________________________________________
iptables -L INPUT
echo _________________________________________________________________________________
echo "Great! policy has changed: Now try pinging google.com, command ping -c 1 google.com"
echo
fi
fi
done
read -p "command: " PINGGOOGLE
$PINGGOOGLE
until [[ $ALLCHAINS = "iptables -L" ]];do
echo "Your system is not able to ping the outside world or your local network!??"
echo "WHY! is that!??...."
sleep 3
echo "Let's check your iptables configuration by executing the command iptables -L"
echo "-L for list the rules or --list"
read -p "Type the command to list all rules: " ALLCHAINS
done
echo _________________________________________________________________________________
$ALLCHAINS
echo _________________________________________________________________________________
echo "My understaning, is that your system is trying to establish a connection, but"
echo "unable to, due to the DROP in all INPUT packets. Think about it like this,"
echo "even if you where able to ping a host, it would NOT matter, because you will never get a reply back!"
echo "*ANY SERVICE TRYING TO CONNECT TO YOUR SYSTEM WILL BE IGNORED/DROPPED*"
echo "In order to get around that we need to add rules to the INPUT Chain/Table"
echo
until [[ $OUTPUTCHAIN = "iptables -L OUTPUT" ]]; do
echo "My understaning, we need to take a look at the OUTPUT Chain."
echo "To look at only the OUTPUT Chain, execute the command iptables -L OUTPUT; Don't worry will make sense! "
read -p "Type the command to only show the OUTPUT Chain: " OUTPUTCHAIN
echo _________________________________________________________________________________
$OUTPUTCHAIN
echo _________________________________________________________________________________
echo
done
until [[ $INPUTADD = "iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT" ]];do
echo -e "The policy for the OUTPUT Chain is `iptables -L OUTPUT | head -n 1 | cut -d " " -f 4 | cut -d ")" -f 1`.\n"
echo "Your system is able to send out any-type of request, but unable to, due to the fact that all INPUT"
echo -e "packets are being droped, lets change that.\n"
echo -e "Let's ADD a rule in the INPUT Chain.\n"
echo "The command to ADD a rule is -A or --append, then the Chain, now what we wanna do is ACCEPT all traffic/connections,"
echo "that your system is trying to ESTABLISH and RELATED connections. My understanding is you need to let RELATED connections"
echo "pass through because of the wide range of ports associated with a secure connection: Ex:https, even tho https works on port 443"
echo "it requires other ports to ESTABLISH a connection, three-way handshake, otherwise port 443 would become a bottleneck for the"
echo "traffic to pass through, thats why we need to only allow RELATED & ESTABLISHED connections to pass."
echo "Ex: You open a web browser and navigate to https://www.youtube.com[port443], your system is making a request, it checks dns to resolve,"
echo "then establishes a three-way handshake[now portWHOKNOWS], now all your traffic is secured; because of certificates and what not."
echo "Simple explanation, in my perception, obviously you can use wireshark...lets not digress."
echo
echo -e "iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT\n"
echo "In the above command we are leting connections pass through, because those connections will be made by your system!"
echo "My understanding is that if your system is making a request it is RELATED and is able to ESTABLISH a connection."
echo "-m means matchname, so check the [state] of packects/connections, --state means?[same shit hahaha], only ALLOW RELATED|ESTABLISHED packets/connections"
echo "-j means jump, pretty much if the packets/connection is legit then/jump ACCEPT; u can also use DROP,REJECT, but we want ACCEPT."
echo "You can use the command ss -a"
echo "ss is used to dump socket statistics. It allows showing information similar to netstat. It can display more TCP and state information than"
echo "other tools. <<SOURCE man pages"
echo
echo -e "Now input the command to ADD a rule to the INPUT Chain to ACCEPT RELATED and ESTABLISHED connections.\n"
read -p "command: " INPUTADD
done
$INPUTADD
echo
echo _________________________________________________________________________________
iptables -L
echo _________________________________________________________________________________
echo -e "Great! you have added a rule to allow any connections to your machine, made from your machine\n"
echo "now try pinging any address with the -c of 1: ping -c 1 <anyaddress>"
read -p "command: " PINGADDRESS
$PINGADDRESS
echo
echo "Nice! now we need to head over to the select menu and select the OUTPUT Chain"
read -p "Press Enter"
}



FORWARD () {
echo ""
}

OUTPUT () {
echo _________________________________________________________________________________
iptables -L
echo _________________________________________________________________________________
until [[ $OUTPUTDROP = "iptables -P OUTPUT DROP" ]];do
echo "Now, what we wanna do is change the policy of your OUTPUT Chain to DROP, now you might be asking yourself why would we wanna do that?"
echo "Especially now that we can access anything, since your OUTPUT policy is to ACCEPT, and INPUT policy is DROP, with the acception of connections made by your system."
echo -e "Because now you can control, what your system will connect to....Ex: You only want/need ssh,ftp,http,https..etc\n"
echo
echo "Type the command to change the policy of the Chain OUTPUT to DROP"
read -p "command: " OUTPUTDROP
echo
done
$OUTPUTDROP
echo
echo _________________________________________________________________________________
iptables -L
echo _________________________________________________________________________________
echo
echo "Now try pinging any address"
read -p "command: " PINGADDRESSS
$PINGADDRESSS
until [[ $UDPTRAFFICDNS = "iptables -A OUTPUT -p udp --dport 53 -j ACCEPT" ]];do
echo "You will get an error: failure in name resolution, not only that but open up a web browser and try surfing the net."
echo
echo "What we wanna do now is ADD rules to the OUTPUT Chain, to only allow certain protocols, such as dns[port 53],http[port 80],and https[port 443]"
echo "Because right now your system is unable to send packets/connections out!"
echo
echo "iptables -A OUTPUT -p udp --dport 53 -j ACCEPT"
echo
cat << EOF
The above command ADD's a rule to the OUTPUT Chain, using the -A switch, the -p for protocol, and type of protocol is udp,
--dport= Destination port 53 -j= jump/target/if the rule is legit ACCEPT.
EOF
echo -e "Add a rule to the OUTPUT Chain to allow dns traffic on udp port 53\n"
echo -e "NOTE!: We are using  --dport NOT --sport= Source-port, because we are the ones making the request. Think about it!"
read -p "command: " UDPTRAFFICDNS
done
$UDPTRAFFICDNS
until [[ $TCPTRAFFICDNS = "iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT" ]];do
echo _________________________________________________________________________________
iptables -L
echo _________________________________________________________________________________
echo "Great! rule has been added"
echo "Now add a rule to the OUTPUT Chain to allow dns in the tcp protocol."
read -p "command: " TCPTRAFFICDNS
$TCPTRAFFICDNS
done
clear
echo _________________________________________________________________________________
iptables -L
echo _________________________________________________________________________________
echo
until [[ $TCPTRAFFICHTTPS = "iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT" ]];do
echo "Now ADD a rule to the OUTPUT Chain to allow https: https uses the tcp protocol [port 443], doing so you should be able to surf the net: considering"
echo "almost all internet traffic is secured using https TLS/SSL."
echo
read -p "command: " TCPTRAFFICHTTPS
done
$TCPTRAFFICHTTPS
echo _________________________________________________________________________________
iptables -L
echo _________________________________________________________________________________
echo "Great! your system is secured, only connections related to your machine will have access traffic, only HTTPS connections!"
echo "Try pinging any address, you will be unable to. The change to your machine is only temporary until you reboot!"
read -p "Press Enter"
}

echo "Your current iptables configuration!"
echo __________________________________________________________________
iptables -L
echo __________________________________________________________________
echo ""
echo -e "Please Select Number 1 to START:\n"
echo -e "INPUT: Connections coming into your system; Ex: Someone knows your IPaddress and is trying to break into your system.\n"
echo -e "FORWARD: Connections to your system that are re-routed from your system to another; Ex: If YOU or a "Hacker" is using your system for a man in the middle attack.\n"
echo -e "OUTPUT: Connections leaving your system; Ex: You or a system program/process is making a connection to a web site/service.\n"
select CHAIN in INPUT FORWARD OUTPUT EXIT;do
case $CHAIN in
INPUT ) clear
INPUT;;

FORWARD ) echo Forward;;

OUTPUT ) clear
OUTPUT;;

EXIT ) clear;break;;
esac
done

