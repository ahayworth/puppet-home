node "janeway" {
  require pacman::aur
  include bootloader::uefi
  include desktop
  include pacman
  include misc::packages
  include users::andrew
}
