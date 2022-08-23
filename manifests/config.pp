# Class to configure grafana_agent.
#
# @api private
#
# @see https://grafana.com/docs/agent/latest/configuration/
class grafana_agent::config {
  $config_file = '/etc/grafana-agent.yaml'

  concat { $config_file:
    ensure => present,
  }

  concat::fragment { 'agent_config_header':
    target  => $config_file,
    content => "---\n",
    order   => '01',
  }

  # Configures the server of the Agent used to enable self-scraping.
  # [server: <server_config>]
  #
  # https://grafana.com/docs/agent/latest/configuration/server-config/
  if $grafana_agent::server_config_hash {
    concat::fragment { 'grafana-agent_config_server':
      target  => $config_file,
      content => $grafana_agent::server_config_hash.promtail::to_yaml.promtail::strip_yaml_header,
      order   => '02',
    }
  }

  # Configures Prometheus instances.
  # [prometheus: <prometheus_config>]
  #
  # https://grafana.com/docs/agent/latest/configuration/prometheus-config/
  if $grafana_agent::prometheus_config_hash {
    concat::fragment { 'grafana-agent_config_prometheus':
      target  => $config_file,
      content => $grafana_agent::prometheus_config_hash.promtail::to_yaml.promtail::strip_yaml_header,
      order   => '03',
    }
  }

  # Configures loki instances.
  # [loki: <loki_config>]
  #
  # https://grafana.com/docs/agent/latest/configuration/loki-config/
  if $grafana_agent::loki_config_hash {
    concat::fragment { 'grafana-agent_config_loki':
      target  => $config_file,
      content => $grafana_agent::loki_config_hash.promtail::to_yaml.promtail::strip_yaml_header,
      order   => '04',
    }
  }

  # Configures tempo instances.
  # [tempo: <tempo_config>]
  #
  # https://grafana.com/docs/agent/latest/configuration/tempo-config/
  if $grafana_agent::tempo_config_hash {
    concat::fragment { 'grafana-agent_config_tempo':
      target  => $config_file,
      content => $grafana_agent::tempo_config_hash.promtail::to_yaml.promtail::strip_yaml_header,
      order   => '05',
    }
  }

  # Configures intergrations instances.
  # [intergrations: <intergrations_config>]
  #
  # https://grafana.com/docs/agent/latest/configuration/integrations/
  if $grafana_agent::intergrations_config_hash {
    concat::fragment { 'grafana-agent_config_intergrations':
      target  => $config_file,
      content => $grafana_agent::intergrations_config_hash.promtail::to_yaml.promtail::strip_yaml_header,
      order   => '06',
    }
  }

  if $grafana_agent::manage_service {
    Concat[$config_file] ~> Service['grafana-agent']
  }
}
