-- https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/

vim.opt.number = true
vim.opt.mouse = ''
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

local lazy = {}

function lazy.install(path)
  if not vim.uv.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable',
      path,
    })
  end
end

function lazy.setup(plugins)
  if vim.g.plugins_ready then
    return
  end

  lazy.install(lazy.path)
  vim.opt.rtp:prepend(lazy.path)

  require('lazy').setup(plugins, lazy.opts)
  vim.g.plugins_ready = true
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
  { 'folke/tokyonight.nvim' },
  { 'nvim-tree/nvim-web-devicons' },
  { 'nvim-lualine/lualine.nvim' },
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
  },

  -- Nowy, zaktualizowany Treesitter (zgodny z najnowszymi wersjami)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- W nowoczesnym nvim-treesitter konfigurację przekazuje się bezpośrednio do głównego modułu
      require("nvim-treesitter").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust", "yaml" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },

  -- LSP-Zero oraz poprawne zarządzanie serwerami (Mason)
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'}, 
      
      -- Autouzupełnianie (Autocomplete)
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    },
    config = function()
      local lsp_zero = require("lsp-zero")
      
      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({buffer = bufnr})

        -- Autoformatowanie przy zapisie DLA RUSTA
        if client.name == "rust_analyzer" then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("RustFormat", { clear = true }),
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end)

      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "rust_analyzer" },
        handlers = {
          lsp_zero.default_setup,
          
          rust_analyzer = function()
            require("lspconfig").rust_analyzer.setup({
              settings = {
                ["rust-analyzer"] = {
                  check = {
                    command = "clippy",
                    extraArgs = { "--workspace", "--all-targets" },
                  },
                  inlayHints = {
                    enable = true,
                  },
                },
              },
            })
          end,
        },
      })
    end,
  },
})

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

---
-- Colorscheme
---
vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight')
vim.cmd.background = 'dark'

---
-- lualine.nvim (statusline)
---
vim.opt.showmode = false
require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'tokyonight',
    component_separators = '|',
    section_separators = '',
  },
})
