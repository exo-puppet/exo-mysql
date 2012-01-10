# Class: mysql::install
#
# This class manage the installation of the ntp package
class mysql::install {
    require mysql::params
    
    file { "/etc/mysql":
        ensure  => directory,
        path    => $mysql::params::config_dir,
        owner   => root,
        group   => root,
        mode    => 0755,
        notify  => Class["mysql::service"],
    }
    
    #########################################
    # We write the root my.cnf configuration file with a generated password
    #########################################
    #$mysql_root_password = mysql_root_password("${mysql::params::config_dir_user_root}/${mysql::params::config_file_user_root}")
#    notice("MySQL Root Password in install [$mysql::params::mysql_root_password]")    
    file { "root-my.cnf":
        ensure  => present,
        path    => "${mysql::params::config_dir_user_root}/${mysql::params::config_file_user_root}",
        owner   => root,
        group   => root,
        mode    => 0600,
        content => template("mysql/$mysql::params::config_template_user_root"),
#        notify  => Class["mysql::service"],
    }
    
    #########################################
    # Install MySQL package
    #########################################
    repo::package { "mysql":
        pkg     => $mysql::params::package_name,
        preseed => template("mysql/mysql-server-5.1.preseed.erb"),
        require => File [ "/etc/mysql", "root-my.cnf" ],
    }

    package { $mysql::params::additional_package_name:
        ensure  => present,
        require => Repo::Package [ "mysql" ],
    }

    #########################################
    # specific stuff when mysql datadir is not the standard one
    #########################################
    if ( "$mysql::params::db_data_dir" != "$mysql::params::standard_db_data_dir" ) {
        Exec { path => "/bin:/sbin:/usr/bin:/usr/sbin" }
        # the required directory must exists
        file { "specific-/var/lib/mysql":
            ensure  => directory,
            path    => $mysql::params::db_data_dir,
            owner   => $mysql::params::mysql_user,
            group   => $mysql::params::mysql_group,
            mode    => 0700,
#            recurse => true,
            require => Repo::Package [ "mysql" ],
            notify  => [ Class["mysql::service"] ],
        } 
        exec {"copy-mysql-data":
            command     => "cp -rp ${mysql::params::standard_db_data_dir}/* ${mysql::params::db_data_dir}/", 
            unless      => "test -d ${mysql::params::db_data_dir}/mysql",
            notify      => [ Class["mysql::service"] ],
            require     => File [ "specific-/var/lib/mysql" ],
        }
        exec { "rename-old-mysql-data":
            command     => "mv ${mysql::params::standard_db_data_dir} ${mysql::params::standard_db_data_dir}-ORI",
            unless      => "test -h ${mysql::params::standard_db_data_dir} -o ! -d ${mysql::params::standard_db_data_dir} -o -d ${mysql::params::standard_db_data_dir}-ORI",
            notify      => [ File [ "symlink-/var/lib/mysql" ], Class["mysql::service"] ],
            require     => Exec [ "copy-mysql-data" ],
        } 
        # Create a symlink
        file {"symlink-/var/lib/mysql":
            path    => $mysql::params::standard_db_data_dir,
            ensure  => symlink,
            owner   => $mysql::params::mysql_user,
            group   => $mysql::params::mysql_group,
            target  => $mysql::params::db_data_dir,
            require => [ File[ "specific-/var/lib/mysql" ], Exec ["copy-mysql-data", "rename-old-mysql-data" ] ],
            notify  => Class["mysql::service"],
        }
    }
    
}
