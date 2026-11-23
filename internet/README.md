# Internet

Although it is attractive to self-host as much as possible on a [home-node](../home-node), at least for the time being, some stuff needs to be "in the cloud". Keeping in mind that "there is no cloud, it's just someone else's computer", these two important arrangements depend on worldwide trust (and are therefore also extremely vulnerable to disruption in case that trust should shift):
* Domain Name Service (DNS)
* Transport Level Security (TLS) certificates

These two technologies are deeply related and were developed to solve one half of the problem of trust on the internet. Originally DNS was only a way of mapping a human-readable domain-name to a machine-usable address (an IP-address). However, even before TSL and its precursor SSL, visitors of web sites trust the DNS system to respond with an address that actually corresponds to a (trusted proxy of) a site that provides content and services on behalf of the owner of the domain. Whether legally binding or not, we hold the owner of the domain responsible for our interactions with the corresponding machines.

In the early internet this was easy to circumvent, but he amount of internet traffic was also small and misuse was hard to hide.

When the amount of traffic grew, encryption of the data became more and more common and first SSL and later TLS were developed to standardize common usages patterns for encrypted communication.

