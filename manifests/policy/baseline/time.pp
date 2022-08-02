#
# @param [String] timeclass
#   xxx
# @param [Array] timeservers
#   xxx
#   Default value: ['0.pool.ntp.org','1.pool.ntp.org']
#

#
class minifox::policy::baseline::time (
  String $timeclass,
  Array $timeservers = ['0.pool.ntp.org','1.pool.ntp.org'],
) {
  # if getvar('facts.kernel') == 'Darwin' {
  #   $timeclass = 'skip'
  # }
  # elsif getvar('facts.kernel') == 'windows' {
  #   $timeclass = 'winntp'
  # }
  # elsif getvar('facts.os.family') == 'RedHat' and getvar('facts.os.release.major') == '8' {
  #   $timeclass = 'chrony'
  #   $restrict_param = 'queryhosts'
  # }
  # else {
  #   $timeclass = 'ntp'
  #   $restrict_param = 'restrict'
  # }

  case $timeclass {
    'chrony': {
      class { $timeclass:
        servers    => $timeservers,
        queryhosts => ['127.0.0.1'],
      }
    }
    'ntp': {
      class { $timeclass:
        servers  => $timeservers,
        restrict => ['127.0.0.1'],
      }
    }
    default:  {
      notify { 'time policy':
        message  => 'skipping',
        loglevel => 'info',
      }
    }
  }
}
