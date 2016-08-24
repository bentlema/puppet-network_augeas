define network_augeas::interface (

  # String of arguments that will be given to ethtool
  # Separate multiple sets of arguments with a semi-colon
  $ethtool_opts = '',

) {

  validate_string($ethtool_opts)

  # We do some funky quoting to make augeas happy
  $quoted_opts = "\'\"${ethtool_opts}\"\'"

  # Initially we support only the ETHTOOL_OPTS, so no inteligence here
  $augeas_command = "set ETHTOOL_OPTS ${quoted_opts}"

  augeas{"set_ethtool_opts_for_${name}":
    notify  => Service['network'],
    context => "/files/etc/sysconfig/network-scripts/ifcfg-${name}",
    changes => [ ${augeas_command} ],
  }

}

