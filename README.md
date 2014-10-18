fffirewall-kbu
==============

Freifunk Firewall KBU generates an iptables firewall to restrict the
Freifunk-Side of your Internet router.

      | Internet Uplink
      | eth0
    +-------------+
    | Your Router |
    +-------------+
      | eth1    | eth2
      |         +-- FF-KBU-Router
      |
      +-- Your Lan

Usage
-----

make interface=eth2

You may replace eth2 with the interface on your Internet router, you
connect your FF-KBU-router to.

After this you'll find the iptables rules in iptables.txt.
