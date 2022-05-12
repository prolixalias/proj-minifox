class policy::baseline::linux {

  include policy::baseline::linux::packages
  include policy::baseline::linux::vim
  include policy::baseline::linux::motd
  include policy::baseline::users::linux
  include policy::baseline::linux::ssh
  include policy::baseline::linux::firewall

}
