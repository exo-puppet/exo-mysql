# This has to be a separate type to enable collecting
Puppet::Type.newtype(:mysql_user) do
  @doc = "Manage a database user."
  ensurable
  newparam(:name) do
    desc "The name of the user. This uses the 'username@hostname' form."
  end
  newproperty(:password_hash) do
    desc "The password hash of the user. Use mysql_password() for creating such a hash."
  end

  newparam(:defaults) do
    desc "A my.cnf file containing defaults to connect to the DB server"
    defaultto "/etc/mysql/debian.cnf"

    # TODO: only valid paths allowed
  end

  # Autorequire the nearest ancestor directory found in the catalog.
  # Taken from puppet/type/file in the puppet source
#  autorequire(:file) do
#    [ "/etc/mysql" ]
#  end
  
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
