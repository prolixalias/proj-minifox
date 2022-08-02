#

#
class minifox::policy::app::docker {
  if $facts['kernel'] == 'windows' {
    fail('Unsupported OS')
  }

  include docker
}
