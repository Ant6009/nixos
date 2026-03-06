{pkgs, ...}: {
  home.packages = [pkgs.opencode];

  programs.opencode.enableMcpIntegration = true;

  programs.mcp.servers."microsoft-learn" = {
    type = "http";
    url = "https://learn.microsoft.com/api/mcp";
  };
}
