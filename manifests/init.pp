# mysql.pp
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.

class mysql::server ($mysql_tunning="false",$mysql_max_connections=100,$mysql_innodb_buffer_pool_size="2G",$mysql_data_dir="") {

	package { "mysql-server":
		ensure => installed,
	}
				
	# Use another data directory			
	if ( $mysql_data_dir != "" ) {
		# Copy the mysql system database
	 	file {
			"$mysql_data_dir/mysql" :
				ensure => directory,
				recurse => true,
				owner => "mysql",
				group => "mysql",
				source => "/var/lib/mysql/mysql",
				require => Package["mysql-server"];
		}
		# Configure mysql to use the new data directory
	    file {
	        "/etc/mysql/conf.d/relocation.cnf":
	            ensure  => file,
	            owner   => root,
	            group   => root,
	            mode    => 440,
	            content => template("${module_name}/relocation.cnf.erb"),
	            require => Package["mysql-server"],
	            notify => Service[mysql]
	    }
	    # On ubuntu update apparmor
        case $operatingsystem {
	      'ubuntu':  { 
			service { apparmor:
				ensure => running,
				hasstatus => true,
			}
		    file {
		        "/etc/apparmor.d/usr.sbin.mysqld":
		            ensure  => file,
		            owner   => root,
		            group   => root,
		            mode    => 644,
		            content => template("${module_name}/usr.sbin.mysqld.erb"),
		            require => Package["mysql-server"],
		            notify => Service["mysql","apparmor"]
			    }
		      }
		      default:  { } # apply the generic class
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
	            notify => Service[mysql]
	    }
    }

	service { mysql:
		ensure => running,
		hasstatus => true,
		require => Package["mysql-server"],
		subscribe  => [ Package["mysql-server"] ],
	}

    case $operatingsystem {
      'ubuntu':  { 
		    # mysql defaults
		    Mysql_database { defaults => "/etc/mysql/debian.cnf" }
		    Mysql_user { defaults => "/etc/mysql/debian.cnf" }
		    Mysql_grant { defaults => "/etc/mysql/debian.cnf" }	
      } # apply the debian class
      default:  { } # apply the generic class
    }

	# Collect all databases and users
	Mysql_database<<||>>
	Mysql_user<<||>>
	Mysql_grant<<||>>

}
