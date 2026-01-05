# frozen_string_literal: true

require 'webmock/rspec'
require 'json'

require 'airbrake_mcp'

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed
end

# Helper to load JSON fixtures
def fixture(name)
  JSON.parse(File.read(File.join(__dir__, 'fixtures', "#{name}.json")))
end

# Airbrake API base URL (matches client)
AIRBRAKE_API_BASE = 'https://api.airbrake.io'.freeze

# Helper to stub Airbrake API
def stub_airbrake_api(method, path, response_body: {}, status: 200)
  stub_request(method, "#{AIRBRAKE_API_BASE}#{path}")
    .to_return(status: status, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
end
