# frozen_string_literal: true

module AirbrakeMcp
  module Tools
    class ListProjects < MCP::Tool
      tool_name "list_projects"
      description "List all Airbrake projects accessible to the user"

      def self.call(server_context:)
        client = server_context[:client]
        projects = client.projects

        ResponseHelper.text_response(Formatters.format_projects(projects))
      rescue Client::ApiError => e
        ResponseHelper.text_response("Error: #{e.message}", error: true)
      end
    end
  end
end
