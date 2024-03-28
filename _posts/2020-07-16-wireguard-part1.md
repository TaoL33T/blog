---
layout: post
title: 'How I tied two VPNs and two home networks together to share files.'
subtitle: 'Part 1: Just two Networks at first'
date: 2020-07-17 00:00:00 +0200
description: So, have you ever heard of wireguard? The VPN that everyone speaks of and that is rising fast because it is very fast and has very low latency. Essentially, it's not even a VPN. All it is, is a very efficient and encrypted tunnel between two computers. It allows you to create a virtual network between any number of devices.
---


So, have you ever heard of wireguard?
The VPN that everyone speaks of and that is rising fast because it is very fast and has very low latency.
Essentially, it's not even a VPN.
All it is, is a very efficient and encrypted tunnel between two computers.
It allows you to create a virtual network between any number of devices.

Between your server and your smartphone, your server and your laptop, your server and your NAS, your NAS and your laptop …
Your imagination is your limit.

It really is.
I have always been interested in networks and routing.
And after trying out wireguard as a way to connect to my home network when I'm somewhere else, I decided that I'd get a VPS and start poking around more with it.
At this point, I only knew how to forward traffic to the local network and on one VPN that only consisted of my NAS at home.
But I was planning to take this to the next level.

I planned to have my NAS at home to still be my NAS.
It was cheap to run, had my file server on it and I wanted fast connections from the local network, but I wanted it to also be accessible from within the VPN.
My VPS should be the gateway to the rest of the internet.
I wanted to use it as a cheap VPN that later would also become the server behind this website right here.

Also, although not the main purpose of the VPN, I was thinking about using it as a way to get IPv6 connectivity to all the devices inside my VPN, because my ISP at home wouldn't provide any.

# Planning

The plan was as follows:

1. Just set up a wireguard VPN between my VPS and NAS so that I could access the files on the NAS from my server.

2. Connect more peers to the VPN.
My smartphone and laptop would profit from this the most.

3. Connect my home network to the VPN.

This was probably the hardest part as it required knowledge of actual routing and setting put static routes in the FritzBox that I was using.

4. Public IPv6 Addresses for all the devices inside my VPS.
This wasn't required but I wanted to try it out anyways just to see.

<!-- end of list -->

So, with all of the ideas complete, I started working on this project:

## 1. Tunnel between VPS and NAS.

