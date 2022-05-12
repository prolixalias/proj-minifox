class policy::baseline::time (
  Array $timeservers = ['0.pool.ntp.org','1.pool.ntp.org'],
) {
  if getvar('facts.kernel') == 'windows' {
    $timeclass = 'winntp'
  }
  elsif getvar('facts.os.family') == 'RedHat' and getvar('facts.os.release.major') == '8' {
    $timeclass = 'chrony'
  }
  else {
    $timeclass = 'ntp'
  }

  class { $timeclass:
    servers => $timeservers,
  }
}
