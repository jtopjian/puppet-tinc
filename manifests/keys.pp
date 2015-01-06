# == Class: tinc::keys
#
# Generates a public/private keypair for a node
#
class tinc::keys {

  include tinc::params

  $keydir = "${::tinc::etcdir}/key"

  $private = "${keydir}/rsa_key.priv"
  $public = "${keydir}/rsa_key.pub"

  $keys = tinc_keygen("${::tinc::params::keys_directory}/${::fqdn}")
  $private_key = $keys[0]
  $public_key = $keys[1]

  file { $keydir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    require => Package['tinc'],
  }

  file { $private:
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => $private_key,
    notify  => Service['tinc'],
    require => File[$keydir],
  }

  file { $public:
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => $public_key,
    notify  => Service['tinc'],
    require => File[$keydir],
  }

}
