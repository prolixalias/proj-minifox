class policy::baseline::linux::ssh (
  String $permit_root_login = 'no',
) {

  class { 'ssh':
    permit_root_login      => $permit_root_login,
    purge_keys             => false,
    sshd_config_print_motd => 'no',
  }

  firewall { '100 ssh allow all':
    dport  => '22',
    chain  => 'INPUT',
    proto  => 'tcp',
    action => 'accept',
  }

}
