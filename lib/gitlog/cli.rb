require 'thor'
require 'gitlog'

module GitLog
  class CLI < Thor
	desc "my", "Generate my commit logs. Ex. gitlog my --date 2019-06-07 --scope-wise --current-branch"
	method_option :date, aliases: "-d", :desc => "provide date in yyyy-MM-dd format"
	method_option :scopewise, aliases: "-s", :type => :boolean, :desc => "if you want log to be grouped scope wise"
	method_option :typewise, aliases: "-t", :type => :boolean, :desc => "if you want log to be grouped type wise"
	method_option :current_branch, aliases: "-c", :type => :boolean, :desc => "if you want logs from current branch only"
	def my
		grouping = :type_wise
	    if options[:scopewise]
	    	grouping = :scope_wise
	    end
	    puts GitLog::Log.generate_log(options[:date], grouping, nil, options[:current_branch])
	end

	desc "all", "Generate all commit logs. Ex. gitlog all --date 2019-06-07 --scope-wise --current-branch"
	method_option :date, aliases: "-d", :desc => "provide date in yyyy-MM-dd format"
	method_option :author, aliases: "-a", :desc => "email id of the author whose logs you want"
	method_option :scopewise, aliases: "-s", :type => :boolean, :desc => "if you want log to be grouped scope wise"
	method_option :typewise, aliases: "-t", :type => :boolean, :desc => "if you want log to be grouped type wise"
	method_option :current_branch, aliases: "-c", :type => :boolean, :desc => "if you want logs from current branch only"
	def all
		grouping = :type_wise
	    if options[:scopewise]
	    	grouping = :scope_wise
	    end
	    puts GitLog::Log.generate_log(options[:date], grouping, options[:author], options[:current_branch])
	end

	desc "range", "Generate all logs between 2 commits. It prompts for the commit hashes. Ex. gitlog range --from 2958885 --to 2f96f24 --author a@b.co --scope-wise"
	method_option :from, :type => :string, :desc => "From Commit"
	method_option :to, :type => :string, :desc => "To Commit"
	method_option :author, aliases: "-a", :desc => "email id of the author whose logs you want"
	method_option :scopewise, aliases: "-s", :type => :boolean, :desc => "if you want log to be grouped scope wise"
	method_option :typewise, aliases: "-t", :type => :boolean, :desc => "if you want log to be grouped type wise"
	def range
		from = options[:from]
		if from.nil?
	      from = ask('From Commit:')
	    end
	    to = options[:to]
	    if to.nil?
	      to = ask('To Commit:')
	    end

	    grouping = :type_wise
	    if options[:scopewise]
	    	grouping = :scope_wise
	    end
		puts GitLog::Log.log_between_commits(to, from, grouping, options[:author])
	end
  end
end