# frozen_string_literal: true

module AirbrakeMcp
  module ResponseHelper
    # Workaround for MCP gem bug where Content objects aren't converted to hashes
    # in Response#to_h. This creates responses with pre-converted content.
    def self.text_response(text, error: false)
      MCP::Tool::Response.new([{ type: "text", text: text }], error: error)
    end
  end
end
