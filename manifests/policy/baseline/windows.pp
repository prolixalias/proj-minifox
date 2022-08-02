#

#
class minifox::policy::baseline::windows {
  include minifox::policy::baseline::users::windows
  include minifox::policy::baseline::windows::bootstrap
  include minifox::policy::baseline::windows::common
  include minifox::policy::baseline::windows::firewall
  include minifox::policy::baseline::windows::motd
  include minifox::policy::baseline::windows::packages
  #include minifox::policy::baseline::windows::win_corp_baseline
}
