#!/bin/sh

VAGRANT_USER=vagrant

install_required_packages()
{
 apt-get install -y -q sudo
 apt-get install -y -q linux-headers-amd64 build-essential dkms
 apt-get install -y -q puppet puppet-agent
}

add_vagrant_user()
{
 echo "Adding vagrant user"
 getent passwd $1 > /dev/null 2&>1
 if [ $? -neq 0 ]; then
  useradd -d /home/vagrant vagrant
  echo 'vagrant:vagrant' | chpasswd vagrant
 fi
}

add_vagrant_user_as_sudoer()
{
 echo "Adding vagrant as sudoer"
 local FILE=/etc/sudoers.d/vagrant

 if [ ! -f $FILE ]; then
  echo 'vagrant ALL=(ALL) NOPASSWD:ALL' > $FILE
 fi
}

# Execute base box preparation script
install_required_packages
add_vagrant_user
add_vagrant_user_as_sudoer