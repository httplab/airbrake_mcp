# frozen_string_literal: true

require_relative 'lib/airbrake_mcp/version'

Gem::Specification.new do |spec|
  spec.name          = 'airbrake_mcp'
  spec.version       = AirbrakeMcp::VERSION
  spec.authors       = ['httplab']
  spec.email         = ['info@httplab.ru']

  spec.summary       = 'MCP server for Airbrake error tracking'
  spec.description   = 'Model Context Protocol (MCP) server for Claude Code integration with Airbrake error tracking'
  spec.homepage      = 'https://github.com/httplab/airbrake_mcp'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/httplab/airbrake_mcp'
  spec.metadata['changelog_uri'] = 'https://github.com/httplab/airbrake_mcp/blob/master/CHANGELOG.md'

  spec.files = Dir.chdir(__dir__) do
    Dir['{lib,exe}/**/*', 'README.md', 'LICENSE', 'CHANGELOG.md'].reject { |f| File.directory?(f) }
  end
  spec.bindir        = 'exe'
  spec.executables   = ['airbrake_mcp']
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_dependency 'mcp', '~> 0.4'

  spec.add_development_dependency 'dotenv', '~> 3.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 3.0'
end
