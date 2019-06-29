require 'thor'
require 'gitlog'

module GitLog
  class CLI < Thor
	desc "my LOG", "Gives your logs"
	def dolog(log)
	  puts GitLog::Log.dolog(log)
	end
  end
end