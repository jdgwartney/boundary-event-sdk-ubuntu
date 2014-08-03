#!/usr/bin/env bash

sudo apt-get update -y
sudo apt-get install -y software-properties-common python-software-properties
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update -y
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get install -y oracle-java7-installer maven git autoconf make
sudo apt-get install -y oracle-java7-set-default
