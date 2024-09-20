return {
  {"VonHeikemen/lsp-zero.nvim", branch = "v4.x"},

  {"neovim/nvim-lspconfig"},

  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {}
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

  { "nvim-tree/nvim-web-devicons", lazy = true },
}
