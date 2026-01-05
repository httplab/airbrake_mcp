# Changelog

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
