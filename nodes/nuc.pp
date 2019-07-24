node "nuc" {
  include docker_common
  include homeassistant
  include misc::network::nuc
  include systemd
}
