# == Class: tinc::service
#
# Manages the tinc service
#
class tinc::service {

  service { 'tinc':
    ensure  => $::tinc::service_ensure,
    enable  => $::tinc::service_enable,
    name    => $::tinc::service_name,
    status  => '/usr/bin/pgrep tinc',
    require => Package['tinc']
  }

}
