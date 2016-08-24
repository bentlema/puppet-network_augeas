# network_augeas

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with network_augeas](#setup)
    * [What network_augeas affects](#what-network_augeas-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with network_augeas](#beginning-with-network_augeas)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

A puppet module to manage network settings on a line-by-line basis (with Augeas) for RedHat flavors of Linux.

## Module Description

There are many network modules out there for fully managing your network
config on a RedHat/CentOS system (with templates).  My favorite is the
one by [example42](https://github.com/example42/puppet-network)

But what if you simply want to add a single line, or edit a single setting
within one of your ifcfg-ethX files, without giving full control over to
Puppet?  This module is an example of how you can accomplish this with Augeas.

This initial release simply allows you to add/edit the ETHTOOL_OPTS to your
interface config files in /etc/sysconfig/network-scripts

## Setup

### What network_augeas affects

* Interface config files in /etc/sysconfig/network-scripts/ifcfg-**name** will be edited
* The **NetworkManager** service will be disabled/stopped.
* The **network** service will be restarted if a change is made to an interface file

### Beginning with network_augeas

Just install the module like you normally do.

## Usage

### With Hiera

If you're using hiera_include()

```
  classes:
    - network_augeas
```

And then specify the interfaces_hash at the appropriate level in your hierarchy:

```
  network_augeas::interfaces_hash:
    eth0:
      ethtool_opts: '-G ${DEVICE} rx 1024 tx 2048'
```

### Not using Hiera?

```
  class { 'network_augeas':
    interfaces_hash = {
      eth0 => {
        ethtool_opts => '-G ${DEVICE} rx 1024 tx 2048'
      }
    }
  }
```


## Reference

The /etc/sysconfig/network-scripts/ifcfg-**iface** will be edited with augeas
on a per-line basis.  No existing lines will be removed.

Currently this module is only capable of adding/editing ETHTOOL_OPTS

If the ETHTOOL_OPTS is updated by Puppet, it will also restart the network service.

On RHEL7, the NetworkManager must not be enabled in order for the restart to properly
refresh the settings with ethtool.  (This is a RHEL7 issue, not Puppet.)

## Limitations

Supported on RHEL6 and RHEL7 only.

RHEL5 is not supported, as it doesn't properly deal with ETHTOOL_OPTS.

## Development

This module is a bit boring at this point, but I'd like to eventually get it to
the point of being able to edit any and every option you could possibly want
in your /etc/sysconfig/network and/or /etc/sysconfig/network-scripts files.

