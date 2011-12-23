# generate a random password with the required length with [a-zA-Z0-9] characters
module Puppet::Parser::Functions
  newfunction(:mysql_random_password, :type => :rvalue) do |args|

    raise(Puppet::ParseError, "mysql_random_password(): Wrong number of arguments " +
          "given (#{args.size} for 1)") if args.size < 1
    
    puts ["mysql_random_password : args[0] = ", args[0]].join
    # FIXME the argument is not passed 
    password_length = args[0].to_i
          
    unless password_length  != Integer
      raise(Puppet::ParseError, 'mysql_random_password(): Requires integer to work with')
    end
    
    puts ["mysql_random_password : password_length = ", password_length].join
    
    o =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten;
    # TODO don't use a fix 16 characters String generation
    string  =  Range.new(0,16).map{ o[rand(o.length)]  }.join;
  end
end
