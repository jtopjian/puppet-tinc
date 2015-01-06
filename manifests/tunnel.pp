# == Defined Type: tinc::tunnel
#
# Creates an L2 tunnel
#
# === Paramters:
#
# [*interface*]
#   The interface to bind to.
#
# [*tunnel_device*]
#   The tunnel device to crate. Ex: `tun0`.
#
# [*port*]
#   The port to run tinc on.
#
# [*ip_addresses*]
#   An array of IP addresses that will be added to `tunnel_device`.
#
define tinc::tunnel (
  $interface,
  $tunnel_device,
  $port,
  $ip_addresses  = [],
) {

  include concat::setup

  $root = "${::tinc::etcdir}/${name}"
  $ip   = getvar("::ipaddress_${interface}")
  $fqdn = regsubst($::fqdn, '[._-]+', '', 'G')

  concat::fragment { "net.boots ${name}":
    target  => "${::tinc::etcdir}/nets.boot",
    content => "${name}\n",
  }

  file { $root:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    require => Package['tinc'],
  }

  file { "${root}/hosts":
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    require => File[$root],
  }

  $keys = tinc_keygen("${::tinc::params::keys_directory}/${::fqdn}")
  $public_key = $keys[1]

  @@file { "${root}/hosts/${fqdn}":
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    tag     => "tinc_host_${name}",
    content => "Address = ${ip}
Port = ${port}
Compression = 0

${public_key}
",
    notify  => Service['tinc'],
    require => Package['tinc'],
  }

  File<<| tag == "tinc_host_${name}" |>>

  concat { "${name}_tinc-up":
    path    => "${root}/tinc-up",
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    notify  => Service['tinc'],
    require => File[$root],
  }

  concat::fragment { "${name} tinc-up header":
    target  => "${name}_tinc-up",
    order   => '01',
    content => "#!/bin/bash\n",
  }

  $ip_addresses.each |$ip| {
    concat::fragment { "${name} tinc-up ${ip}":
      target  => "${name}_tinc-up",
      order   => '02',
      content => "ip addr add ${ip} dev ${tunnel_device}\n",
    }
  }

  concat::fragment { "${name} tinc-up footer":
    target  => "${name}_tinc-up",
    order   => '03',
    content => "ip link set ${tunnel_device} up\n",
  }

  concat { "${name}_tinc-down":
    path    => "${root}/tinc-down",
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    notify  => Service['tinc'],
    require => File[$root],
  }

  concat::fragment { "${name} tinc-down header":
    target  => "${name}_tinc-down",
    order   => '01',
    content => "#!/bin/bash\n",
  }

  $ip_addresses.each |$ip| {
    concat::fragment { "${name} tinc-down ${ip}":
      target  => "${name}_tinc-down",
      order   => '02',
      content => "ip addr del ${ip} dev ${tunnel_device}\n",
    }
  }

  concat::fragment { "${name} tinc-down footer":
    target  => "${name}_tinc-down",
    order   => '03',
    content => "ip link set ${tunnel_device} down\n",
  }

  concat { "${name}_tinc.conf":
    path    => "${root}/tinc.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    notify  => Service['tinc'],
    require => File[$root],
  }

  concat::fragment { "${name} tinc.conf header":
    target  => "${name}_tinc.conf",
    order   => '01',
    content => "Name = ${fqdn}
BindToAddress = ${ip} ${port}
AddressFamily = ipv4
Interface = ${tunnel_device}
Mode = switch
PrivateKeyFile = ${::tinc::etcdir}/key/rsa_key.priv
",
  }

  @@concat::fragment { "tinc_connect_${name}_${fqdn}":
    target  => "${name}_tinc.conf",
    tag     => $::fqdn,
    content => "ConnectTO = ${fqdn}\n",
  }

  Concat::Fragment <<| target == "${name}_tinc.conf" and tag != $::fqdn |>>

}
