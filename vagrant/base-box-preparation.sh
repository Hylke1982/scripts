#!/bin/sh

VAGRANT_USER=vagrant
VAGRANT_HOME=/home/$VAGRANT_USER

install_required_packages()
{
 apt-get install -y -q sudo
 apt-get install -y -q linux-headers-amd64 build-essential dkms
 apt-get install -y -q puppet
}

add_vagrant_user()
{
 echo "Adding vagrant user"
 getent passwd $1 > /dev/null 2&>1
 if [ $? -neq 0 ]; then
  useradd -d $VAGRANT_HOME $VAGRANT_USER
  echo 'vagrant:vagrant' | chpasswd $VAGRANT_USER
 fi
}

add_vagrant_user_as_sudoer()
{
 echo "Adding vagrant as sudoer"
 local FILE=/etc/sudoers.d/$VAGRANT_USER

 if [ ! -f $FILE ]; then
  echo 'vagrant ALL=(ALL) NOPASSWD:ALL' > $FILE
 fi
}

add_vagrant_authorized_keys()
{
 local SSH_DIR=$VAGRANT_HOME/.ssh
 local AUTHORIZED_KEYS=$SSH_DIR/authorized_keys
 mkdir -p $SSH_DIR
 wget -O $AUTHORIZED_KEYS https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
 chown -cR $VAGRANT_USER $SSH_DIR
 chmod 0700 $SSH_DIR/authorized_keys
}

# Execute base box preparation script
install_required_packages
add_vagrant_user
add_vagrant_user_as_sudoer
add_vagrant_authorized_keys