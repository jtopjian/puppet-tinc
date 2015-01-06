# == Class: tinc
#
# A Puppet module to create one or more tinc-based VPN tunnels.
#
# === Parameters:
#
# [*package_name*]
#   The name of the `tinc` package.
#
# [*package_ensure*]
#   The `ensure` status of the package.
#
# [*service_name*]
#   The name of the `tinc` service.
#
# [*service_ensure*]
#   The `ensure` status of the service.
#
# [*service_enable*]
#   The `enable` status of the service.
#
# [*etcdir*]
#   The /etc directory for tinc.
#
class tinc (
  $package_name   = $tinc::params::package_name,
  $package_ensure = $tinc::params::package_ensure,
  $service_name   = $tinc::params::service_name,
  $service_ensure = $tinc::params::service_ensure,
  $service_enable = $tinc::params::service_enable,
  $etcdir         = $tinc::params::etcdir,
) inherits tinc::params {

  # includes
  include concat::setup

  anchor { 'tinc::start': } ->
  class { 'tinc::install': } ->
  class { 'tinc::config': } ->
  class { 'tinc::keys': } ->
  class { 'tinc::service': } ->
  anchor { 'tinc::end': }

}
