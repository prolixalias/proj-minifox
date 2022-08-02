#

# @param [Boolean] purge
#   xxx
#   Default value: false

#
class minifox::policy::baseline::linux::firewall (
  Boolean $purge = false,
) {
  Firewall {
    before  => Class['minifox::policy::baseline::linux::firewall_post'],
    require => Class['minifox::policy::baseline::linux::firewall_pre'],
  }

  class { ['minifox::policy::baseline::linux::firewall_pre', 'minifox::policy::baseline::linux::firewall_post']: }

  resources { 'firewall':
    purge => $purge,
  }

  include firewall
}
