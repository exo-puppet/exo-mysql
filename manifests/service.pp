# Class: mysql::service
#
# This class manage the mysql service
class mysql::service {
	service { "mysql" :
		ensure     => running,
		name       => $mysql::params::service_name,
		hasstatus  => false,
		hasrestart => false,
#        require => [ Class[ "mysql::install", "mysql::config" ], Exec [ "mysql-clean-logs"] ],
        require => [ Class[ "mysql::install", "mysql::config" ] ],
        start       => "rm -f ${mysql::params::db_data_dir}/ib_logfile*; /etc/init.d/mysql start"
	}
}
