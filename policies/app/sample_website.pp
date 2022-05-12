# @summary This profile installs a sample website
class policy::app::sample_website {

  case $::kernel {
    'windows': { include policy::app::sample_website::windows }
    'Linux':   { include policy::app::sample_website::linux }
    default:   {
      fail('Unsupported kernel detected')
    }
  }

}
