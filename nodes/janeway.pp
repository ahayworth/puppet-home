node "janeway" {
  require pacman::aur
  include bootloader::uefi
  include desktop
  include pacman
  include users::andrew
  include misc::packages
}
