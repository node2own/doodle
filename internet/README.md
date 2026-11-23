# Internet

Although it is attractive to self-host as much as possible on a [home-node](../home-node), at least for the time being, some stuff needs to be "in the cloud". Keeping in mind that "there is no cloud, it's just someone else's computer", these two important arrangements depend on worldwide trust (and are therefore also extremely vulnerable to disruption in case that trust should shift):
* Domain Name Service (DNS)
* Transport Level Security (TLS) certificates

These two technologies are deeply related and were developed to solve one half of the problem of trust on the internet. Originally DNS was only a way of mapping a human-readable domain-name to a machine-usable address (an IP-address). However, even before TSL and its precursor SSL, visitors of web sites trust the DNS system to respond with an address that actually corresponds to a (trusted proxy of) a site that provides content and services on behalf of the owner of the domain. Whether legally binding or not, we hold the owner of the domain responsible for our interactions with the corresponding machines.

In the early internet this was easy to circumvent, but he amount of internet traffic was also small and misuse was hard to hide.

When the amount of traffic grew, encryption of the data became more and more common and first SSL and later TLS were developed to standardize common usages patterns for encrypted communication.

To keep things simple for clients visiting web-sites, it was decided to have web-sites identify themselves by offering a certificate that proves that the server that handles the connection uses a private key that corresponds to the DNS name of the site. This key is used to set-up the shared encryption key that is used to encrypt the data on the connection. The problem with this is ascertaining the authenticity of the certificate. Ultimately this boils down to checking a digital signature against a list of well-known public keys of signing authorities. Recently the private key of such a trusted party was compromised and zillions of clients had to be updated to remove the corresponding public key from the list, because it could no longer be trusted.

The alternative is that anyone who listens for connections on the internet gets their keys verified by other parties they have close connections to. Just like there are some extremely clever algorithms that make it possible to route data packets from between arbitrary IP-addresses, likewise the could be algorithms that find a path of trust between arbitrary parties on the internet. Just use some app that you trust to generate a public/private key pair, share and authenticate it with your bank, your phone provider and your grocery-delivery service and you can use it to prove security assertions to anyone. The web sites you visit do the same. And then Iroh wold let you just dial the key with the help of any Iroh compatible relay (including a self-hosted one) instead of relying on ultimately centralized services like DNS and TLS.

Sadly this alternative does not (yet?) exist.

Therefore I need to host a DNS zone somewhere and arrange for a TLS certificate (and keep it up-to-date). For DNS I am looking at my local internet service provider [Freedom Internet](https://freedom.nl) and at Hetzner. Foor TLS certificates I am evaluating [Harica](https://www.harica.gr/en/server-certificates/)
