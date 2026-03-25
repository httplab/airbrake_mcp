# frozen_string_literal: true

module AirbrakeMcp
  module Tools
    class ListErrors < MCP::Tool
      tool_name "list_errors"
      description "List error groups from Airbrake with filtering options"

      input_schema(
        properties: {
          project_id: { type: "integer", description: "Project ID (uses default if not specified)" },
          page: { type: "integer", description: "Page number (default: 1)" },
          limit: { type: "integer", description: "Results per page (default: 20, max: 100)" },
          resolved: { type: "boolean", description: "Filter by resolved status (true/false)" },
          order: { type: "string", description: "Sort order: last_notice, notice_count, weight, created (default: last_notice)" }
        }
      )

      def self.call(project_id: nil, page: 1, limit: 20, resolved: nil, order: nil, server_context:)
        client = server_context[:client]
        pid = project_id || client.project_id

        unless pid
          return ResponseHelper.text_response("Error: No project_id specified and no default configured", error: true)
        end

        filters = {}
        filters[:resolved] = resolved unless resolved.nil?
        filters[:order] = order if order

        result = client.groups(project_id: pid, page: page, limit: limit, **filters)

        ResponseHelper.text_response(Formatters.format_groups(result))
      rescue Client::ApiError => e
        ResponseHelper.text_response("Error: #{e.message}", error: true)
      end
    end
  end
end
