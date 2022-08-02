#

#
class minifox::policy::app::cloudshop {
  case $facts['kernel'] {
    'windows': {
      include minifox::policy::app::cloudshop::sqlserver::init
      include minifox::policy::app::cloudshop::webapp::db
      include minifox::policy::app::cloudshop::webapp::init
    }
    default: {
      fail('Unsupported OS')
    }
  }
}
