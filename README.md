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
claude mcp add airbrake airbrake_mcp \
  -e AIRBRAKE_USER_KEY=your_user_key \
  -e AIRBRAKE_PROJECT_ID=123456
```

### Using rbenv/asdf/chruby

If you use a Ruby version manager, Claude Code runs in a non-interactive shell without access to your shell profile. Provide the full path to the shim:

```bash
# rbenv
claude mcp add airbrake ~/.rbenv/shims/airbrake_mcp \
  -e AIRBRAKE_USER_KEY=your_user_key \
  -e AIRBRAKE_PROJECT_ID=123456

# asdf
claude mcp add airbrake ~/.asdf/shims/airbrake_mcp \
  -e AIRBRAKE_USER_KEY=your_user_key \
  -e AIRBRAKE_PROJECT_ID=123456
```

### Manual Configuration

Add to `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "airbrake": {
      "command": "airbrake_mcp",
      "args": [],
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
- `limit` (optional) - Results per page, default: 20, max: 100
- `resolved` (optional) - Filter by resolved status (true/false)
- `order` (optional) - Sort order: `last_notice`, `notice_count`, `weight`, `created`

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

### resolve_all
Resolve all open error groups in a project. Iterates through all pages.

Parameters:
- `project_id` (optional) - Project ID, uses default if not specified
- `dry_run` (optional) - If true, only count groups without resolving (default: false)

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

### Building and Installing from Source

```bash
# Build the gem
gem build airbrake_mcp.gemspec

# Install locally
gem install ./airbrake_mcp-*.gem --no-document

# If using rbenv, rehash to update shims
rbenv rehash
```

### Updating an Installed Gem

When updating the gem after code changes:

```bash
# 1. Remove ALL old versions
gem uninstall airbrake_mcp --all --executables --ignore-dependencies

# 2. Remove old gem files
rm -f *.gem

# 3. Build fresh gem
gem build airbrake_mcp.gemspec

# 4. Install with force flag
gem install ./airbrake_mcp-*.gem --no-document --force

# 5. Rehash rbenv shims
rbenv rehash

# 6. Verify installation
gem which airbrake_mcp
```

## Troubleshooting

### "command not found" after installation

If you see `rbenv: airbrake_mcp: command not found`, the gem was installed for a different Ruby version.

```bash
# Check which Ruby versions have the gem
rbenv versions  # shows available versions
gem list airbrake_mcp  # shows if installed for current Ruby

# Install for the correct Ruby version
RBENV_VERSION=3.4.4 gem install ./airbrake_mcp-*.gem --no-document
rbenv rehash
```

### MCP fails to connect after gem update

1. Ensure the gem is completely uninstalled before reinstalling:
   ```bash
   gem uninstall airbrake_mcp --all --executables --ignore-dependencies
   ```

2. Verify the new code is in the built gem:
   ```bash
   gem unpack airbrake_mcp-*.gem --target=/tmp/check
   cat /tmp/check/airbrake_mcp-*/lib/airbrake_mcp/client.rb
   rm -rf /tmp/check
   ```

3. After installation, verify the installed code:
   ```bash
   cat $(dirname $(gem which airbrake_mcp))/airbrake_mcp/client.rb
   ```

### Large Error Group IDs

Airbrake uses very large integers for error group IDs (e.g., `4235892606830408977`). These IDs are passed as strings to avoid JavaScript precision loss issues. When using tools like `get_error` or `list_notices`, provide the `group_id` exactly as shown in `list_errors` output.

## License

MIT
