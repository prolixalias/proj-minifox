class policy::baseline::linux::vim {

  require git

  $users = {
    'root'  => '/root',
  }

  case getvar('facts.osfamily') {
    'Debian': {
      $vim = 'vim-nox'
    }
    default: {
      $vim = 'vim-enhanced'
    }
  }

  package { $vim:
    ensure => installed,
  }

  $users.each |$user, $homedir| {
    puppet_vim_env::install { "default vim for ${user}":
      homedir     => $homedir,
      owner       => $user,
      colorscheme => 'elflord',
    }
  }
}
