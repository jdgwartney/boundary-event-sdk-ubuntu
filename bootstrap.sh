#!/usr/bin/env bash

#
# Setup variable to track installation logging
#
LOG="$PWD/install.log"

# Explicitly set the HOME variable
export HOME=~vagrant

sudo apt-get update -y

log() {
  typeset -r msg=$1
  echo "$(date): $msg"
}

#
# Update packages 
#
log "Updating packages..."
sudo apt-get update -y

#
# Create standard directories
#
DOWNLOADS_DIR=/downloads
TOOLS_DIR=${HOME}/tools
mkdir -p ${DOWNLOADS_DIR}


#
# Packages for sane administration
#
log "Install system adminstration packages..."
sudo apt-get install -y software-properties-common python-software-properties
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update -y

#
# Required packages for Boundary Event SDK
#
log "Install required packages for Boundary Event SDK..."
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get install -y oracle-java7-installer maven git autoconf make oracle-java7-set-default

# Install the Boundary Event SDK
log "Install Boundary Event SDK..."
SDK_LOG="$HOME/boundary_sdk_log.$(date +"%Y-%m-%dT%H:%m")"

sudo su - vagrant -c "touch hello"
sudo su - vagrant -c "git clone https://github.com/boundary/boundary-event-sdk.git >> $SDK_LOG 2>&1"
sudo su - vagrant -c "cd boundary-event-sdk && bash setup.sh  >> $SDK_LOG 2>&1"
sudo su - vagrant -c "cd boundary-event-sdk && mvn install >> $SDK_LOG 2>&1"

# Configure rsyslog

log "Configure syslog ..."
sudo su -c "echo '*.*' @localhost:1514 >> /etc/rsyslog.conf" >> $SDK_LOG 2>&1
sudo service rsyslog restart >> $SDK_LOG 2>&1

# Install the Boundary Meter

