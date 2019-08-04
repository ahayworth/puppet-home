node "nuc" {
  include docker_common
  include misc::network::nuc
  include systemd
}
