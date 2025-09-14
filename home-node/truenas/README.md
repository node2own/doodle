# Home-node based on TrueNAS

First, [download TrueNAS Community Edition](https://www.truenas.com/truenas-community-edition/) a.k.a. TrueNAS Scale.

Then copy the file to a USB stick and boot from it. Give the correct :slightly_smiling_face: to all questions and voilà: a NAS!

Use the Web-UI to create an account for yourself and store the password in a password manager (I use KeePass and keep its database on a replicated file-system; in my case Dropbox). Make sure the password manager has a really strong password. Put it in a sealed envelope in a safe place, because if you lose it you will be locked out of everything!

Login as that user (the Web-UI provides a shell that lets you `sudo su <USER>`), and create an `ssh` key-pair using `ssh-keygen`. You can also copy an existing key pair to the `~/.ssh` directory if that is more convenient (it was in my case).

Store the key-pair also in your password manager.

Add the public-key to your GitHub account.