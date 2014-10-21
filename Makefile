ifndef interface
	$(error interface is not set)
endif
iptables: getfastds
	echo iptables -i $(interface) -A INPUT   -p udp --dport 67:68 --sport 67:68 -j ACCEPT >> iptables.txt
	echo iptables -i $(interface) -A FORWARD -p udp --dport 67:68 --sport 67:68 -j ACCEPT >> iptables.txt
	echo iptables -i $(interface) -A INPUT   -p udp --dport 53 -j ACCEPT                  >> iptables.txt
	echo iptables -i $(interface) -A INPUT   -p tcp --dport 53 -j ACCEPT                  >> iptables.txt
	echo iptables -i $(interface) -A INPUT   -p tcp --dport 123 -j ACCEPT                 >> iptables.txt
	echo iptables -i $(interface) -A FORWARD -p udp --dport 53 -j ACCEPT                  >> iptables.txt
	echo iptables -i $(interface) -A FORWARD -p tcp --dport 53 -j ACCEPT                  >> iptables.txt
	echo iptables -i $(interface) -A FORWARD -p tcp --dport 123 -j ACCEPT                 >> iptables.txt
	for ip in $$(cat fastds.txt | sort | uniq);     \
	do                                              \
	    echo iptables -i $(interface) -A FORWARD --dst $$ip -j ACCEPT;  \
	    echo iptables -i $(interface) -A FORWARD --src $$ip -j ACCEPT;  \
	done                                                                          	      >> iptables.txt
	echo iptables -i $(interface) -A INPUT -j DROP                                        >> iptables.txt
	echo iptables -i $(interface) -A FORWARD -j DROP                                      >> iptables.txt
clean: 
	rm -f fastds.txt
	rm -f iptables.txt
getfastds: clean
	for i in $$(seq 1 10);                          \
	do                                              \
	   dig +short A fastd$$i.kbu.freifunk.net |     \
	       egrep "([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*)" \
	       >> fastds.txt;                           \
	done