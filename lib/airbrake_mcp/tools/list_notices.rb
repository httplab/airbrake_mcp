# frozen_string_literal: true

module AirbrakeMcp
  module Tools
    class ListNotices < MCP::Tool
      tool_name "list_notices"
      description "List individual occurrences/notices for an error group"

      input_schema(
        properties: {
          group_id: { type: "string", description: "Error group ID" },
          project_id: { type: "integer", description: "Project ID (uses default if not specified)" },
          page: { type: "integer", description: "Page number (default: 1)" },
          limit: { type: "integer", description: "Results per page (default: 10)" }
        },
        required: ["group_id"]
      )

      def self.call(group_id:, project_id: nil, page: 1, limit: 10, server_context:)
        client = server_context[:client]
        pid = project_id || client.project_id

        unless pid
          return ResponseHelper.text_response("Error: No project_id specified and no default configured", error: true)
        end

        result = client.notices(group_id, project_id: pid, page: page, limit: limit)

        ResponseHelper.text_response(Formatters.format_notices(result))
      rescue Client::NotFoundError
        ResponseHelper.text_response("Error: Error group #{group_id} not found", error: true)
      rescue Client::ApiError => e
        ResponseHelper.text_response("Error: #{e.message}", error: true)
      end
    end
  end
end
