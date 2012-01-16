# generate a random password with 16 characters length and from [a-zA-Z0-9] characters

module Puppet::Parser::Functions
  newfunction(:mysql_random_password, :type => :rvalue) do |args|
    password_characters =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
    new_password  =  Range.new(0,16).map{ password_characters[rand(password_characters.length)] }.join
    puts [ "Function (mysql_random_password) : a new mysql password was generated : ", new_password ].join()
    new_password
  end
end
