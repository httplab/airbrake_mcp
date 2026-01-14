# frozen_string_literal: true

module AirbrakeMcp
  module Tools
    class GetError < MCP::Tool
      tool_name "get_error"
      description "Get detailed information about a specific error group including backtrace"

      input_schema(
        properties: {
          group_id: { type: "string", description: "Error group ID" },
          project_id: { type: "integer", description: "Project ID (uses default if not specified)" }
        },
        required: ["group_id"]
      )

      def self.call(group_id:, project_id: nil, server_context:)
        client = server_context[:client]
        pid = project_id || client.project_id

        unless pid
          return ResponseHelper.text_response("Error: No project_id specified and no default configured", error: true)
        end

        group = client.group(group_id, project_id: pid)

        ResponseHelper.text_response(Formatters.format_group_detail(group))
      rescue Client::NotFoundError
        ResponseHelper.text_response("Error: Error group #{group_id} not found", error: true)
      rescue Client::ApiError => e
        ResponseHelper.text_response("Error: #{e.message}", error: true)
      end
    end
  end
end
