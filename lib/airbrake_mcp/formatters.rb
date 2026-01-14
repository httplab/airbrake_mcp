# frozen_string_literal: true

module AirbrakeMcp
  module Formatters
    module_function

    def format_projects(projects)
      return "No projects found" if projects.empty?

      output = "Found #{projects.length} projects:\n\n"

      projects.each do |project|
        output += "  [#{project['id']}] #{project['name']}\n"
      end

      output
    end

    def format_groups(result)
      groups = result['groups'] || []
      total = result['count'] || groups.length

      return "No error groups found" if groups.empty?

      output = "Found #{total} error groups:\n\n"

      groups.each do |group|
        status = group['resolved'] ? '[RESOLVED]' : '[OPEN]'
        muted = group['muted'] ? ' (muted)' : ''
        error = group['errors']&.first || {}

        output += "#{status}#{muted} id:#{group['id']}\n"
        output += "  Type: #{error['type']}\n"
        output += "  Message: #{truncate(error['message'], 100)}\n"
        output += "  Count: #{group['noticeCount']} occurrences\n"
        output += "  Last seen: #{group['lastNoticeAt']}\n"
        output += "  Environment: #{group.dig('context', 'environment') || 'N/A'}\n"
        output += "\n"
      end

      output
    end

    def format_group_detail(group)
      error = group['errors']&.first || {}

      output = "Error Group ##{group['id']}\n"
      output += "=" * 50 + "\n\n"

      output += "Status: #{group['resolved'] ? 'Resolved' : 'Open'}\n"
      output += "Muted: #{group['muted'] ? 'Yes' : 'No'}\n"
      output += "Type: #{error['type']}\n"
      output += "Message: #{error['message']}\n"
      output += "Total occurrences: #{group['noticeCount']}\n"
      output += "First seen: #{group['createdAt']}\n"
      output += "Last seen: #{group['lastNoticeAt']}\n"
      output += "Environment: #{group.dig('context', 'environment') || 'N/A'}\n"

      if group['lastDeployAt']
        output += "Last deploy: #{group['lastDeployAt']}\n"
      end

      output += "\n"
      output += "Backtrace:\n"
      output += "-" * 30 + "\n"

      backtrace = error['backtrace'] || []
      backtrace.first(15).each_with_index do |frame, i|
        file = frame['file'] || '?'
        line = frame['line'] || '?'
        func = frame['function'] || '?'
        output += "  #{i + 1}. #{file}:#{line} in `#{func}`\n"
      end

      if backtrace.length > 15
        output += "  ... and #{backtrace.length - 15} more frames\n"
      end

      output
    end

    def format_notices(result)
      notices = result['notices'] || []

      return "No notices found" if notices.empty?

      output = "Error occurrences:\n\n"

      notices.each_with_index do |notice, i|
        error = notice['errors']&.first || {}

        output += "#{i + 1}. Notice ##{notice['id']}\n"
        output += "   Time: #{notice['createdAt']}\n"
        output += "   Type: #{error['type']}\n"
        output += "   Message: #{truncate(error['message'], 80)}\n"

        context = notice['context'] || {}
        if context['url']
          output += "   URL: #{context['url']}\n"
        end
        if context['userAgent']
          output += "   User-Agent: #{truncate(context['userAgent'], 60)}\n"
        end
        if context['userId']
          output += "   User ID: #{context['userId']}\n"
        end

        output += "\n"
      end

      output
    end

    def truncate(str, length)
      return '' if str.nil?
      str.length > length ? "#{str[0...length]}..." : str
    end
  end
end
