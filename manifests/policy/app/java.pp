#

# @param [String] distribution
#   xxx
#   Default value: 'jre'

#
class minifox::policy::app::java (
  String $distribution = 'jre',
) {
  case $facts['kernel'] {
    'windows': {
      class { 'minifox::policy::app::java::windows':
        distribution => $distribution,
      }
    }

    'Linux': {
      class { 'minifox::policy::app::java::linux':
        distribution => $distribution,
      }
    }

    default:   {
      fail('Unsupported kernel detected')
    }
  }
}
