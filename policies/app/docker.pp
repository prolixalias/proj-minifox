class policy::app::docker {

  if $::kernel == 'windows' {
    fail('Unsupported OS')
  }

  include ::docker

}
