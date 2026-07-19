-- Notebook workflow:
--  * jupytext.nvim  — open .ipynb as plain text (round-trips on save, git-friendly)
--  * molten-nvim    — run cells against a Jupyter kernel, output inline
-- ponytail: image outputs need a kitty/wezterm terminal + image.nvim; text outputs
-- work everywhere. Add image.nvim when plots-in-editor matter (you have kitty).
return {
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false, -- must be loaded before an .ipynb buffer is read
    opts = {
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
    },
  },
  {
    "benlubas/molten-nvim",
    version = "^1",
    build = ":UpdateRemotePlugins",
    ft = { "python", "markdown" },
    init = function()
      vim.g.molten_image_provider = "none"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_virt_text_output = true
      vim.g.molten_wrap_output = true
    end,
    keys = {
      { "<leader>j", nil, desc = "+jupyter" },
      { "<leader>ji", "<cmd>MoltenInit<cr>", desc = "Init kernel" },
      { "<leader>jl", "<cmd>MoltenEvaluateLine<cr>", desc = "Run line" },
      { "<leader>jr", "<cmd>MoltenReevaluateCell<cr>", desc = "Re-run cell" },
      { "<leader>je", ":<C-u>MoltenEvaluateVisual<cr>gv<esc>", mode = "v", desc = "Run selection" },
      { "<leader>jo", "<cmd>MoltenShowOutput<cr>", desc = "Show output" },
      { "<leader>jh", "<cmd>MoltenHideOutput<cr>", desc = "Hide output" },
      { "<leader>jd", "<cmd>MoltenDelete<cr>", desc = "Delete cell" },
      { "<leader>js", "<cmd>MoltenInterrupt<cr>", desc = "Interrupt kernel" },
      { "<leader>jR", "<cmd>MoltenRestart!<cr>", desc = "Restart kernel" },
    },
  },
}
