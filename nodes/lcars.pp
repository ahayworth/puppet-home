node "lcars" {
  include docker_common
  include pihole
  include docker_misc
  include misc::packages
  include misc::network::lcars
  include wireguard
  include zfs
  include systemd
  include plex
}
