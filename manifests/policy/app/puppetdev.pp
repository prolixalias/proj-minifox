#

#
class minifox::policy::app::puppetdev {
  case $facts['kernel'] {
    'windows': {
      contain minifox::policy::app::puppetdev::windows
    }
    'Linux': {
      contain minifox::policy::app::puppetdev::linux
    }
    default: {
      fail('Unsupported OS')
    }
  }
}
