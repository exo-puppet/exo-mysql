# Class: mysql::userconfig
#
# This class manage .my.cnf creation for a particular user.
# All files are created in the MySQL configuration directory with special read right for the user only (400).
# The file could be use with the following syntax : mysqladmin --defaults-file=/etc/mysql/zabbix-my.cnf
#
# == Parameters
# 
# [+username+]
#   (REQUIRED) 
#   
#   the system username for which we want to create a MySQL Client Connection configuration file
#
# [+mysql_username+]
#   (REQUIRED) 
#   
#   The mysql username to use
#
# [+mysql_password+]
#   (REQUIRED) 
#   
#   The mysql password to use
#
define mysql::userconfig ($username, $mysql_username, $mysql_password) {

    file { "${username}-my.cnf":
        ensure  => present,
        path    => "${mysql::params::config_dir}/${username}-my.cnf",
        owner   => $username,
        group   => root,
        mode    => 0400,
        content => template("mysql/user-xxxx.cnf.erb"),
        require => Class["mysql::install"],
    }
    	
}

