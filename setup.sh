#!/bin/bash

dir=$(pwd)
distro='stretch'
puppet_major_version='5'
agent_version=''

release_pkg="puppet$puppet_major_version-release"
agent_pkg="puppet-agent$agent_version"
puppet_bin='/opt/puppetlabs/bin/puppet'

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

function apt() {
  sudo apt-get install -y $1
}

function puppetmodule() {
  if ! $puppet_bin module list --modulepath vendor 2>/dev/null | grep -q $1; then
    section "installing puppet module $1"
    $puppet_bin module install --target-dir vendor --modulepath vendor $1
  fi
}

section "bootstrapping puppet for debian $distro"

if ! installed "jq"; then
  section "installing dependencies"
  apt "jq"
fi

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

puppetmodule "puppetlabs-docker"

section "done!"
