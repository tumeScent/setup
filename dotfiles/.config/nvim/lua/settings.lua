-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true


vim.cmd("syntax enable")

-- 缩进设置
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

-- 自动换行和断行
vim.o.wrap = true
vim.o.linebreak = true

-- 启用鼠标
vim.o.mouse = "a"

-- 行号
vim.wo.relativenumber = false
vim.opt.nu = true

-- 剪贴板
-- 1. 定义一个专门使用 OSC 52 的复制函数
local function copy_osc52(lines, regtype)
    require('vim.ui.clipboard.osc52').copy('+')(lines, regtype)
end

-- 2. 映射 y 和 yy 复制到系统剪切板
-- nmap y "+y (将 y 映射为复制到 + 寄存器)
-- nmap yy "+yy
vim.keymap.set({'n', 'v'}, 'y', '"+y', { desc = "Copy to system clipboard via OSC 52" })
vim.keymap.set('n', 'yy', '"+yy', { desc = "Copy line to system clipboard via OSC 52" })

-- 3. 设置剪切板提供者为内置的 OSC 52
vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
}


-- 
vim.o.scrolloff = 5

-- transparent background
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")

-- set leader
vim.g.mapleader = " "
