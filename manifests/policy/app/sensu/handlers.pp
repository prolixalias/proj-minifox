#

# @param [Array] mailer_to
#   xxx
# @param [String] hipchat_apikey
#   xxx
# @param [String] hipchat_from
#   xxx
# @param [String] hipchat_message_template
#   xxx
# @param [String] hipchat_room
#   xxx
# @param [String] hipchat_url
#   xxx
# @param [String] mailer_from
#   xxx

#
class minifox::policy::app::sensu::handlers (
  Array  $mailer_to,
  String $hipchat_apikey,
  String $hipchat_from,
  String $hipchat_message_template,
  String $hipchat_room,
  String $hipchat_url,
  String $mailer_from,
) {
  package { 'mailx':
    ensure   => 'present',
    provider => 'yum',
  }

  sensu::handler { 'default':
    type     => 'set',
    handlers => ['stdout', 'mailer', 'hipchat'],
  }

  sensu::handler { 'stdout':
    type    => 'pipe',
    command => 'cat',
  }

  sensu::handler { 'mailer':
    type    => 'pipe',
    command => 'handler-mailer.rb',
    config  => {
      admin_gui => "http://${facts['networking']['fqdn']}:3000",
      mail_from => $mailer_from,
      mail_to   => $mailer_to,
    },
    filters => ['state-change-only'],
  }

  file { '/opt/sensu_template.erb':
    ensure  => 'file',
    content => $hipchat_message_template,
    replace => 'no',
    mode    => '0644',
  }

  sensu::handler { 'hipchat':
    command => 'handler-hipchat.rb',
    config  => {
      'server_url'       => $hipchat_url,
      'apikey'           => $hipchat_apikey,
      'apiversion'       => 'v2',
      'room'             => $hipchat_room,
      'from'             => $hipchat_from,
      'message_template' => '/opt/sensu_template.erb',
    },
    filters => ['state-change-only'],
  }

  sensu::filter { 'state-change-only':
    negate     => false,
    attributes => {
      occurrences => "eval: value == 1 || ':::action:::' == 'resolve'",
    },
  }
}
