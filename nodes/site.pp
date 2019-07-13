node "nuc" {
  include docker_common
  include homeassistant
  include nginx_proxy
  include misc::network::nuc
  include systemd
}

node "lcars" {
  include docker_common
  include pihole
  include misc::packages
  include misc::network::lcars
  include wireguard
  include zfs
  include systemd
  include plex
}

/*
node "janeway" {
  include docker_common
  include misc::packages
  include misc::alacritty
}
*/

node "janeway" {
  include users::andrew
  include misc::archlinux::bootloader
}
