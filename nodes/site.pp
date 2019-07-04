node "nuc" {
  include misc
  include docker_common
  include homeassistant
  include nginx_proxy
}

node "lcars" {
  include misc
  include zfs
}
