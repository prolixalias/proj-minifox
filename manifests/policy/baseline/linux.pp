#

#
class minifox::policy::baseline::linux {
  include minifox::policy::baseline::linux::packages
  include minifox::policy::baseline::linux::vim
  include minifox::policy::baseline::linux::motd
  include minifox::policy::baseline::users::linux
  include minifox::policy::baseline::linux::ssh
  include minifox::policy::baseline::linux::firewall
}
