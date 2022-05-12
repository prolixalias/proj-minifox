class policy::baseline::linux::firewall (
  $purge = false,
) {

  Firewall {
    before  => Class['policy::baseline::linux::firewall_post'],
    require => Class['policy::baseline::linux::firewall_pre'],
  }

  class { ['::policy::baseline::linux::firewall_pre', '::policy::baseline::linux::firewall_post']: }

  resources { 'firewall':
    purge => $purge,
  }

  include firewall

}
