#!/bin/bash

if [[ ! -z "$DEBUG" ]]; then debug='--debug'; fi

function decrypt() {
  gpg -q -d $1 > $1.plaintext
  mv $1.plaintext $1
}

function encrypt() {
  gpg -c $1
  mv $1.gpg $1
}

decrypt "modules/home_assistant/files/home_assistant/config/secrets.yaml"
decrypt "data/secrets.yaml"

sudo /opt/puppetlabs/bin/puppet \
  apply \
  $1 \
  $debug \
  --modulepath=modules:vendor \
  --hiera_config=hiera.yaml \
  --show_diff \
  nodes/site.pp

encrypt "modules/home_assistant/files/home_assistant/config/secrets.yaml"
encrypt "data/secrets.yaml"
