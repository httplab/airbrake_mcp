# frozen_string_literal: true

require 'faraday'
require 'json'

module AirbrakeMcp
  class Client
    BASE_URL = 'https://api.airbrake.io/api/v4'

    def initialize(user_key:, project_id: nil)
      @user_key = user_key
      @project_id = project_id
    end

    attr_reader :project_id

    def projects
      get('projects')['projects']
    end

    def groups(project_id: @project_id, page: 1, limit: 20, **filters)
      params = { page: page, limit: limit }.merge(filters.compact)
      get("projects/#{project_id}/groups", params)
    end

    def group(group_id, project_id: @project_id)
      get("projects/#{project_id}/groups/#{group_id}")['group']
    end

    def notices(group_id, project_id: @project_id, page: 1, limit: 10)
      get("projects/#{project_id}/groups/#{group_id}/notices", { page: page, limit: limit })
    end

    # Write operations
    def resolve_group(group_id, project_id: @project_id)
      put("projects/#{project_id}/groups/#{group_id}/resolved")
    end

    def unresolve_group(group_id, project_id: @project_id)
      put("projects/#{project_id}/groups/#{group_id}/unresolved")
    end

    def mute_group(group_id, project_id: @project_id)
      put("projects/#{project_id}/groups/#{group_id}/muted")
    end

    def unmute_group(group_id, project_id: @project_id)
      put("projects/#{project_id}/groups/#{group_id}/unmuted")
    end

    private

    def get(path, params = {})
      response = connection.get(path, params.merge(key: @user_key))
      handle_response(response)
    end

    def put(path)
      response = connection.put("#{path}?key=#{@user_key}")
      handle_response(response)
    end

    def handle_response(response)
      case response.status
      when 200..299
        return true if response.body.nil? || response.body.empty?
        JSON.parse(response.body)
      when 401
        raise AuthenticationError, 'Invalid API key'
      when 404
        raise NotFoundError, 'Resource not found'
      when 429
        raise RateLimitError, 'Rate limit exceeded'
      else
        raise ApiError, "API error: #{response.status} - #{response.body}"
      end
    end

    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |f|
        f.request :url_encoded
        f.adapter Faraday.default_adapter
      end
    end

    class ApiError < StandardError; end
    class AuthenticationError < ApiError; end
    class NotFoundError < ApiError; end
    class RateLimitError < ApiError; end
  end
end
