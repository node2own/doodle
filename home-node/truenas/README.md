# Home-node based on TrueNAS

<!-- TOC -->
* [Home-node based on TrueNAS](#home-node-based-on-truenas)
  * [Install TrueNAS](#install-truenas)
  * [Set up an OWNER-account](#set-up-an-owner-account)
  * [Clone this repo](#clone-this-repo)
  * [Conventions](#conventions)
  * [Iroh SSH](#iroh-ssh)
  * [Zed](#zed)
  * [DNS](#dns)
    * [dnsmasq](#dnsmasq)
<!-- TOC -->

## Install TrueNAS

First, [download TrueNAS Community Edition](https://www.truenas.com/truenas-community-edition/) a.k.a. TrueNAS Scale.

Then copy the file to a USB stick and boot from it. Give the correct answers :slightly_smiling_face: to all questions and voilà: a NAS!

Configure the DHCP-subsystem of your router to assign a fixed IP-address to the NAS. Make a note of the address, we'll refer to it as NAS_IP below.

Use the Web-UI to install the Distribution-app: a local registry for Docker-images. We are going to use it later, and installing it now ensures that the Docker subsystem is running.

## Set up an OWNER-account

Use the Web-UI to create an account for yourself and store the password in a password manager (I use KeePass and keep its database on a replicated file-system; in my case Dropbox). I'll subsequently refer to this account as OWNER. (In my case its real name is `jeroen`, but I'm sure it will be different in yours.) Make sure the password manager has a really strong password. Put it in a sealed envelope in a safe place, because if you lose it you will be locked out of everything!

Use the Web-UI to:
* Arrange that OWNER can `sudo docker` without a password
* Put OWNER in the `builtin_admin` group
* Enable `sshd`

Login as OWNER (the Web-UI provides a shell that lets you `sudo su <USER>`), and create an `ssh` key-pair using `ssh-keygen`. You can also copy an existing key pair to the `~/.ssh` directory if that is more convenient (it was in my case). I also appended the public-key to the `authorized_keys`-file. This allows me to `ssh` into this account from my laptop without having to enter a password.

From now on it should be possible to log into the NAS from a terminal on another computer using `ssh OWNER@NAS_IP`,
where OWNER is the name of the OWNER-account and NAS_IP is the IP-address of the NAS. I prefer this to the shell from the Web-UI.

Don't forget to store the key-pair in your password manager. And for good measure, store the `truenas_admin` password there too. (I also put NAS_IP in there, although it isn't very secret.)

## Clone this repo

Add the public-key of the OWNER-account to your GitHub account.

Log into OWNER and
```shell
mkdir ~/workspace
cd ~/workspace
git clone git@github.com:node2own/doodle.git
```

From now on it is possible to login using:
```shell
ssh -t OWNER@NAS_IP workspace/doodle/home-node/truenas/bin/dev.sh
```
This starts a `screen`-session in a Docker-container that keeps running, even when the connection between you computer and the NAS is broken (e.g., because your computer enters sleep-mode). Note that Ctrl-A is special in `screen`. Type `Ctrl-A` followed by `d` to disconnect the session. It will keep running and you can reconnect later. Type `Ctrl-A` followed by `?` to see what else is possible and `Ctrl-A` followed by `a` to send a `Ctrl-A` to the process within `screen` (e.g., to go to the start of the line in `bash`).

The `screen`-tool is especially useful when performing long-running commands, e.g., to copy data from your old NAS.

I wrote a [little script](https://github.com/jeroenvanmaanen/scripts/blob/master/miranda.sh) that I can run as a shorthand for this command.

Script `dev.sh` also accepts the `--root` flag to start a screen session as `root`. Remember that these sessions are running in a dev-container, not on the host itself. However, it does allow access to the disks mounted on `/mnt` with `root`-permissions though.

I prefer a dev-container over installing tools on the host system, because:

* It keeps the host system clean
* I can easily recover from Git when things break
* I can easily go back to a previous version of the dev-container when a change proved to be detrimental
* I can try out changes to the dev-container while simultaneously using the old container to maintain the NAS
* I can use the same setup on multiple systems

## Conventions

* Clones of Git-repo's are located in `~/workspace`
* Most of my repo's have a `bin`-directory that contains a script `project-set-env.sh` that can be sourced to set the PATH and the prompt:

      . ~/workspace/REPO/bin/project-set-env.sh

  or

      cd ~/workspace/REPO 
      . bin/project-set-env.sh

  below I will assume that this has been run:

      . ~/workspace/doodle/bin/project-set-env.sh

* Most of my bash-scripts start with:

      #!/bin/bash

      set -e

      BIN="$(cd "$(dirname "$0")" ; pwd)"

      source "${BIN}/lib-verbose.sh"

  * The line `set -e` ensures that the script stops on any unexpected error
  * The line `BIN="..."` figures out where the script is, to make it easy to source script-libraries from the same location.
  * The line `source "${BIN}/lib-verbose.sh"` loads a script-library that consumes one or two initial `-v` flags from the command line. One `-v` means debug and shows the output of calls to the `log`-function. Two `-v` flags means trace and also logs every shell command be for it runs.

## Iroh SSH

The ability to SSH into your home-server is pretty neat, but it is even better to be able to establish a peer-to-peer connection and SSH through that.

```bash
iroh-ssh-start.sh
docker logs iroh-ssh
```

The initial section of the log of the `iroh-ssh`-container shows a connection string that has the form `USER_NAME@NODE_ID`. Copy the `NODE_ID` to a file names `~/.auth/iroh-ssh-NODE_NAME.nodeid`. I made a script on my Mac that uses the NODE_ID to establish a peer-to-peer connection to it.

```bash
#!/bin/bash

set -e

HOME_NODE_BIN="${HOME}/workspace/doodle/home-node/truenas/bin"

source "${HOME_NODE_BIN}/lib-verbose.sh"

"${HOME_NODE_BIN}/iroh-ssh.sh" "${USER}@$(cat ~/.auth/iroh-ssh-NODE_NAME.nodeid)" "$@"
tput init
```

## Zed

Up to this moment, I am editing files on my Mac (using IntelliJ) and go around the cycle edit, push, switch to remote terminal, pull, run, switch back to editor, repeatedly. This is quite annoying.

What I would like is to run the frontend of my editor on my Mac and remotely edit files on my home-server. And, yes I know that IntelliJ Ultimate supports remote development, but why not switch to Zed? :slightly_smiling_face: With a bit of luck I can have Git integration and a terminal inside Zed and do the whole development-cycle in a single window without having to push every single typo-fix separately.

I found that [n0](https://n0.computer/) is adding the support for Iroh-connections to the remote editing capabilities of Zed! I got the branch [dignifiedquire/zed/add_iroh_p2p_remote](https://github.com/dignifiedquire/zed/tree/add_iroh_p2p_remote) to compile, but I am still figuring out how to create a zed-Iroh-ticket from the NODE_ID that `iroh-ssh` provided. To be continued.

## DNS

I intend to replace this section altogether, because I want to replace the DNS + client-server model with a peer-to-peer model. Instead of a central authority that grants registrars the right to create names in certain domains, I would like to have my onw list of names for peer-ids. Also, I would like to decide for myself when I trust the identity of a peer-id and on whose say-so. So I hope to replace this section by a section that explains how to set up a local node-naming facility (NNF) at some point.

For now, let's set up a local DNS using `dnsmasq`.

### dnsmasq

I uploaded a docker-image named `node2own/dnsmasq` to Docker Hub.

Would you like to build it yourself? Be my guest:

```shell
cd ~/workspace/doodle
. bin/project-set-env.sh
cd home-node/truenas/docker/dnsmasq
docker-build-cwd.sh
```

In any case, run:

```shell
dnsmasq-start.sh
docker rm -f dev
```

And restart the dev-container (it will use the new local DNS-server)

At this point it is an option to point the DNS that your router provides to connected computers to the IP-address of the home-node.
