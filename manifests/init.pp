# == Class: network_augeas
#
# A Puppet module to manage individual lines in your network config files within /etc/sysconfig/network-scripts
#
# The initial module was written for the sole purpose of being able to set various ETHTOOL_OPTS without affecting
# existing lines in the ifcfg-ethX.
#
#
# === Parameters
#
# Document parameters here.
#
# [*interfaces_hash*]
#   Defaults to undef
#   Takes a hash of hashes
#   1st-level hash key is interface name (Such as 'eth0')
#   2nd-level hash corresponds to the options that go in the ifcfg-ethX file
#
#
# === Variables
#
# None.
#
# === Examples
#
#  class { 'network_augeas':
#    interfaces_hash = { eth0 => { ethtool_opts => '-G ${DEVICE} rx 1024 tx 2048' }},
#  }
#
#
# === Example in Hiera Data
#
#  network_augeas:
#    eth0:
#      ethtool_opts: '-G ${DEVICE} rx 1024 tx 2048'
#
#
# === Authors
#
# Mark A. Bentley <bentlema@yahoo.com>
#
# === Copyright
#
# Copyright 2016 Mark Bentley, unless otherwise noted.
#
class network_augeas (

  $interfaces_hash = undef,

) {

  validate_hash($interfaces_hash)

  case $::operatingsystemmajrelease {
    '6','7': {

      service { 'NetworkManager':
        ensure => 'stopped',
        enable => false,
      }

      service { 'network':
        ensure => 'running',
        enable => true,
      }
    }
    default: {
      notify{"Not supported on ${::osfamily} release ${::operatingsystemmajrelease}":}
    }
  }

  create_resources('network_augeas::interface', $interfaces_hash)

}
