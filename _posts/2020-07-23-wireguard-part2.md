---
layout: post
title: 'How I tied two VPNs and two home networks together to share files. (pt. 2)'
subtitle: |
  Part 2: I don't know what I'm doing.
date: 2020-07-23 23:17:50 +0200
description: After connecting my own home network to my VPN, it was time to also connect a network of a friend.
---


After connecting my own home network to my VPN, it was time to also connect a network of a friend.
The initial idea was given so we could share files very easily, 
but I also convinced him that it was a good idea to set up a wireguard VPN for all of his devices
… And then connect that to my VPN.
So in short, he wanted the same setup that I had for myself and which I explained [in a previous post](2020-07-16_wireguard-part1.html)
but it should also be connected to my VPN, so he could access my NAS at home.

The plan was as follows:

```plaintext

 +---------+             +---------+
 | My VPN  |=============| his VPN |
 +---------+             +---------+
     ||                       ||
     ||                       ||
 +-------------+         +--------------+
 | my home net |         | his home net |
 +-------------+         +--------------+

 ```

Actually, it wasn't even necessairy for him to access my home net at all because the NAS is the entry point into my home net 
and therefore always connected to the VPN anways.
We decided that he would use a smal virtual server on his NAS as the entry point of his home net and we set up the exact same configuration that I had.

We did have some problems but nothing noteworthy happend and it all went according to plan.
The hard part was actually connecting the two networks.
The connection was done via a second wireguard interface for his server that would be the tunnel to my VPN so all the routing would happen there aswell.

To put it simple, I had to:

1. set up routing between his home-net to his VPN, which was done in his fritzbox and in the wireguard configuration for his VPN.

2. set up routing between our two VPNs, which had to be done on his server and in both wireguard configurations.

3. tell my NAS where the packets from his home network needed to go, which was into the wireguard tunnel.

3. tell my VPS where the packets from his home network needed to go.
I had to set the gateway to the IP address that his VPS had in my VPN.

<!-- end of list -->

We didn't make it in the two hours that I was at his place though, because we wanted to also go out and do something in the real world.
But on the next morning and throughout the night I thought about what caused the packets to not arrive in his network. 
All I did was check all the all the routing stuff again.
And throughout the day, I made it work, we actually had a working federated network.

He can ping my NAS with its IP in my VPN and I can now access his whole home network from my VPN.
The most amazing part was when he connected to the SMB-server running on my NAS from a computer in his home network without any addition setup on the client side.
He could even play back video but it was a bit spotty.
This was probably due to my VDSL-speed upload of 40Mbit/s but downloading the files was not a problem.

Also, what was quite funny was when I went from his house to my flat and looked at the server that was just receiving pings from his VPN.
I always find that kinda stuff very astonishing.
Packets traveling through two servers in two differnent datacenters and back to my home.
Cheers.

