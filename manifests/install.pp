# == Class: tinc::install
#
# Installs tinc
#
class tinc::install {

  package { 'tinc':
    ensure => $::tinc::package_ensure,
    name   => $::tinc::package_name,
  }

}
