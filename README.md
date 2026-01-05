# Airbrake MCP Server

[![Gem Version](https://badge.fury.io/rb/airbrake_mcp.svg)](https://badge.fury.io/rb/airbrake_mcp)

MCP (Model Context Protocol) server for Airbrake error tracking integration with Claude Code.

## Features

- List Airbrake projects
- List and filter error groups
- Get detailed error information with backtraces
- List individual error occurrences (notices)
- Resolve/unresolve errors
- Mute/unmute error notifications

## Requirements

- Ruby 3.0+
- Airbrake User API Key

## Installation

### Via RubyGems

```bash
gem install airbrake_mcp
```

### From Source

```bash
git clone https://github.com/httplab/airbrake_mcp.git
cd airbrake_mcp
bundle install
```

## Configuration

### Getting Your API Key

1. Log in to Airbrake
2. Go to Profile Settings
3. Find "User API Key" section
4. Copy your key

## Claude Code Integration

### Quick Setup

```bash
claude mcp add airbrake -- airbrake_mcp \
  -e AIRBRAKE_USER_KEY=your_user_key \
  -e AIRBRAKE_PROJECT_ID=123456
```

### Manual Configuration

Add to `~/.claude/settings.json` or project's `.claude/settings.local.json`:

```json
{
  "mcpServers": {
    "airbrake": {
      "command": "airbrake_mcp",
      "env": {
        "AIRBRAKE_USER_KEY": "your_user_key",
        "AIRBRAKE_PROJECT_ID": "123456"
      }
    }
  }
}
```

Or if installed from source:

```json
{
  "mcpServers": {
    "airbrake": {
      "command": "/path/to/airbrake_mcp/bin/airbrake_mcp",
      "env": {
        "AIRBRAKE_USER_KEY": "your_user_key",
        "AIRBRAKE_PROJECT_ID": "123456"
      }
    }
  }
}
```

## Available Tools

### list_projects
List all Airbrake projects accessible to the user.

### list_errors
List error groups with filtering options.

Parameters:
- `project_id` (optional) - Project ID, uses default if not specified
- `page` (optional) - Page number, default: 1
- `limit` (optional) - Results per page, default: 20
- `resolved` (optional) - Filter by resolved status (true/false)

### get_error
Get detailed information about a specific error group including backtrace.

Parameters:
- `group_id` (required) - Error group ID
- `project_id` (optional) - Project ID

### list_notices
List individual occurrences/notices for an error group.

Parameters:
- `group_id` (required) - Error group ID
- `project_id` (optional) - Project ID
- `page` (optional) - Page number, default: 1
- `limit` (optional) - Results per page, default: 10

### resolve_error
Mark an error group as resolved or unresolve it.

Parameters:
- `group_id` (required) - Error group ID
- `project_id` (optional) - Project ID
- `resolved` (optional) - true to resolve, false to unresolve, default: true

### mute_error
Mute or unmute an error group (suppress/enable notifications).

Parameters:
- `group_id` (required) - Error group ID
- `project_id` (optional) - Project ID
- `mute` (optional) - true to mute, false to unmute, default: true

## Development

### Running Tests

```bash
bundle exec rspec
```

### Building the Gem

```bash
gem build airbrake_mcp.gemspec
```

## License

MIT
