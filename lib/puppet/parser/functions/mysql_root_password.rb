# generate a random password owith the required length with [a-zA-Z0-9] characters
include Puppet::Util::Execution

module Puppet::Parser::Functions
  newfunction(:mysql_root_password, :type => :rvalue) do |args|
    # Explicit loading of all puppet custom functions to have mysql_random_password
    # see : http://docs.puppetlabs.com/guides/custom_functions.html#calling-functions-from-functions
    Puppet::Parser::Functions.autoloader.loadall
    raise(Puppet::ParseError, "mysql_random_password(): Wrong number of arguments " +
          "given (#{args.size} for 1)") if args.size < 1
    
    root_my_cnf_path = args[0].to_s
          
    unless root_my_cnf_path  != String
      raise(Puppet::ParseError, 'mysql_root_password(): Requires a Path to work with')
    end
    
    if File.exists?(root_my_cnf_path)
#      puts ["mysql_root_password() arg[0] = root_my_cnf_path = ", root_my_cnf_path].join
      cmd = [ "cat" , root_my_cnf_path , "| grep -m 1 password | sed 's/ //g' | cut -d= -f2" ].join( " " )
#      puts ["mysql_root_password() cmd line = ", cmd].join
      password = IO.popen([cmd].join(" ")).readline
      password = password.strip
#      puts [ "MySQL read from ", root_my_cnf_path, " = [", password, "]" ].join
    else
      password = function_mysql_random_password("16".to_i)
#      puts [ "MySQL random generated password ", " = [", password, "]" ].join
    end
    password
  end
end

