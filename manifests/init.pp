# mysql.pp
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.

class mysql::server ($mysql_profile="") {

	package { "mysql-server":
		ensure => installed,
	}

 	file {
		"/home/mysql" :
			ensure => directory,
			require => Package["mysql-server"],
			owner => "mysql",
			group => "mysql";
	}
 	file {
		"/home/mysql/mysql" :
			ensure => directory,
			recurse => true,
			replace => false,
			require => File["/home/mysql"],
			owner => "mysql",
			group => "mysql",
			source => "/var/lib/mysql/mysql";
	}
				
	if ( $mysql_profile != "" ) {		
	    file {
	        "/etc/mysql/conf.d/${mysql_profile}.cnf":
	            owner   => root,
	            group   => root,
	            mode    => 440,
	            source  => "puppet:///modules/mysql/${mysql_profile}.cnf",
	            require => Package["mysql-server"],
	            ensure  => file,
	    }
    }

	service { mysql:
		ensure => running,
		hasstatus => true,
		require => Package["mysql-server"],
		subscribe  => [ Package["mysql-server"], File["/etc/mysql/conf.d/${mysql_profile}.cnf"], File["/home/mysql/mysql"] ],
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
