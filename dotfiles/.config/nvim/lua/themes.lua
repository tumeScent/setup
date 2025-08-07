vim.cmd[[colorscheme nord]]
-- transparent backgournd
vim.defer_fn(function()
  local hl = vim.api.nvim_set_hl
  hl(0, "Normal",      { bg = "none" })
  hl(0, "NormalNC",    { bg = "none" })
  hl(0, "NormalFloat", { bg = "none" })
  hl(0, "FloatBorder", { bg = "none" })
  hl(0, "SignColumn",  { bg = "none" })
  hl(0, "@function", { italic = false })
end, 0)
