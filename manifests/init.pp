# Class to install and configure grafana-agent.
#
# Use this module to install and configure grafana-agent.
#
# @example Declaring the class
#   include ::grafana_agent
#
# @param group Group that owns grafana-agent files and processes.
# @param install_dir Location of grafana-agent binary release.
# @param install_method How to install grafana-agent.
# @param manage_repo Manage the grafana-agent repo.
# @param manage_service Manage the grafana-agent service.
# @param manage_user Manage grafana-agent user and group.
# @param package_name Name of package to install.
# @param package_version Version of grafana-agent to install.
# @param service_name Name of service to manage.
# @param service_provider Init system that is used.
# @param service_ensure The state of the service.
# @param user User that owns grafana-agent files and processes.
# @param version Which version grafana-agent will be installed.
# @param intergrations_config_hash Configuration specific to the integrations section.
# @param loki_config_hash Configuration specific to the loki section.
# @param prometheus_config_hash Configuration specific to the loki section.
# @param server_config_hash Configuration specific to the server section.
# @param tempo_config_hash Configuration specific to the server section
#
# @see https://grafana.com/docs/agent/latest/configuration/ 
class grafana_agent (
  String[1] $group,
  Stdlib::Absolutepath $install_dir,
  Enum['archive','package'] $install_method ,
  Boolean $manage_repo,
  Boolean $manage_service,
  Boolean $manage_user,
  String[1] $package_name,
  String[1] $package_version,
  String[1] $service_name,
  String[1] $service_provider,
  Enum['running','stopped'] $service_ensure,
  String[1] $user,
  String[1] $version,
  Optional[Hash] $intergrations_config_hash = undef,
  Optional[Hash] $loki_config_hash = undef,
  Optional[Hash] $prometheus_config_hash = undef,
  Optional[Hash] $server_config_hash = undef,
  Optional[Hash] $tempo_config_hash = undef,
) {
  contain 'grafana_agent::install'
  contain 'grafana_agent::config'
  contain 'grafana_agent::service'

  Class['grafana_agent::install']
  -> Class['grafana_agent::config']
  ~> Class['grafana_agent::service']
}
