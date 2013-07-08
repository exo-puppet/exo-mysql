# Class: mysql::params
#
# This class manage the mysql parameters for different OS
class mysql::params {
  $ensure_mode = $mysql::lastversion ? {
    true    => latest,
    default => present
  }
  # notify { "mysql ensure mode = $ensure_mode": withpath => false }
  info("mysql ensure mode = ${ensure_mode}")

  case $::operatingsystem {
    /(Ubuntu)/: {
      case $::lsbdistrelease {
        /(10.04|10.10|11.04|11.10|12.04)/: {
          case $::lsbdistrelease {
            /(10.04|10.10|11.04|11.10)/: {
              $package_name               = 'mysql-server-5.1'
            }
            /(12.04)/: {
              $package_name               = 'mysql-server-5.5'
            }
          }

          $additional_package_name    = [ 'mysqltuner' ]
          $service_name               = 'mysql'
          $mysql_user                 = 'mysql'
          $mysql_group                = 'mysql'

          $config_dir                 = '/etc/mysql'
          $config_file                = 'my.cnf'
          $config_template            = 'my.cnf.debian.erb'
          $config_dir_extensions      = '/etc/mysql/conf.d'

          $standard_sock_path         = '/var/run/mysqld/mysqld.sock'
          $sock_path                  = $mysql::sock_path ? {
            false   => $standard_sock_path,
            default => $mysql::sock_path,
          }

          $temp_dir                   = $mysql::temp_dir ? {
            false   => '/tmp',
            default => $mysql::temp_dir,
          }

          $config_dir_user_root       = '/root'
          $config_file_user_root      = '.my.cnf'
          $config_template_user_root  = 'user-root.cnf.erb'

          $debian_username            = 'debian-sys-maint'
          $config_dir_user_debian     = $config_dir
          $config_file_user_debian    = 'debian.cnf'
          $config_template_user_debian= 'user-debian.cnf.erb'

          $standard_db_data_dir       = '/var/lib/mysql'
          $db_data_dir    = $mysql::data_dir ? {
            false => $standard_db_data_dir,
            default => $mysql::data_dir,
          }

          # $mysql_root_password        = mysql_root_password("${mysql::params::config_dir_user_root}/${mysql::params::config_file_user_root}")
          $mysql_root_password        = $::mysql_root_password ? {
            false => mysql_random_password(16),
            default => $::mysql_root_password,
          }
          info ("MySQL root password from params : [${mysql_root_password}]")

          $apparmor_main_template     = [ "apparmor/main-usr.sbin.mysqld.${::operatingsystem}-${::lsbdistrelease}.erb" ]
          $apparmor_local_template    = [ "apparmor/local-usr.sbin.mysqld.${::operatingsystem}.erb" ]

          Mysql_database  { defaults => "${config_dir}/${config_file_user_debian}" }
          Mysql_user      { defaults => "${config_dir}/${config_file_user_debian}" }
          Mysql_grant     { defaults => "${config_dir}/${config_file_user_debian}" }

        }
        default: {
          fail ("The ${module_name} puppet module is not (yet) supported on ${::operatingsystem} ${::operatingsystemrelease}")
        }
      }
    }
    default: {
      fail ("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }
}
