# Class: mysql::config
#
# This class manage the mysql configuration
class mysql::config {
  # TODO Check and raise an alert if the calculated MySQL maximum memory usage is over the total system memory
  #    $system_memory = sys_memory()
  #    $max_memory_to_use = mysql_max_memory_to_use()
  #    info ("MYSQL SYSTEM Max Memory to use : ${max_memory_to_use}")
  # Exec { path => "/bin:/sbin:/usr/bin:/usr/sbin" }
  file { 'my.cnf':
    ensure  => present,
    path    => "${mysql::params::config_dir}/${mysql::params::config_file}",
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template("mysql/${mysql::params::config_template}"),
    require => Class['mysql::install'],
    #        notify  => [ Exec [ "mysql-clean-logs"], Class["mysql::service"] ],
    notify  => [
      Class['mysql::service']],
  }

  #    exec {"mysql-clean-logs":
  #        command     => "rm -f ${mysql::params::db_data_dir}/ib_logfile*",
  #        path        => "/bin:/sbin:/usr/bin:/usr/sbin",
  #        refreshonly => true,
  #        require     => [ File[ "my.cnf" ] ],
  #        notify      => [ Class["mysql::service"] ],
  #    }

  #########################################
  # Configure apparmor for custom data directory
  #########################################
  if ($mysql::params::db_data_dir != $mysql::params::standard_db_data_dir) {
    apparmor::define { 'usr.sbin.mysqld':
      main_content  => template("mysql/${mysql::params::apparmor_main_template}"),
      local_content => template("mysql/${mysql::params::apparmor_local_template}"),
      require       => [
        Class['apparmor', 'mysql::install'],
        File['my.cnf']],
      notify        => Class['mysql::service'],
    }
  }
}

