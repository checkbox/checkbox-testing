About
=====

This vagrant environment sets up vanilla Ubuntu 12.04 and adds the required set
of PPAs to install canonical-certification-server. The
canonical-certification-server package is a replacement for
chekbox-certification-server implemented with plainbox.

Prerequisites
=============

You will need a working Vagrant installation.

Usage
=====

Run 'vagrant up' and wait for the virtual machine to provision. Then run
'vagrant ssh' and you should be able to use 'checkbox-certification-server'
