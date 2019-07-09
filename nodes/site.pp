node "nuc" {
  include misc
  include docker_common
  include homeassistant
  include nginx_proxy
}

node "lcars" {
  include docker_common
  include pihole
  include misc
  include wireguard
  include zfs
}

node "janeway" {
  include docker_common
  include misc
  include misc::firmware
}
