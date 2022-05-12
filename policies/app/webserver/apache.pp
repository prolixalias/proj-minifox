class policy::app::webserver::apache (
  $default_vhost = true,
){

  if $::kernel == 'windows' {
    fail('Unsupported OS')
  }

  case $::osfamily {
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

  class { '::apache':
    default_vhost => $default_vhost,
    mpm_module    => $mpm,
  }

  contain ::policy::app::webserver::apache::php

}
