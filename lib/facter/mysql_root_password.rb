# mysql_root_password.rb

Facter.add( "mysql_root_password" ) do
  ENV["PATH"]="/bin:/sbin:/usr/bin:/usr/sbin"

  setcode do
    if File.exist? "/root/.my.cnf"
      existing_password = Facter::Util::Resolution.exec("cat  /root/.my.cnf | grep -m 1 password | sed 's/ //g' | cut -d= -f2").chomp
      #puts ["Fact (mysql_root_password) : existing password = '", existing_password, "'"].join
      existing_password
    else
      #puts ["Fact (mysql_root_password) : no existing password stored in /root/.my.cnf (File doesn't exists)."  ].join
      new_password = "false"
    end
  end
end