#

#
class minifox::policy::baseline::darwin::motd {
  $default_motd = @("MOTD"/L)
    ===========================================================
    Access  to  and  use of this server is  restricted to those
    activities expressly permitted by the system administration
    staff. If  you're not  sure if it's  allowed, DO NOT DO IT.
    ===========================================================

    OS: ------ ${getvar('facts.os.distro.description')}
    Host: ---- ${getvar('facts.networking.hostname')}
    Domain: -- ${getvar('facts.networking.domain')}

    | MOTD

  # Check if we have a hiera override for the MOTD, otherwise use the default
  $message = lookup('motd', default_value => $default_motd)

  class { 'motd':
    content => $message,
  }
}
