ifndef interface
	$(error interface is not set)
endif
iptables: getpeers
	echo iptables -A INPUT   -i $(interface) -p udp --dport 67:68 --sport 67:68 -j ACCEPT >> iptables.txt
	echo iptables -A FORWARD -i $(interface) -p udp --dport 67:68 --sport 67:68 -j ACCEPT >> iptables.txt
	echo iptables -A INPUT   -i $(interface) -p udp --dport 53 -j ACCEPT                  >> iptables.txt
	echo iptables -A INPUT   -i $(interface) -p tcp --dport 53 -j ACCEPT                  >> iptables.txt
	echo iptables -A INPUT   -i $(interface) -p tcp --dport 123 -j ACCEPT                 >> iptables.txt
	echo iptables -A FORWARD -i $(interface) -p udp --dport 53 -j ACCEPT                  >> iptables.txt
	echo iptables -A FORWARD -i $(interface) -p tcp --dport 53 -j ACCEPT                  >> iptables.txt
	echo iptables -A FORWARD -i $(interface) -p tcp --dport 123 -j ACCEPT                 >> iptables.txt
	for ip in $$(cat peers.txt | sort | uniq);                          \
	do                                                                  \
	    echo iptables -A FORWARD -i $(interface) --dst $$ip -j ACCEPT;  \
	    echo iptables -A FORWARD -i $(interface) --src $$ip -j ACCEPT;  \
	done                                                                          	      >> iptables.txt
	echo iptables -A INPUT   -i $(interface) -j DROP                                      >> iptables.txt
	echo iptables -A FORWARD -i $(interface) -j DROP                                      >> iptables.txt
clean: 
	rm -f peers.txt
	rm -f iptables.txt
getpeers: clean
	for i in $$(seq 1 8);                           \
	do                                              \
	   dig +short A fastd$$i.kbu.freifunk.net |     \
	       egrep "([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*)" \
               >> peers.txt;				\
	done
	# for i in $$(seq 1 9);                           \
	# do						\
	#    dig +short A vpn$$i.kbu.freifunk.net |       \
        #        egrep "([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*)" \
        #        >> peers.txt;				\
	# done
