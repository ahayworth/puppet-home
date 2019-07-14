node "nuc" {
  include docker_common
  include homeassistant
  include nginx_proxy
  include misc::network::nuc
  include systemd
}
