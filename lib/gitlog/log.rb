require 'date'

def git_format_selectors()
  git_format_selectors = {
    'message' => '%s',
  }
  return git_format_selectors
end

def type_keywords()
  type_keywords = {
    'feat' => {
      name: 'New Features',
    },
    'fix' => {
      name: 'Bug Fixes',
    },
    'perf' => {
      name: 'Performance Enhancements',
    },
    'refactor' => {
      name: 'Refactorings',
      dev: true,
    },
    'docs' => {
      name: 'Documentation Changes',
      dev: true,
    },
    'test' => {
      name: 'Test Changes',
      dev: true,
    },
    'style' => {
      name: 'Style Changes',
      dev: true,
    },
    'chore' => {
      name: 'Configuration Updates',
      dev: true,
    },
    $other_type => {
      name: 'Other Changes',
      dev: true,
    }
  }
  return type_keywords
end 

$other_type = 'other'
$type_keywords = type_keywords()
$type_keywords_index_helper = $type_keywords.map { |key, value| key }
$git_format_info = git_format_selectors().map { |key, value| key }



def git_log_on_date(specific_date = nil, author = nil, current_branch_only = false)
  command = Array["git log"]
  command << "--pretty=\"%s\""
  command << "--all" if !current_branch_only
  command << "--author=\"#{author.chomp}\"" if author
  command << "--after=\"#{specific_date.chomp} 00:00\" --before=\"#{specific_date.chomp} 23:59\"" if specific_date
  command << "--no-merges"
  # puts command.compact.join(' ')
  return `#{command.compact.join(' ')}`
  rescue
  nil
end

def git_log_between_commits(from, to, author = nil)
  command = Array['git log --branches']
  command << "--pretty=\"%s\""
  command << "--author=\"#{author.chomp}\"" if author
  # command << '--ancestry-path'
  command << "#{from.chomp} ^#{to.chomp}^"
  command << "--no-merges"
  puts command.compact.join(' ')
  return `#{command.compact.join(' ')}`
  rescue
  nil
end


def git_formatted_log(logs, log_style, dev = true)

  # print_log('Raw Logs', logs)

  return "No Changelogs \n" unless logs && !logs.empty?

  categorized_line_info = {}
  logs.each_line { |line|
    line_info = {}
    line = line.strip.split("\t")
    $git_format_info.each_with_index { |value, index|
      line_info[value] = line[index]
    }

    message_format_regex = /([^\(:]+)(?:\(([^\)]*)\))?[[:space:]]*:?[[:space:]]*(.*)/
    match_data = line_info['message'].match(message_format_regex)
    if match_data
      if match_data[3].empty?
        $type_keywords.each { |key, value|
          if line_info['message'].downcase.include? key
            line_info['type'] = key
            break
          end
        }
      else
        line_info['type'] = match_data[1]
        line_info['scope'] = match_data[2]
        line_info['message'] = match_data[3]
      end
    end

    line_info['type'] = (line_info['type'] || '').downcase

    unless $type_keywords[line_info['type']]
      line_info['type'] = $other_type
    end

    line_info['message'] = (line_info['message'][0, 1].upcase + line_info['message'][1..-1]).chomp(".")

    style = 'type'
    case log_style
     when :type_wise
       style = 'type'
     when :scope_wise
       style = 'scope'
    end

    categorized_line_info[line_info[style]] ||= []
    categorized_line_info[line_info[style]] << line_info
  }

    case log_style
     when :type_wise
      return git_formatted_log_type(categorized_line_info)
     when :scope_wise
      return git_formatted_log_scope(categorized_line_info)
    end
end

def git_formatted_log_type_markdown(categorized_line_info, dev = true)
  categorized_line_info = categorized_line_info.sort_by { |key, value| $type_keywords_index_helper.index(key) || $type_keywords_index_helper.index($other_type) }

  # print_log('categorized_line_info', categorized_line_info)

  changelog_lines = []
  categorized_line_info.each { |key, value|
    next if $type_keywords[key][:dev] && !dev
    changelog_lines << "#### #{$type_keywords[key][:name]}"
    changelog_lines << ''
    value.each { |line_info|
      scope_string = (dev && line_info['scope']) ? " #{line_info['scope']}" : ''
      dev_string = dev ?  (scope_string.empty? ? '' : "**-#{scope_string}:** ") : ''
      changelog_lines << "#{dev_string}#{line_info['message']}"
      changelog_lines << ''
    }
    changelog_lines << ''
  }
  return changelog_lines.join("\n")
end

def git_formatted_log_type(categorized_line_info, dev = true)
  categorized_line_info = categorized_line_info.sort_by { |key, value| $type_keywords_index_helper.index(key) || $type_keywords_index_helper.index($other_type) }

  # print_log('categorized_line_info', categorized_line_info)

  changelog_lines = []
  categorized_line_info.each { |key, value|
    next if $type_keywords[key][:dev] && !dev
    changelog_lines << "#{$type_keywords[key][:name]}"
    value.each { |line_info|
      scope_string = (dev && line_info['scope']) ? " #{line_info['scope']}" : ''
      dev_string = dev ?  (scope_string.empty? ? '' : "-#{scope_string}: ") : ''
      changelog_lines << "#{dev_string}#{line_info['message']}"
    }
    changelog_lines << ''
  }
  return changelog_lines.join("\n")
end

def git_formatted_log_scope(categorized_line_info, dev = true)
    categorized_line_info = categorized_line_info.sort_by { |key, value| $type_keywords_index_helper.index(key)}

    # print_log('categorized_line_info', categorized_line_info)

    changelog_lines = []
    categorized_line_info.each { |key, value|   
      changelog_lines << key
      value.each { |line_info|
        changelog_lines << "- #{$type_keywords[line_info['type']][:name]}: #{line_info['message']}"
      }
      changelog_lines << ''
    }
    return changelog_lines.join("\n")
end

def print_log(key, value)
  print "\n\n #{key}: \n"
  print value
  print "\n\n"
end

def author()
  author = `git config user.email`
  return author
end


module GitLog
  class Log

  	def self.generate_log(specific_date = nil, log_style = nil, author = nil, current_branch_only = false)
      if specific_date.nil?
        specific_date =  "#{DateTime.now.strftime("%Y-%m-%d")}"
      end
      if log_style.nil?
        log_style = :type_wise
      end
      if author.nil?
        author = author()
      end
      print_log("log_style", log_style)
  	  git_logs = git_log_on_date(specific_date, author, current_branch_only)
  	  logs = git_formatted_log(git_logs,log_style)
  	  puts logs
  	end

  	def self.log_between_commits(from, to, log_style = nil, author = nil)
      if log_style.nil?
        log_style = :type_wise
      end
      if author.nil?
        author = author()
      end

  	  git_logs = git_log_between_commits(from, to, author)
  	  logs = git_formatted_log(git_logs,log_style)
  	  puts logs
  	end
  end
end