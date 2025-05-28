return {
  {
    'onsails/lspkind.nvim',
    event = "LspAttach",
    config = function()
      require("lspkind.").init()
    end,
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
    event = "VeryLazy",
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
      files = {
        fd_opts = [[--color=never --type f --hidden --follow --exclude .git --exclude node_modules]],
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
