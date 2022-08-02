#

# @param [Boolean] default_vhost
#   xxx
#   Default value: true

#
class minifox::policy::app::webserver::apache (
  Boolean $default_vhost = true,
) {
  if $facts['kernel'] == 'windows' {
    fail('Unsupported OS')
  }

  case $facts['os']['family'] {
    'Debian':{
      $mpm = 'itk'
    }
    'RedHat':{
      $mpm = 'prefork'
    }
    default:{
      fail('Unsupported OS')
    }
  }

  class { 'apache':
    default_vhost => $default_vhost,
    mpm_module    => $mpm,
  }

  contain minifox::policy::app::webserver::apache::php
}
