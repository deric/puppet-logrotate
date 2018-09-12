# Internal: Configure a host for hourly logrotate jobs.
#
# ensure - The desired state of hourly logrotate support.  Valid values are
#          'absent' and 'present' (default: 'present').
#
# Examples
#
#   # Set up hourly logrotate jobs
#   include logrotate::hourly
#
#   # Remove hourly logrotate job support
#   class { 'logrotate::hourly':
#     ensure => absent,
#   }
class logrotate::hourly (
  Enum['present','absent'] $ensure = 'present'
) {

  $manage_cron_hourly = $::logrotate::manage_cron_hourly

  $dir_ensure = $ensure ? {
    'absent'  => $ensure,
    'present' => 'directory'
  }

  file { "${logrotate::rules_configdir}/hourly":
    ensure => $dir_ensure,
    owner  => 'root',
    group  => 'root',
    mode   => $logrotate::rules_configdir_mode,
  }

  if $manage_cron_hourly {
    logrotate::cron { 'daily': 
      ensure  => $ensure,
      require => File["${logrotate::rules_configdir}/hourly"],
    }
  }

}
