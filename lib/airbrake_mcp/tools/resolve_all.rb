# frozen_string_literal: true

module AirbrakeMcp
  module Tools
    class ResolveAll < MCP::Tool
      tool_name "resolve_all"
      description "Resolve all open error groups in a project. Iterates through all pages and resolves each group."

      input_schema(
        properties: {
          project_id: { type: "integer", description: "Project ID (uses default if not specified)" },
          dry_run: { type: "boolean", description: "If true, only count groups without resolving (default: false)" }
        },
        required: []
      )

      def self.call(project_id: nil, dry_run: false, server_context:)
        client = server_context[:client]
        pid = project_id || client.project_id

        unless pid
          return ResponseHelper.text_response("Error: No project_id specified and no default configured", error: true)
        end

        resolved_count = 0
        failed_count = 0
        page = 1
        limit = 100

        loop do
          result = client.groups(project_id: pid, page: page, limit: limit)
          groups = result['groups'] || []
          break if groups.empty?

          unresolved = groups.reject { |g| g['resolved'] }

          unresolved.each do |group|
            if dry_run
              resolved_count += 1
            else
              begin
                client.resolve_group(group['id'].to_s, project_id: pid)
                resolved_count += 1
              rescue Client::ApiError => e
                failed_count += 1
              end
            end
          end

          # If all groups on this page were resolved, there may be more
          break if groups.length < limit

          page += 1
        end

        if dry_run
          ResponseHelper.text_response("Dry run: found #{resolved_count} unresolved error groups in project #{pid}")
        else
          msg = "Resolved #{resolved_count} error groups in project #{pid}"
          msg += " (#{failed_count} failed)" if failed_count > 0
          ResponseHelper.text_response(msg)
        end
      rescue Client::ApiError => e
        ResponseHelper.text_response("Error: #{e.message}", error: true)
      end
    end
  end
end
