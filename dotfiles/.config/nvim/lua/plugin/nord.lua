-- vim.cmd[[colorscheme nord]]
-- transparent backgournd
-- vim.defer_fn(function()
--   local hl = vim.api.nvim_set_hl
--   hl(0, "Normal",      { bg = "none" })
--   hl(0, "NormalNC",    { bg = "none" })
--   hl(0, "NormalFloat", { bg = "none" })
--   hl(0, "FloatBorder", { bg = "none" })
--   hl(0, "SignColumn",  { bg = "none" })
--   hl(0, "@function", { italic = false })
-- end, 0)
-- Example config in lua
vim.g.nord_contrast = true
vim.g.nord_borders = false
vim.g.nord_disable_background = true
vim.g.nord_italic = false
vim.g.nord_uniform_diff_background = true
vim.g.nord_bold = false

-- Load the colorscheme
require('nord').set()
