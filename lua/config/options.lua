-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Pin the provider to system python (has pynvim) so remote plugins like molten
-- keep working when a project venv is active.
vim.g.python3_host_prog = "/usr/bin/python3"
