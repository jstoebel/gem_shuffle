require "thor"
 
class CLI < Thor

  desc "hello NAME", "say hello to NAME"
  option :from
  def hello()
    puts options
  end
end

CLI.start(ARGV)