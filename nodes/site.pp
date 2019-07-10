node "nuc" {
  include misc
  include docker_common
  include homeassistant
  include nginx_proxy
  include misc::network::nuc
  include systemd
}

node "lcars" {
  include docker_common
  include pihole
  include misc
  include misc::network::lcars
  include wireguard
  include zfs
  include systemd
  include plex
}

node "janeway" {
  include docker_common
  include misc
  include misc::firmware
  include misc::laptop
}
