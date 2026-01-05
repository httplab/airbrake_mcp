# frozen_string_literal: true

module AirbrakeMcp
  module Tools
    class ResolveError < MCP::Tool
      tool_name "resolve_error"
      description "Mark an error group as resolved or unresolve it"

      input_schema(
        properties: {
          group_id: { type: "integer", description: "Error group ID" },
          project_id: { type: "integer", description: "Project ID (uses default if not specified)" },
          resolved: { type: "boolean", description: "true to resolve, false to unresolve (default: true)" }
        },
        required: ["group_id"]
      )

      def self.call(group_id:, project_id: nil, resolved: true, server_context:)
        client = server_context[:client]
        pid = project_id || client.project_id

        unless pid
          return MCP::Tool::Response.new([
            MCP::Content::Text.new("Error: No project_id specified and no default configured")
          ], error: true)
        end

        if resolved
          client.resolve_group(group_id, project_id: pid)
          action = "resolved"
        else
          client.unresolve_group(group_id, project_id: pid)
          action = "unresolved"
        end

        MCP::Tool::Response.new([
          MCP::Content::Text.new("Error group ##{group_id} marked as #{action}")
        ])
      rescue Client::NotFoundError
        MCP::Tool::Response.new([
          MCP::Content::Text.new("Error: Error group #{group_id} not found")
        ], error: true)
      rescue Client::ApiError => e
        MCP::Tool::Response.new([
          MCP::Content::Text.new("Error: #{e.message}")
        ], error: true)
      end
    end
  end
end
