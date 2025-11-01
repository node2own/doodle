# Vision for moving beyond the world-wide web

## The world-wide web

The world-wide web was succesful because of the possibilities offered by two clusters of technologies:

* TCP/IP and DNS
* URL, HTML, and HTTP

### TCP/IP and DNS

Transmission Control Protocol / Internet Protocol (TCP/IP) was developed by the Defense Advanced Research Projects Agency (DARPA). It is a set of standards that allows computers to interchange data reliably over networks of interconnected equipment. Even when every piece of equipment could fail in interesting ways. (Formally TCP and IP are two standards, with close cousins ICMP and UDP as well as supplemented by DNS and a host of other protocols defined in so-called [RFC](https://www.rfc-editor.org/)'s. DNS mostly uses UDP, for instance.)

Before TCP/IP, computers exchanged data directly over dedicated lines and over phone lines. At that time, there were some ways to exchange email or files (_e.g._, UUCP and HEARN/RELAY), but these were cumbersome and loaded with assumptions on the content of the data.

Before DNS, if a computer wanted to exchange data with a computer that it had no direct connection to, it had to know the sequence of other computers that it had to traverse and send the data to the first computer in that path along with a digital envelope that specified the path to reach the destination. If one of the links or nodes along the path had a problem, the data would just not arrive. At best the sender would get a notification that the transfer had failed.

With TCP/IP and DNS, the sender only specifies the name of the intended recipient. DNS will then provide the technical address of the recipient and TCP/IP breaks the data up in managable chunks named packets and find a path to the destination for each packet. When some component along the way fails, that will detected by other components and an alternative route will be sought. Given the density of internet-capable equipment this is extremely likely to be successful.

### URL, HTML, HTTP

Uniform Resource Locator (URL), HyperText Markup Language (HTML) and HyperText Transfer Protocol (HTTP) are three technologies conceived by sir Tim Berners Lee at CERN.

The central concept of these technologies is the hyperlink. A hyperlink is a link between two anchors in documents. Not only can a hyperlink connect different documents. These documents can even be provided by different computers that can be very remote from each other, both physically and in network topology. To achieve this, the document where the link originates contains a URL that specifies the DNS name of the server that has the target of the link, a path to the target within the server and possibly a fragment identifier or query string for a more specific description of the desired target.

HTTP is a standard way to retrieve hyperlink targets from the server that is specified in the link. The HTTP-protocol is very generic. For example, the response to an HTTP-request can indicate that the response is not another hypertext document, but an image or an audio-file or a style-sheet. At first, HTTP was mainly used for retrieval of files. It proved pretty straight-forward however to instuct the target server to *do* something by submitting a URL too.

## Shortcomings of the world-wide web

* Insufficiently secure
* IP was designed for a smaller internet
* Clients are heavily dependent on servers

### HTTP was insufficiently secure

In the early twothousands HTTP was transmitted mainly in the clear. It was relatively easy to reroute and intercept TCP/IP traffic and, in the process, read and even modify its content. It took quite some time to develop Secure HTTP (HTTPS) to the level of security that it provides now. Contrary to the egalitarian principles of the hypertext technologies, HTTPS was constructed around cryptographic signatures that have to be bought from notary-like organisations (certificate authorities) that are blessed by browser and operating-system manufacturers. These signatures are closely linked to DNS names that have to be bought from other notary-like organisations (domain registrars) that are also blessed by browser and operating-system manufacturers. Nowadays these manufacturers are also cloud-providers that host most of the servers on the planet.

### IP was designed for a smaller Internet

Version 4 of the IP protocol, that was state-of-the-art when the world-wide web started to become a thing, was designed around a four-byte unique IP-address for each connected device. Four bytes allow for a bit more than 4 billion diffent combinations. Also, these addresses were structured in such a way that intermediate components in the network would need to look at only a few bits in each address and look it up in a manageable table to decide to which network-hop to send it. Nobody forsaw that quite a lot of households would own multiple devices that are connected to the internet as well as zillions of servers in the data centers of cloud-providers. A number of work-arounds have been designed to get  around this limitation (most notoriously Network Address Translation (NAT) that allows a (possbly large) number of computers to use the same IP-address, as long as they either behave like lowly clients or collaborate with a reverse-proxy). A new version the internet protocol, IPv6, was developed that co-exists with IPv4. IPv6 does not need the ugly work-arounds, but its adoption is slow. So, although quite a lot of internet providers as well as operating-system manufacturers support IPv6, many connected clients still use IPv4.

### Clients are heavily dependent on servers

As mentioned above, many of the developments that were designed to improve the security of the internet as well as accomodate the rapid growth of the network, sacrificed capabilities of clients. This resulted in an internet that is  much less democratic and egalitarian than it was at the beginning of the century.

* Clients cannot normally communicate with each other directly
* Clients are bombarded with advertisements
* User data is mostly stored on servers
* Many servers provide content that is designed to be addictive

Note that, while the data in IP-packets is (almost) always encrypted and not visible for arbitrary components on the internet, the other end is always a server, often owned by a cloud-provider. Data is also mostly stored in the cloud because that is convenient, but that means that the cloud-provider can use this data for purposes that might not align with the interests of the owner of that data.

Internet addiction in the form of so called social-media, entertainment, games and other content is no joke. A useful definition of an addiction is "a solution that aggravates the problem". To much involvement in social-media reduces the time spent face-to-face with friends and family and leads to social isolation. To much entertainment results in boredom. Too much time spent playing online games results in less time spent on realising real accomplishments in work, hobbies, and charity.

Another long-term effect of the dependence of clients on servers is the [enshittification](https://en.wikipedia.org/wiki/Enshittification) of the internet. Large cloud-providers become monopolists or oligarchies that are able to buy or wreck all competition. They also have a market penetration that it is so high that it is nearly impossible for them to grow the number of users. To realise a growth in revenue, they choose to reduce the quality of service. Thereby increasing the number of clicks.

## A brighter future

There is already a trend that shows the desire of internet users to be more sovereign. It is described as "the cozy web". Users interact in closed groups on cloud-hosted platforms that provide end-to-end encryption. This is currently the most cozy area in a server-dominated internet that is readily available for everyone.

Still, even the cozy web is facilitated by cloud-providers that make money selling user-data, either directly, or by selling statistical models that were trained on the data. This is neatly summarized in the statement: "when the service is free, you are the product".

A brighter future could be realized with peer-to-peer local-first software.

### Peer-to-peer

Peer-to-peer means that clients can communicate directly with each other. Current peer-to-peer protocols like IPFS and Iroh still require a relay-server that assists in arranging the connection through the assorted components that make up the current internet. However, a relay-server is a relatively dumb component, much like a router, a switch or a DNS-server.  It is also relatively easy to host your own relay-server and prevent surveilance by cloud-providers.

Peer-to-peer also opens the possibility to realise the convenience that cloud-storage offers, by storing data on computers of trusted friends and relatives. People you can trust not to misuse that data. It is also possible to encrypt this data with a key that is really private, so that it may be stored anywhere, but it is only readable with this key.

### Local-first

Local-first is a very old concept. Before the rise of the internet, all software was local-only. There was no reliable connection to other computers. Data was exchanged on tapes, floppy disks and USB sticks. There was no way to run the user-interface of an app on a different computer than the logic and the storage. Let's not give up the benefits of the internet, however. It is possbile to create apps that can run without an internet connection and when they come online they synchronise with other devices. There is a wonderful concept of Conflict-free Replicated DataTypes (CRDT's), that allows multiple users of devices that are not necessarily connected to work on the same document. Later, when they are connected the modifications are merged into a single version. Users that are connected, see each others modifications in real time. This technology powers Google Docs and Office 365, but CRDT's don't necessarily rely on servers. There are also peer-to-peer variants like `automerge`.

### Public + cosy = civil

The world-wide web has turned into a public environment that has become exceedingly dangerous for civilians. The cozy web is too restrictive and doesn't really solve anything. Can we build a civilized internet on top of the current infrastructure?

TCP/IP has evolved to QUIC. QUIC is maybe a bit less efficient in client-server communication, but it is very suitable for peer-to-peer communication. It is defined on top of UDP/IP, so it works with all devices that the internet currently consists of.

However, first and foremost we need to develop apps that remove the dependence of clients on servers, while allowing users to keep using their devices, preferably more effective than at the moment.

In addition to the web-site of a sports-club and a Signal-group of team-members there could be an app that strikes a balance between Signal and Mastodon. Users create profiles for different roles (work, sport, family, neigbors, etc.) and create content that they want to share. It should be possible to collaborate on content, but should also be easy to restrict content to a certain group. Maybe we can bring back the design philosophy of HTTP that there are many kinds of content and that it is up to users and app-makers to investigate which kinds of content are useful. A local-first peer-to-peer browser with built-in CRDT support? Can we come up with an extension to URL's that is peer-to-peer friendly? It would be folly to throw away the internet, but we can do better. Much better.

Cloud technology has its place. For large organisations it makes perfect sense to treat servers like cattle, not pets. However, most of the devices that are connected to the internet are *not* owned by large organisations, but by users like you and me. And it is shocking to see how little control we have over our devices. We can choose from a very limited number of operating-systems (especially when we need to use a banking app or login to a government web site). These operating-systems are created by cloud-providers that operate app-stores that provide not real apps, but user-interface apps for cloud-services. To misquote *Once in a lifetime* by The Talking Heads:

> And you may tell yourself
>
> "This is not my beautiful laptop!"
>
> And you may tell yourself
>
> "This is not my beautiful phone!"

As a back-end developer I spent my entire professional life on building server-based applications. I am very disenchanted by the collective results of so many well-intended efforts.

I propose the creation of a civil internet that serves the interests of users instead of being littered with constructions that favour servers and cloud-providers. Where users are treated as people, not addicts.