This wasn't very hard.
I knew how to build a wireguard tunnel at this point.
See [this excellent tutorial by Stravros](https://www.stavros.io/posts/how-to-configure-wireguard/) for more detailed instructions on how to set up wireguard between two devices.
This tutorial also covers how to send all internet traffic over to another computer.
Aka, what everyone thinks a VPN is, even though it is so much more.

# 2. More peers

I wanted a VPN that I could connect my smartphone and laptop to and that also allowed me to talk home.
But with more internet speed than my internet connection at home has, because that only has 40Mbit/s of upload which then would become the maximum download speed I'd get anywhere when connected to my VPN.

Anyway, this is covered in the next part in more detail.
Adding peers to wireguard networks is also quite easy if you went through the process of wrapping your head around it once.

## 3. Federation between the networks.

What I wanted was a simple way of connecting my fritz network at home to my VPN in a way to would allow me the following:

- Talk to devices inside the VPN from within my home network.
- Talk to devices in my home network from within my VPN.

<!-- end of list -->

So I somehow had to route between the two. 
From setting up the wireguard endpoint at my home network, I learned that I had to turn on forwarding on a device that was connected to my home network and my VPN.
In my case this was my NAS.

My NAS, in fact, would become the *gateway* between those two networks.
On the NAS, the configuration was similar to the one I had done when it was still the endpoint.
Except now, the NAS was connecting to my VPS from behind the network access translation.
And now, I had to set up a routing rule that would route between the home network and my NAS.

With the `ip` utility of Linux, this was quite trivial:

```bash
ip route add 192.168.199.0/24 via 192.168.199.1 dev wg0
```
This would tell the operating system that all traffic it receives within this address range should be routed to the IP that my VPS has inside the VPN network on the first wireguard interface.
However, because you would add the address range of the VPN network to the `AllowedIPs`-section in the wireguard config anyways, you'd have to just change the route it added to represent what you wanted:

```bash
ip route change 192.168.199.0/24 via 192.168.199.1 dev wg0
```

Additionally, I had to do the same on my fritzbox.
It doesn't have the IP command though, but the configuration is similar.
An `ip`-command that would do the same, would look like this:

```bash
ip route add 192.168.199.0/24 via 192.168.188.21
```
This just tells the fritzbox to send all traffic on `192.168.199.0/24` that it gets to the IP of the NAS inside the home network, because the NAS knows what to do with it:
forward it to the wireguard interface.

This part was also done: I had a working federation between my networks.
My NAS was accessible from anywhere inside the VPN and as a bonus, I could enter my home network via the NAS as well.
This way, my laptop could connect to the IP my NAS has inside the home network no matter where my laptop was.
And I would also get the native speed when I was at home and my upload when I was somewhere else.

If I was just connecting to my NAS via the IP it has inside the VPN, all traffic would get sent over to my VPS and then back to my NAS again. 
So the maximum download speed from my NAS would equal my maximum upload speed when I was home as well and would also get in the way of other traffic.

Very complicated solution, I know.
But it works™!

## 4. IPv6

In addition to the private IPv4-Addresses my VPN-clients would get, I would just select one address range of the quadzillion addresses that I got with the `/64`-prefix of my hosting provider that I would then dedicate to my VPN-Network.
I selected one single IPv6 for every client.
The prefix I selected was `/72` and so I could base my iptables rules around that.

But there was a major security problem:
Because the VPS knew where to put the traffic to these IPv6-addresses through the wireguard configuration, they were completely exposed on the internet.
Like a full-blown IPv4-address without NAT.

Protecting them from being exposed wasn't very complicated though.
I just had to learn iptables.
Well, I'm massively underexaggerating right now, but I had already played around with iptables at this point.

The issue  was solved with these two ip6tables commands:

```bash
ip6tables -A FORWARD -d <ipv6-address-range of vpn network> -m state --state RELATED,ESTABLISHED -j ACCEPT
ip6tables -A FORWARD -d <ipv6-address-range of vpn network> -i eth0 -j REJECT --reject-with icmp6-port-unreachable
```

Now, all the communication coming in is rejected with the icmp port unreachable when the connection wasn't opened by one of the clients (`RELATED,ESTABLISHED`).

Allowing ICMP-v6 traffic is generally considered to be a good idea though, so I added a rule to allow all of that and also, I wanted to be able to talk to all of the clients unrestricted inside the VPN so I added another rule for that:

```bash
-A FORWARD -s <ipv6-address-range of vpn network> -i wg0 -j ACCEPT
-A FORWARD -p icmp -j ACCEPT
```

These have to be added before the `REJECT`-statement though because iptables checks these conditions in order.

# Conclusion

Overall, I am very pleased with this project.
I learned **a lot** about networking, a topic that I find very interesting and I learned the basics of routing.
I am at a point where I would say that I understood how routing works which was always very mysterious to me.
This project though gave me the opportunity to play around with it and gain something from it.

The general approach I have at stuff like this is more like: "I'll just play with it and if it works, I might gain something from it and if it doesn't, I will most certainly have learned something".
And this is a very good example of this idea going well.

In short, I now have a VPN that ties my home network and portable devices together in a way that wouldn't have been possible with something like OpenVPN.
Especially, because the overhead of wireguard is so low that you would never notice that you are in fact behind a VPN. My VPS is now a router and a firewall at the same time and I learned how to build it from scratch with basically almost kernel-level tools of the Linux kernel.

For the next part, I took this to the next level and implemented a similar setup for a friend. You may [subscribe to my RSS-feed](/rss.xml) if 'ya don't wanna miss that!
