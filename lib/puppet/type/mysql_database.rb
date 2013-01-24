# This has to be a separate type to enable collecting
Puppet::Type.newtype(:mysql_database) do
  @doc = "Manage a database."
  ensurable
  newparam(:name) do
    desc "The name of the database."

    # TODO: only [[:alnum:]_] allowed
  end

  newparam(:defaults) do
    desc "A my.cnf file containing defaults to connect to the DB server"
    defaultto "/etc/mysql/debian.cnf"

    # TODO: only valid paths allowed
  end
  
  newparam(:create_options) do
    desc "Additional options to pass to CREATE DATABASE"
    defaultto ""
  end

  autorequire(:class) do
    [ "mysql::params" ]
  end
  autorequire(:package) do
    [ "mysql" ]
  end
  autorequire(:service) do
    [ "mysql" ]
  end
end
