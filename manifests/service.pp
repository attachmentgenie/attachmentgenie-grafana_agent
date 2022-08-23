# Class to manage the grafana-agent service.
#
# @api private
class grafana_agent::service {
  if $grafana_agent::manage_service {
    case $grafana_agent::service_provider {
      'systemd': {
        ::systemd::unit_file { "${grafana_agent::service_name}.service":
          content => template('grafana_agent/grafana-agent.service.erb'),
          before  => Service['grafana-agent'],
        }
      }
      default: {
        fail("Service provider ${grafana_agent::service_provider} not supported")
      }
    }

    case $grafana_agent::install_method {
      'archive': {}
      'package': {
        Service['grafana-agent'] {
          subscribe => Package['grafana-agent'],
        }
      }
      default: {
        fail("Installation method ${grafana_agent::install_method} not supported")
      }
    }

    service { 'grafana-agent':
      ensure   => $grafana_agent::service_ensure,
      enable   => true,
      name     => $grafana_agent::service_name,
      provider => $grafana_agent::service_provider,
    }
  }
}
