About
=====

This vagrant environment sets up vanilla Ubuntu 12.04 and adds the checkbox-dev
PPA (but pins it to a low priority) and adds all the \*.debs from the current
directory into the locally visible archive. It is perfect for testing your
locally built packages.

Prerequisites
=============

Ensure thay you have precise-desktop-i386 box available (make it using
https://github.com/zyga/vagrant-desktop-images).

You will also need a way to build checkbox packages. You can clone/branch
checkbox and checkbox-packaging and sylink the debian directory over to build
packages natively but no automatic support for that is provided here.

Usage
=====

Run 'vagrant up' and wait for the virtual machine window to show up. After a
moment all of the local packages will be available for install
