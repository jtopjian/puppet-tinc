# puppet-tinc

A module to create one or more [tinc](http://www.tinc-vpn.org)-based VPN tunnels.

Each tunnel can support multiple IP addresses.

## Usage

### Hiera

Add something like the following to Hiera:

#### `/etc/puppet/hieradata/nodes/server1.yaml`

```yaml
site::tinc::tunnel1::ip: '192.168.175.1/24'
site::tinc::tunnel1::port: 655
site::tinc::tunnel2::ip: '10.101.0.1/24'
site::tinc::tunnel2::port: 656
site::tinc::tunnel3::ip: '192.168.171.1/24'
site::tinc::tunnel3::port: 657
```

#### `/etc/puppet/hieradata/nodes/server2.yaml`

```yaml
site::tinc::tunnel1::ip: '192.168.175.2/24'
site::tinc::tunnel1::port: 655
site::tinc::tunnel2::ip: '10.101.0.2/24'
site::tinc::tunnel2::port: 656
site::tinc::tunnel3::ip: '192.168.171.2/24'
site::tinc::tunnel3::port: 657
```

### Puppet

Now create a profile like this:

```puppet
class site::profiles::tinc::tunnels {

  # Hiera
  $interface    = hiera('network::external::device')
  $tunnel1_ip   = hiera('site::tinc::tunnel1::ip')
  $tunnel1_port = hiera('site::tinc::tunnel1::port')
  $tunnel2_ip   = hiera('site::tinc::tunnel2::ip')
  $tunnel2_port = hiera('site::tinc::tunnel2::port')
  $tunnel3_ip   = hiera('site::tinc::tunnel3::ip')
  $tunnel3_port = hiera('site::tinc::tunnel3::port')

  class { '::tinc': }

  tinc::tunnel { 'tunnel1':
    interface     => $interface,
    tunnel_device => 'tun0',
    port          => $tunnel1_port,
    ip_addresses  => [$tunnel1_ip],
  }

  tinc::tunnel { 'tunnel2':
    interface     => $interface,
    tunnel_device => 'tun1',
    port          => $tunnel2_port,
    ip_addresses  => [$tunnel2_ip],
  }

  tinc::tunnel { 'tunnel3':
    interface     => $interface,
    tunnel_device => 'tun2',
    port          => $tunnel3_port,
    ip_addresses  => [$tunnel3_ip],
  }

}
```

## Limitations

You currently have to edit the module directly in order to add new options to `tinc`. Being able to specify arbitrary options through a parameter would be nice.

## Credits

This module is essentially a full rewrite of [l2mesh](https://github.com/sathlan/l2mesh). The `tinc_keygen` function that is included in this module was copied from there. The original copyright and LICENSE is retained.
