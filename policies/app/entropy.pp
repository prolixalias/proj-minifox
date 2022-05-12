class policy::app::entropy {

  if $::kernel == 'windows' {
    fail('Unsupported OS')
  }

  class { '::rngd':
    hwrng_device => '/dev/urandom',
  }

}
