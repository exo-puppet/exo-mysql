# mysql.pp
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.

class mysql::server ($mysql_data_dir="/var/lib/mysql",$mysql_tunning="false",$mysql_max_connections=100,$mysql_innodb_buffer_pool_size="2G",$mysql_bind_address="127.0.0.1",$mysql_timezone="Europe/Paris") {

	package { "mysql-server":
		ensure => installed,
	}
				
	# Use another data directory			
	if ( $mysql_data_dir != "/var/lib/mysql" ) {
		Exec { path => "/bin:/sbin:/usr/bin:/usr/sbin" }
		# Create the new directory
		file {"$mysql_data_dir":
            ensure => directory,
            owner   => mysql,
            group   => mysql,
            recurse => true,
			require => [Package["mysql-server"]],
        }		
		# Move the mysql database
		exec{"move-mysql-db":
			command => "mv /var/lib/mysql/mysql $mysql_data_dir", 
			require => [File["$mysql_data_dir"]],
			onlyif => "test ! -d $mysql_data_dir/mysql",
			refreshonly => true,
		}
		# Rename the original directory
		exec{"rename-mysql-dir":
			command => "mv /var/lib/mysql /var/lib/mysql.ori",
			onlyif => "test (! -h /var/lib/mysql) -a (-d /var/lib/mysql) -a (! -d /var/lib/mysql.ori)", 
			require => [Exec["move-mysql-db"]],
			refreshonly => true,
		}		
		# Create a symlink
		file {"/var/lib/mysql":
            ensure => symlink,
            owner   => mysql,
            group   => mysql,
            target => "$mysql_data_dir",
            require => [Exec["rename-mysql-dir"]],
        }
        # On ubuntu update apparmor
        case $operatingsystem {
             'ubuntu':  { 
                   file {
                       "/etc/apparmor.d/usr.sbin.mysqld":
                           ensure  => file,
                           owner   => root,
                           group   => root,
                           mode    => 644,
                           content => template("${module_name}/usr.sbin.mysqld.erb"),
                           require => [Package["mysql-server"],Exec["move-mysql-db"]],
                           notify => Service["apparmor"]
                   }
                   service { apparmor:
                           ensure => running,
                           hasstatus => true,
                   }                   
              }
              default:  { 
              } # apply the generic class
        }
        # Configure mysql to use the new data directory
        file {
            "/etc/mysql/conf.d/relocation.cnf":
               ensure  => file,
               owner   => root,
               group   => root,
               mode    => 440,
               content => template("${module_name}/relocation.cnf.erb"),
               require => [File["/var/lib/mysql"],File["/etc/apparmor.d/usr.sbin.mysqld"]],
        }        
    }
	if ( $mysql_tunning == "true" ) {		
	    file {
	        "/etc/mysql/conf.d/tunning.cnf":
	            ensure  => file,
	            owner   => root,
	            group   => root,
	            mode    => 440,
	            content => template("${module_name}/tunning.cnf.erb"),
	            require => Package["mysql-server"],
	    }
		# Remove log file as we maybe changed the size
		exec{"remove-log":
			command => "rm $mysql_data_dir/ib_logfile*",
			require => [File["/etc/mysql/conf.d/tunning.cnf"]],
			refreshonly => true,
			}
    }

	service { mysql:
		ensure => running,
		hasstatus => true,
		require => [Package["mysql-server"],File["/etc/mysql/conf.d/tunning.cnf"],File["/var/lib/mysql"]],
	}

	# Collect all databases and users
	Mysql_database<<||>>
	Mysql_user<<||>>
	Mysql_grant<<||>>

}
