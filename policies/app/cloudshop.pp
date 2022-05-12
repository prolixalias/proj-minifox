class policy::app::cloudshop {

  case $::kernel {
    'windows': {
      include policy::app::cloudshop::sqlserver::init
      include policy::app::cloudshop::webapp::db
      include policy::app::cloudshop::webapp::init
    }
    default: {
      fail('Unsupported OS')
    }
  }

}
