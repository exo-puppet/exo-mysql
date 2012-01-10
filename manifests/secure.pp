class mysql::secure {
    #########################################
    # mysql_secure_installation steps
    #########################################
    # 1 - root MUST have a password
    mysql_user{ ["root@localhost", "root@127.0.0.1" ]:
        password_hash   => mysql_password($mysql::params::mysql_root_password),
        ensure          => present,
        require => [ File["my.cnf"], Service [ $mysql::params::service_name ] ],
#        require => defined ( Apparmor::Define [ "usr.sbin.mysqld" ] ) ? {
#            true    => [ File["my.cnf"], Service [ $mysql::params::service_name ], ],
#            default => [ File["my.cnf"], Apparmor::Define [ "usr.sbin.mysqld"], Class [ "mysql::install", "mysql::config", "mysql::service" ] ],
#        }, 
    }

    mysql_grant { "root@localhost": 
        privileges  => all,
        require => [ File["my.cnf"], Service [ $mysql::params::service_name ] ],
#        require => defined ( Apparmor::Define [ "usr.sbin.mysqld" ] ) ? {
#            true    => [ File["my.cnf"], Service [ $mysql::params::service_name ], ],
#            default => [ File["my.cnf"], Apparmor::Define [ "usr.sbin.mysqld"], Class [ "mysql::install", "mysql::config", "mysql::service" ] ],
#        }, 
    }
    
    # 2 - remove anonymous user
    mysql_user{ "@%":
        ensure  => absent,
        require => [ File["my.cnf"], Service [ $mysql::params::service_name ] ],
#        require => defined ( Apparmor::Define [ "usr.sbin.mysqld" ] ) ? {
#            true    => [ File["my.cnf"], Service [ $mysql::params::service_name ], ],
#            default => [ File["my.cnf"], Apparmor::Define [ "usr.sbin.mysqld"], Class [ "mysql::install", "mysql::config", "mysql::service" ] ],
#        }, 
    }
    
    
    # 3 - root MUST NOT be usable from remote host
    mysql_user{ [ "root@${::fqdn}", "root@${::hostname}", "root@%" ]:
        ensure  => absent,
        require => [ File["my.cnf"], Service [ $mysql::params::service_name ] ],
#        require => [ File["my.cnf"], Class [ "mysql::install", "mysql::config", "mysql::service" ] ],
#        require => defined ( Apparmor::Define [ "usr.sbin.mysqld" ] ) ? {
#            true    => [ File["my.cnf"], Service [ $mysql::params::service_name ], ],
#            default => [ File["my.cnf"], Apparmor::Define [ "usr.sbin.mysqld"], Class [ "mysql::install", "mysql::config", "mysql::service" ] ],
#        }, 
    }
    
    
    # 4 - remove de TEST database 
    mysql_database { "test": 
        ensure  => absent, 
        require => [ File["my.cnf"], Service [ $mysql::params::service_name ] ],
#        require => defined ( Apparmor::Define [ "usr.sbin.mysqld" ] ) ? {
#            true    => [ File["my.cnf"], Service [ $mysql::params::service_name ], ],
#            default => [ File["my.cnf"], Apparmor::Define [ "usr.sbin.mysqld"], Class [ "mysql::install", "mysql::config", "mysql::service" ] ],
#        }, 
    }
}