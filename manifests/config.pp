# == Class: tinc::config
#
# Configures tinc
#
class tinc::config {

  concat { "${::tinc::etcdir}/nets.boot":
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    notify  => Service['tinc'],
    require => Package['tinc'],
  }

}
