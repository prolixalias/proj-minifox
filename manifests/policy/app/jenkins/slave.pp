#

# @param [String] master_url
#   xxx
#   Default value: 'http://localhost:8080'

#
class minifox::policy::app::jenkins::slave (
  String $master_url = 'http://localhost:8080',
) {
  include minifox::policy::baseline

  case $facts['kernel'] {
    'Linux': {
      class { 'jenkins::slave':
        masterurl    => $master_url,
        ui_user      => 'admin',
        ui_pass      => 'password',
        labels       => ['tse-slave-linux','tse-control-repo'],
        slave_groups => 'wheel',
      }

      include minifox::policy::app::puppetdev
    }

    'windows': {
      class { 'policy::app::jenkins::win_slave':
        masterurl => $master_url,
        ui_user   => 'admin',
        ui_pass   => 'password',
        labels    => 'tse-slave-windows',
      }

      include minifox::policy::app::puppetdev
    }

    default:{
      fail('Unsupported OS')
    }
  }
}
