M = {}

local lazy = function(module, func, args)
  return function()
    require(module)[func](args)
  end
end

M.setup = function(opts)
  -- colorscheme
  vim.opt.termguicolors = true
  vim.o.background = "dark"
  vim.cmd.colorscheme("habamax")

  if vim.g.neovide then
    M.gui()
  end

  -- setup netrw plugin
  vim.g.netrw_banner = 0
  vim.g.netrw_altv = 1
  vim.g.netrw_liststyle = 3
  vim.g.netrw_list_hide = ",\\(^\\|\\s\\s\\)\\zs\\.\\S\\+"

  M.basics()
  M.keys()
  M.lsp()
end

M.basics = function()
  vim.cmd[[filetype plugin on]]
  vim.cmd[[filetype plugin indent on]]

  -- searching files
  vim.opt.path:append("**")
  vim.o.wildmenu = true
  vim.o.incsearch = true
  vim.o.ignorecase = true

  vim.o.tabstop = 4
  vim.o.softtabstop = 4
  vim.o.shiftwidth = 4

  vim.o.expandtab = true

  vim.o.copyindent = true

  -- always show one statusline
  vim.o.laststatus = 3

  -- backup functionalities
  vim.o.undofile = true

  -- don't wrap lines
  vim.o.wrap = false

  -- disable language providers (use lua and vimscript plugins only)
  vim.g.loaded_python3_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_perl_provider = 0
  vim.g.loaded_node_provider = 0
end

M.gui = function()
  vim.o.guifont = "Iosevka Term:h13"
  vim.g.neovide_cursor_vfx_mode = "ripple"

  if vim.loop.os_uname().sysname == "Darwin" then
    vim.g.neovide_show_border = true
  end
end



M.keys = function()
  local wk = require("which-key")

  wk.add({
    -- fuzzy finding with fzf
    {
      mode = "n",

      {"<c-p>", lazy("fzf-lua", "files"), desc = "Fuzzy file search"},

      {"<leader>f", group = "fuzzy"},
      {"<leader>ff", lazy("fzf-lua", "files"), desc = "file search"},
      {"<leader>fb", lazy("fzf-lua", "buffers"), desc = "buffer seearch"},
      {"<leader>fg", lazy("fzf-lua", "live_grep"), desc = "live grep"},
    },

    -- terminal settings
    {"<c-v><esc>", "<c-\\><c-n>", mode = "t", desc = "leave terminal"},
    {"<leader>t", ":tabnew<cr>:terminal<cr>", mode = "n", desc = "open terminal"},

    -- toggle grammer spelling
    {"<leader>cs", function()
      vim.opt.spell = not vim.opt.spell:get()
    end, desc = "toggle spell", mode = "n"},

    {
      mode = {"n", "v"},
      {"<leader>b", group = "yankers"},
      {"<leader>by", "\"*y", desc = "Clipboard yank"},
      {"<leader>bY", "\"*Y", desc = "Clipboard yank"},
      {"<leader>bp", "\"*p", desc = "Clipboard paste"},
      {"<leader>bP", "\"*P", desc = "Clipboard paste"},
    },
  })
end

M.lsp = function()
  local lsp_zero = require("lsp-zero")
  local wk = require("which-key")

  vim.opt.completeopt = {"menu", "menuone", "noinsert", "noselect"}

  -- lsp_attach is where you enable features that only work
  -- if there is a language server active in the file
  local lsp_attach = function(client, bufnr)
    local opts = {buffer = bufnr}

    wk.add({
      {
        buffer = bufnr,
        mode = "n",

        {"K", "<cmd>lua vim.lsp.buf.hover()<cr>"},

        {"gd", "<cmd>lua vim.lsp.buf.definition()<cr>"},
        {"gD", "<cmd>lua vim.lsp.buf.declaration()<cr>"},
        {"gi", "<cmd>lua vim.lsp.buf.implementation()<cr>"},
        {"go", "<cmd>lua vim.lsp.buf.type_definition()<cr>"},
        {"gr", "<cmd>lua vim.lsp.buf.references()<cr>"},
        {"gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>"},
        {"gl", "<cmd>lua vim.diagnostic.open_float()<cr>"},

        {"<leader>l", group = "lsp"},
        {"<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "rename"},
        {"<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "code action"},
        {
          "<leader>lh", "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>",
          desc = "toggle inlay hints",
        },
      },

      {"<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", buffer = bufnr, mode = {"n", "x"}},
    })
  end

  vim.diagnostic.config({
    virtual_text = false,
    severity_sort = true,
  })

  lsp_zero.extend_lspconfig({
    sign_text = false,
    lsp_attach = lsp_attach,
    capabilities = vim.lsp.protocol.make_client_capabilities()
  })

  -- don't add this function in the `lsp_attach` callback.
  -- `format_on_save` should run only once, before the language servers are active.
  lsp_zero.format_on_save({
    format_opts = {
      async = false,
      timeout_ms = 10000,
    },
    servers = {
      ['gopls'] = {'go'},
    },
  })

  local lspconfig = require('lspconfig')
  lspconfig.gopls.setup({
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = false,
          compositeLiteralFields = false,
          compositeLiteralTypes = false,
          constantValues = false,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = false,
        },
      },
    },
  })
end

return M
