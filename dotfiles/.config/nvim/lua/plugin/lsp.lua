-- plugin/lsp.lua

-- 1. mason 主配置
require("mason").setup()

-- 2. mason-lspconfig 安装和自动配置
require("mason-lspconfig").setup({
    ensure_installed = { "pyright", "clangd", "verible" },
    automatic_installation = true,  -- 自动安装 ensure_installed 中缺失的 LSP
})

-- 3. 自动配置 LSP (推荐写法)
require("mason-lspconfig").setup_handlers {
  function(server)
    vim.lsp.config[server].setup {}
  end,

  verible = function()
    vim.lsp.config.verible.setup {
      cmd = { "verible-verilog-ls" },
      settings = {
        verible = {
          lint_on_save = true,
        }
      }
    }
  end
}
-- local servers = { "pyright", "clangd" }
-- for _, server in ipairs(servers) do
--     vim.lsp.config[server].setup {}
-- end
--

-- 4. 安装 black/flake8/clang-format 等工具
require("mason-tool-installer").setup {
    ensure_installed = {
        "black",
        "flake8",
        "clang-format",
    },
    run_on_start = true, -- 启动时自动安装
}


