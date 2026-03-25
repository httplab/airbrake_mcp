# Changelog

## [1.1.2] - 2026-03-25

### Fixed
- Removed empty `required: []` from `list_errors` and `resolve_all` input schemas — fixes crash with `mcp` gem >= 0.9 which validates JSON Schema draft-04 minimum items constraint

## [1.1.1] - 2026-02-08

### Fixed
- Clear Bundler environment variables on startup to avoid conflicts when launched from project directories — eliminates the need for a wrapper script

## [1.1.0] - 2026-02-08

### Fixed
- Fixed `put` method silently swallowing HTTP errors (now raises exceptions like `get`)
- Fixed `handle_response` to handle 204 No Content responses from resolve/mute endpoints
- Fixed `list_errors` client-side filtering — now passes `resolved` filter to API server-side

### Added
- New `resolve_all` tool for bulk-resolving all open error groups in a project (with `dry_run` option)
- `order` parameter for `list_errors` (supports: `last_notice`, `notice_count`, `weight`, `created`)
- Server-side filter passthrough for `groups` client method

## [1.0.4] - 2026-01-06

### Fixed
- Fixed API URL path construction (removed leading slashes causing requests to bypass /api/v4 path)
- Fixed MCP response serialization (workaround for MCP gem bug where Content objects aren't converted to hashes)

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
