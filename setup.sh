#!/bin/bash

dir=$(pwd)
distro='stretch'
puppet_major_version='5'
agent_version=''

release_pkg="puppet$puppet_major_version-release"
agent_pkg="puppet-agent$agent_version"

function section() {
  echo
  echo -n "===================="
  echo -n "===================="
  echo    "===================="
  echo "$1..."
  echo -n "===================="
  echo -n "===================="
  echo -n "===================="
  echo
}

function installed() {
  sudo dpkg -s $1 2>/dev/null | grep -q 'Status: install ok installed'
}

section "bootstrapping puppet for debian $distro"
if ! installed $release_pkg ; then
  section "installing $release_pkg apt repo"
  cd /tmp
  wget "http://apt.puppetlabs.com/$release_pkg-$distro.deb"
  sudo dpkg -i ./$release_pkg-$distro.deb
  rm ./$release_pkg-$distro.deb
  sudo apt-get update 2>/dev/null
  cd $dir
fi

if ! installed $agent_pkg; then
  section "installing puppet"
  sudo apt-get -y install $agent_pkg
  sudo systemctl stop puppet || /bin/true
  sudo systemctl disable puppet || /bin/true
fi

section "done!"
