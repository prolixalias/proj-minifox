class policy::baseline::windows {

  include policy::baseline::windows::bootstrap
  include policy::baseline::windows::common
  include policy::baseline::windows::motd
  include policy::baseline::windows::firewall
  include policy::baseline::windows::packages
  include policy::baseline::users::windows

  #include policy::baseline::windows::win_corp_baseline

}
