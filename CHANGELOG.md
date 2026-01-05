# Changelog

## [1.0.3] - 2026-01-06

### Fixed
- Removed `require 'bundler/setup'` from bin script to fix Bundler conflicts when running from project directories with their own Gemfile
- Made dotenv loading optional (development dependency only)

### Changed
- Simplified README installation instructions

## [1.0.2] - 2025-01-06

### Added
- Documentation for rbenv/asdf/chruby users (non-interactive shell shim paths)
- Improved `claude mcp add` examples with `$(which airbrake_mcp)`

## [1.0.1] - 2025-01-06

### Changed
- Renamed `exe` directory to `bin` (POSIX convention)
- Added `claude mcp add` quick setup command to README

## [1.0.0] - 2025-01-05

### Added
- Initial release
- MCP server with STDIO transport
- Airbrake API client
- Tools:
  - `list_projects` - List all accessible Airbrake projects
  - `list_errors` - List error groups with filtering options
  - `get_error` - Get detailed error information with backtrace
  - `list_notices` - List individual error occurrences
  - `resolve_error` - Mark errors as resolved/unresolved
  - `mute_error` - Mute/unmute error notifications
