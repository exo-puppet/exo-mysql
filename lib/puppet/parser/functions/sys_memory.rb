include Puppet::Util::Execution

module Puppet::Parser::Functions
  newfunction(:sys_memory, :type => :rvalue) do |args|
    # Explicit loading of all puppet custom functions to have mysql_random_password
    # see : http://docs.puppetlabs.com/guides/custom_functions.html#calling-functions-from-functions
    Puppet::Parser::Functions.autoloader.loadall
    cmd = [ "free -o -b" , "| grep -i 'mem:' | sed 's/[a-z:]\\+ \\+//ig' | sed 's/ \\+/:/g' | cut -d: -f1" ].join( " " )
    puts ["sys_memory() cmd line = ", cmd].join
      
    memory = IO.popen([cmd].join(" ")).readline
    memory = memory.strip
    
    puts [ "System Memory (bytes) = [", memory, "]" ].join

    memory
  end
end

