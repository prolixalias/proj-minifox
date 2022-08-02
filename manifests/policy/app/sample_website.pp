# @summary This profile installs a sample website

#
class minifox::policy::app::sample_website {
  case $facts['kernel'] {
    'windows': {
      include minifox::policy::app::sample_website::windows
    }
    'Linux': {
      include minifox::policy::app::sample_website::linux
    }
    default: {
      fail('Unsupported kernel detected')
    }
  }
}
