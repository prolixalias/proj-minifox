class policy::app::jenkins::slave (
  $master_url = 'http://localhost:8080',
){

  include ::policy::baseline

  case $::kernel {

    'Linux': {
      class { '::jenkins::slave':
        masterurl    => $master_url,
        ui_user      => 'admin',
        ui_pass      => 'password',
        labels       => ['tse-slave-linux','tse-control-repo'],
        slave_groups => 'wheel',
      }

      include ::policy::app::puppetdev
    }

    'windows': {
      class { '::policy::app::jenkins::win_slave':
        masterurl => $master_url,
        ui_user   => 'admin',
        ui_pass   => 'password',
        labels    => 'tse-slave-windows',
      }

      include ::policy::app::puppetdev
    }

    default:{
      fail('Unsupported OS')
    }

  }


}
