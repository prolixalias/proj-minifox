class policy::app::puppetdev {

  case $::kernel {

    'windows': {
      contain ::policy::app::puppetdev::windows
    }

    'Linux': {
      contain ::policy::app::puppetdev::linux
    }

    default: {
      fail('Unsupported OS')
    }

  }

}
