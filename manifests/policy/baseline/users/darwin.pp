#

#
class minifox::policy::baseline::users::darwin {
  user { 'PuppetSE':
    ensure   => 'present',
    comment  => 'SE Demo Account',
    gid      => '10010',
    home     => '/',
    password => 'puppetftw',
    shell    => '/bin/bash',
    uid      => '10010',
  }
}
