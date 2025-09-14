# Home node

<!-- TOC -->
* [Home node](#home-node)
  * [NAS](#nas)
  * [Raspberry Pi](#raspberry-pi)
<!-- TOC -->

Next to peer-to-peer, setting up a home node is also a great way to improve our digital sovereignty. (If you need to search the internet for information on how to set up and maintain a home node, it is probably more effective to search for "home server" than for "home node". I would like to move away from client-server terminology as much as possible, however, so  I will refer to "nodes" rather than "servers").

## NAS

One of the possibilities is to extend the capabilities of Network Attached Storage (NAS), you know: a device that is plugged in to the home network and provides a network drive to laptops and desktops in the home.

Many of these NAS systems can run arbitrary Docker-containers nowadays. These Docker-containers can provide all kinds of services that can compete with services that can be obtained from the cloud.

As an alternative to buying a plug-and-play NAS (e.g., from Synology or QNAP), it is also possible to assemble a PC and run free, open source, Linux-based NAS software on it (e.g., [TrueNAS Scale](https://www.truenas.com/truenas-community-edition/))

Read more about setting up a [home-node using TrueNAS](truenas/README.md)

## Raspberry Pi

Another way to set up a home-server is by running it on a Raspberry Pi. The fun is that this is a very small box that can just lie around on the shelf next to the internet modem.

I found a nice [blog post](https://raspberrytips.com/raspberry-pi-server-starting-guide/) that explains how to do just that. It is on my todo list (but not at the top). 