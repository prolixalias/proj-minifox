class policy::baseline::linux::motd {
  $default_motd = @("MOTD"/L)
    ===========================================================
    Access  to  and  use of this server is  restricted to those
    activities expressly permitted by the system administration
    staff. If you are not sure if it is allowed, then DO NOT DO IT.
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
