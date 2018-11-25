#!/bin/bash

if [[ ! -z "$DEBUG" ]]; then debug='--debug'; fi

function decrypt() {
  cp $1 /tmp/$2
  gpg --batch --passphrase $passphrase -d $1 2>/dev/null > $1.plaintext
  mv $1.plaintext $1
}

function encrypt() {
  mv /tmp/$2 $1
}

read -s -p "Encryption passphrase: " passphrase
echo
read -s -p "Confirm: " passphrase2
echo

if [[ $passphrase != $passphrase2 ]]; then
  echo "Passphrases didn't match."
  exit 1
fi

decrypt "modules/home_assistant/files/home_assistant/config/secrets.yaml" "hass-secrets"
decrypt "modules/home_assistant/files/home_assistant/config/ps4-credentials.json" "hass-ps4"
decrypt "modules/home_assistant/files/home_assistant/config/xbox_tokens" "hass-xbox"
decrypt "data/secrets.yaml" "puppet-secrets"

sudo /opt/puppetlabs/bin/puppet \
  apply \
  $1 \
  $debug \
  --modulepath=modules:vendor \
  --hiera_config=hiera.yaml \
  --show_diff \
  nodes/site.pp

encrypt "modules/home_assistant/files/home_assistant/config/secrets.yaml" "hass-secrets"
encrypt "modules/home_assistant/files/home_assistant/config/ps4-credentials.json" "hass-ps4"
encrypt "modules/home_assistant/files/home_assistant/config/xbox_tokens" "hass-xbox"
encrypt "data/secrets.yaml" "puppet-secrets"
