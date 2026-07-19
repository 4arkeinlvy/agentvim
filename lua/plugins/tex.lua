-- VimTeX viewer: evince is preinstalled on Ubuntu GNOME and supports SyncTeX.
-- ponytail: switch to zathura (vimtex_view_method = "zathura") if you install it.
return {
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_view_method = "general"
      vim.g.vimtex_view_general_viewer = "evince"
      vim.g.vimtex_quickfix_open_on_warning = 0
    end,
  },
}
