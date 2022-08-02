#

#
class minifox::policy::baseline::windows::motd {
  $default_motd = @("MOTD"/L)
    ===========================================================

          Welcome to ${facts['networking']['hostname']}

    Access  to  and  use of this server is  restricted to those
    activities expressly permitted by the system administration
    staff. If  you're not  sure if it's  allowed, DO NOT DO IT.

    ===========================================================

    The operating system is: ${facts['os']['name']}
                  Domain is: ${facts['networking']['domain']}

    | MOTD

  # Check if we have a hiera override for the MOTD, otherwise use the default
  $message = lookup('motd', default_value => $default_motd)

  registry_value { '32:HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\policies\system\legalnoticecaption':
    ensure => present,
    type   => string,
    data   => 'Message of the day',
  }

  registry_value { '32:HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\policies\system\legalnoticetext':
    ensure => present,
    type   => string,
    data   => $message,
  }
}
