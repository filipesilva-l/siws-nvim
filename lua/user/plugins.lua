local fn = vim.fn

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim"
  use "nvim-lua/popup.nvim"
  use "nvim-lua/plenary.nvim"
  use "windwp/nvim-autopairs"
  use "numToStr/Comment.nvim"
  use "kyazdani42/nvim-web-devicons"
  use "kyazdani42/nvim-tree.lua"
  use "moll/vim-bbye"
  use "nvim-lualine/lualine.nvim"
  use "akinsho/toggleterm.nvim"
  use "ahmedkhalf/project.nvim"
  use "lewis6991/impatient.nvim"
  use "lukas-reineke/indent-blankline.nvim"
  use "goolord/alpha-nvim"
  use "antoinemadec/FixCursorHold.nvim"
  use "folke/which-key.nvim"

  use {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = { "fugitive" }
  }

  use {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
    end,
  }
  use {
    "sindrets/diffview.nvim",
    event = "BufRead",
  }
  use {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      vim.g.gitblame_enabled = 0
    end,
  }
  use {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require('neoscroll').setup({
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
          '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true,
        stop_eof = true,
        use_local_scrolloff = false,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = nil,
        pre_hook = nil,
        post_hook = nil,
      })
    end
  }
  use { "tpope/vim-repeat" }
  use { "tpope/vim-surround", keys = { "c", "d", "y" } }
  use { "ThePrimeagen/harpoon" }
  use {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      require "lsp_signature".setup()
    end
  }
  use {
    "kevinhwang91/nvim-bqf",
    event = { "BufRead", "BufNew" },
    config = function()
      require("bqf").setup({
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = {
          vsplit = "",
          ptogglemode = "z,",
          stoggleup = "",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
          },
        },
      })
    end,
  }
  use {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  }

  --use { "mfussenegger/nvim-dap", config = function()
  --  require("user.dap-config");
  --end }

  --use {
  --  "rcarriga/nvim-dap-ui",
  --  requires = { "mfussenegger/nvim-dap" },
  --  config = function()
  --    local dap, dapui = require("dap"), require("dapui")

  --    dapui.setup();

  --    dap.listeners.after.event_initialized["dapui_config"] = function()
  --      dapui.open()
  --    end
  --    dap.listeners.before.event_terminated["dapui_config"] = function()
  --      dapui.close()
  --    end
  --    dap.listeners.before.event_exited["dapui_config"] = function()
  --      dapui.close()
  --    end
  --  end
  --}
  --use {
  --  "theHamsta/nvim-dap-virtual-text",
  --  requires = { "mfussenegger/nvim-dap" },
  --  config = function()
  --    require "nvim-dap-virtual-text".setup()
  --  end
  --}

  use { "nvim-treesitter/nvim-treesitter-context", requires = "nvim-treesitter/nvim-treesitter" }

  -- Colorschemes
  --use "lourenci/github-colors"
  --use "shaeinst/roshnivim-cs"
  --use "rafamadriz/neon"
  --use "marko-cerovac/material.nvim"
  --use "folke/tokyonight.nvim"
  --use "olimorris/onedarkpro.nvim"
  --use "zefei/cake16"
  --use "dracula/vim"
  --use "catppuccin/nvim"
  --use "bluz71/vim-nightfly-guicolors"
  --use "kyazdani42/blue-moon"
  --use "frenzyexists/aquarium-vim"
  --use "rose-pine/neovim"
  --use "Shadorain/shadotheme"
  use "sainnhe/gruvbox-material"

  -- cmp plugins
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "saadparwaiz1/cmp_luasnip"
  use "hrsh7th/cmp-nvim-lsp"

  -- snippets
  use { "L3MON4D3/LuaSnip", config = function()
    require("luasnip.loaders.from_lua").lazy_load({paths = "~/.config/nvim/lua/user/custom_snippets"})
  end }

  -- LSP
  use "neovim/nvim-lspconfig"
  use "williamboman/nvim-lsp-installer"
  use "tamago324/nlsp-settings.nvim"
  use "jose-elias-alvarez/null-ls.nvim"

  -- Telescope
  use "nvim-telescope/telescope.nvim"
  use "nvim-telescope/telescope-ui-select.nvim"

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use "JoosepAlviste/nvim-ts-context-commentstring"

  -- Git
  use "lewis6991/gitsigns.nvim"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
