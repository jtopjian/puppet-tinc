# == Class: tinc::params
#
# OS/Distro-specific and general settings
#
class tinc::params {

  # OS/Distro-specific settings
  case $::osfamily {
    'Debian': {
      $keys_directory = '/var/lib/puppet/tinc/keys'
      $package_name   = 'tinc'
      $package_ensure = 'present'
      $service_name   = 'tinc'
      $service_ensure = 'running'
      $service_enable = 'true'
      $etcdir         = '/etc/tinc'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily}")
    }
  }

  # All other settings

  ## interfaces
  $interface        = 'eth0'
  $tunnel_interface = 'tun0'

}
