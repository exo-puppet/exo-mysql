################################################################################
# Compute the maximum usable memory for MySQL on the current system
# The maximum memory is about 70 % of the total amount of memory
# see mysqltuner for more informations
################################################################################
include Puppet::Util::Execution

module Puppet::Parser::Functions
  newfunction(:mysql_max_memory_to_use, :type => :rvalue) do |args|
    # Explicit loading of all puppet custom functions to have mysql_random_password
    # see : http://docs.puppetlabs.com/guides/custom_functions.html#calling-functions-from-functions
    Puppet::Parser::Functions.autoloader.loadall

    sys_memory = function_sys_memory().to_i
    #puts [ "mysql_max_buffer_to_use:", "sys_memory=", sys_memory ].join(' ')
    memory = sys_memory * 70 / 100
    #puts [ "mysql_max_buffer_to_use:", "memory=", memory ].join(' ')
    memory
  end
end

