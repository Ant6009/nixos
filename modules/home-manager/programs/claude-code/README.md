# Claude Code Configuration

This module provides a comprehensive Claude Code setup integrated with your NixOS/nix-darwin environment.

## Features Implemented

### 1. MCP Server Integration
- **mcp-nixos**: Provides real-time NixOS package information, options, and flake data
  - Prevents AI hallucinations about NixOS package names
  - Queries official NixOS APIs and documentation
  - Available as the `nixos` MCP server in Claude Code

### 2. LiteLLM Proxy Configuration
- Routes Claude Code requests through your LiteLLM instance at `192.168.68.220:4000`
- Uses the `LITELLM_API_KEY` environment variable (already configured in common/default.nix)
- Enables usage tracking, cost controls, and potential model fallbacks

### 3. Devenv Integration
- Global `~/.claude/CLAUDE.md` file instructs Claude about your devenv workflow
- Ensures Claude respects project-specific development environments
- Guides Claude to use `devenv shell` for running project commands

### 4. Declarative Settings Management
- Settings are generated from Nix configuration
- Easy to modify and extend MCP servers
- Version controlled alongside your system configuration

## Configuration Structure

```
modules/home-manager/programs/claude-code/
├── default.nix          # Main module configuration
└── README.md            # This file
```

The module generates:
- `~/.config/claude-code/settings.json` - Claude Code settings with MCP servers and environment
- `~/.claude/CLAUDE.md` - Global instructions for Claude about your development environment

## Customization

### Adding More MCP Servers

Edit `default.nix` and add to the `mcpServers` attribute:

```nix
mcpServers = {
  nixos = { ... };

  # Example: Add GitHub MCP
  github = {
    type = "stdio";
    command = "${pkgs.gh}/bin/gh";
    args = ["mcp"];
  };

  # Example: Add a custom MCP server
  myserver = {
    type = "stdio";
    command = "/path/to/mcp-server";
  };
};
```

### Modifying LiteLLM Configuration

To change the LiteLLM proxy URL or disable it:

```nix
claudeSettings = {
  env = {
    # Change proxy URL
    ANTHROPIC_BASE_URL = "http://different-host:4000";

    # Or remove to use Anthropic API directly
    # ANTHROPIC_BASE_URL = null;
  };
  # ... rest of config
};
```

### Adding Project-Specific Configuration

For individual projects, create a `.claude/` directory in the project root:

```bash
mkdir -p .claude
```

Then add project-specific settings or instructions in `.claude/CLAUDE.md`.

## Applying Changes

After modifying the configuration:

```bash
# For nix-darwin (macOS)
darwin-rebuild switch --flake .#MACMNPV9WL3V7

# For Home Manager only
home-manager switch --flake .#a.rivoire

# For NixOS
sudo nixos-rebuild switch --flake .#rocinante
```

## Usage

Once configured and rebuilt:

1. Claude Code will automatically use the mcp-nixos server for NixOS queries
2. All API requests will route through your LiteLLM instance
3. Claude will be aware of your devenv workflow
4. Settings are managed declaratively via Nix

## Verification

To verify the configuration:

```bash
# Check if settings file was created
cat ~/.config/claude-code/settings.json

# Check if CLAUDE.md was created
cat ~/.claude/CLAUDE.md

# Check if mcp-nixos is available
which mcp-nixos

# Test Claude Code
claude --help
```

## Troubleshooting

### MCP Server Not Found

If Claude Code can't find mcp-nixos:
- Ensure the package is in your PATH: `which mcp-nixos`
- Check settings.json has the correct path
- Rebuild your home-manager configuration

### LiteLLM Connection Issues

If Claude Code can't connect to LiteLLM:
- Verify LiteLLM is running: `curl http://192.168.68.220:4000/health`
- Check the LITELLM_API_KEY is set correctly
- Ensure LiteLLM exposes the Anthropic Messages API (`/v1/messages`)

### Settings Not Applied

If changes to default.nix aren't reflected:
- Run the rebuild command for your system
- Check for errors during rebuild
- Verify the generated settings.json matches your configuration

## Next Steps

Consider adding:
- Project-specific MCP servers in individual projects
- Custom hooks for pre/post tool use
- Additional MCP servers (GitHub, PostgreSQL, filesystem, etc.)
- Devenv integration in your project `devenv.nix` files (`claude.code.enable = true`)
