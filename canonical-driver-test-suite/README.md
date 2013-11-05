About
=====

This vagrant environment sets up vanilla Ubuntu 12.04 and adds the required set
of PPAs to install canonical-driver-test-suite.

Prerequisites
=============

Ensure thay you have precise-desktop-i386 box available (make it using
https://github.com/zyga/vagrant-desktop-images).

You need to have access to the private checkbox-ihv-ng PPA:
https://launchpad.net/~checkbox-ihv-ng/+archive/private-ppa

You will need to copy your PPA access URL from launchpad and extract the
username:password fragment and insert it into the $ppa\_secret variable in
`manifets/default.pp`

Usage
=====

Run 'vagrant up' and wait for the virtual machine window to show up. After a
moment all of the required packages should install (make sure to keep watching
the output from vagrant) and you should be able to find and run "Canonical
Driver Test Suite" from the dash.
