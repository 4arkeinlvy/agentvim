# AgentVim Windows installer (experimental — WSL2 + install.sh is the
# recommended path; see docs/installation.md).
# Requires scoop: https://scoop.sh
$ErrorActionPreference = "Stop"

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
  throw "scoop is required: https://scoop.sh  (irm get.scoop.sh | iex)"
}

Write-Host "==> Installing tools via scoop" -ForegroundColor Blue
scoop bucket add extras 2>$null
scoop bucket add nerd-fonts 2>$null
scoop install neovim ripgrep fd lazygit mingw
scoop install JetBrainsMono-NF

Write-Host "==> Installing AgentVim config" -ForegroundColor Blue
$cfg = "$env:LOCALAPPDATA\nvim"
if (Test-Path $cfg) {
  $bak = "$cfg.bak.$(Get-Date -Format yyyyMMdd-HHmmss)"
  Move-Item $cfg $bak
  Write-Host "  existing config moved to $bak" -ForegroundColor Yellow
}
git clone --depth 1 https://github.com/4arkeinlvy/agentvim $cfg

if (Get-Command python -ErrorAction SilentlyContinue) {
  Write-Host "==> Notebook support (pip --user)" -ForegroundColor Blue
  python -m pip install --user --quiet pynvim jupyter_client ipykernel jupytext
}

Write-Host "==> Installing plugins (lockfile)" -ForegroundColor Blue
nvim --headless "+Lazy! restore" +qa

Write-Host "`nAgentVim installed." -ForegroundColor Green
Write-Host "Set 'JetBrainsMono Nerd Font' in Windows Terminal, then run: nvim"
Write-Host "Docs: $cfg\docs\usage.md"
