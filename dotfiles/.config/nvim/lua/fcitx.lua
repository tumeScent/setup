-- 检测 fcitx 输入法是否为中文状态
local function fcitx_cmd()
  if vim.fn.executable("fcitx5-remote") == 1 then
    return "fcitx5-remote"
  else
    return "fcitx-remote"
  end
end

local function is_fcitx_chinese()
  return vim.fn.system("fcitx-remote"):gsub("\n", "") == "2"
end

-- 智能 Esc 映射：退出插入模式前自动切换为英文输入
vim.keymap.set("i", "<Esc>", function()
  if is_fcitx_chinese() then
    vim.fn.system("fcitx-remote -c")
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { noremap = true, silent = true })

