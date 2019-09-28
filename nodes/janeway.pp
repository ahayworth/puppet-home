node "janeway" {
  #include desktop
  include pacman::aur
  include pacman
  include bootloader::uefi
  include misc::packages
  include users::andrew
  Class['Misc::Packages'] -> Class['Pacman::Aur'] -> Class['Pacman']
}
