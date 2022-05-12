class policy::compliance::hipaa {

  case $::osfamily {
    'windows': {
      include policy::compliance::hipaa::windows
    }
    default: {
      include policy::compliance::hipaa::linux
    }
  }
}
