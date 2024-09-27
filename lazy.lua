return {
  {"VonHeikemen/lsp-zero.nvim", branch = "v4.x"},
  {"neovim/nvim-lspconfig"},
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-path'},
      {'hrsh7th/cmp-buffer'},
      {"onsails/lspkind.nvim"},
    },
  },


  { "mhinz/vim-signify", event = "BufReadPre" },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  {
    "ggandor/leap.nvim",
    dependencies = {
      "tpope/vim-repeat",
    },
    config = function()
      require('leap').add_default_mappings()
    end,
  },

  {
    "ibhagwan/fzf-lua",
    opts = {
      "telescope",
      winopts = {
        width = 1.0,
        height = 0.35,
        row = 1,
        col = 0,
        border = 'single',
        preview = {
          hidden = "hidden",
        },
      },
    },
  },

  {
    "tpope/vim-fugitive",
    cmd = "G",
  },

  {
    "tpope/vim-obsession",
    cmd = "Obsession",
    event = "SessionLoadPost",
  },
}
