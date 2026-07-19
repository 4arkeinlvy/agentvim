-- Inline notebook plots (v0.2 toggle). Off by default: needs a terminal with
-- the kitty graphics protocol (kitty/WezTerm/Ghostty) and ImageMagick.
-- Enable: set vim.g.agentvim_inline_images = true in lua/config/options.lua.
return {
  {
    "3rd/image.nvim",
    enabled = function()
      return vim.g.agentvim_inline_images == true
    end,
    ft = { "markdown", "python" },
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      max_height_window_percentage = 40,
    },
  },
}
