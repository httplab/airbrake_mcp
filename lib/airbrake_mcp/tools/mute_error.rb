# frozen_string_literal: true

module AirbrakeMcp
  module Tools
    class MuteError < MCP::Tool
      tool_name "mute_error"
      description "Mute or unmute an error group (suppress/enable notifications)"

      input_schema(
        properties: {
          group_id: { type: "integer", description: "Error group ID" },
          project_id: { type: "integer", description: "Project ID (uses default if not specified)" },
          mute: { type: "boolean", description: "true to mute, false to unmute (default: true)" }
        },
        required: ["group_id"]
      )

      def self.call(group_id:, project_id: nil, mute: true, server_context:)
        client = server_context[:client]
        pid = project_id || client.project_id

        unless pid
          return MCP::Tool::Response.new([
            MCP::Content::Text.new("Error: No project_id specified and no default configured")
          ], error: true)
        end

        if mute
          client.mute_group(group_id, project_id: pid)
          action = "muted"
        else
          client.unmute_group(group_id, project_id: pid)
          action = "unmuted"
        end

        MCP::Tool::Response.new([
          MCP::Content::Text.new("Error group ##{group_id} #{action}")
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
