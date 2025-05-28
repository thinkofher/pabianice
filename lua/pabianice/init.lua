M = {}

local lazy = function(module, func, args)
  return function()
    require(module)[func](args)
  end
end

function M.setup(opts)
  local wk = require("which-key")

  -- colorscheme
  vim.opt.termguicolors = true
  vim.o.background = "dark"
  vim.cmd.colorscheme("habamax")

  if vim.g.neovide then
    M.gui(opts)
  end

  -- setup netrw plugin
  vim.g.netrw_banner = 0
  vim.g.netrw_altv = 1
  vim.g.netrw_liststyle = 3
  vim.g.netrw_list_hide = ",\\(^\\|\\s\\s\\)\\zs\\.\\S\\+"

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

  vim.opt.completeopt = {"menu", "menuone", "noinsert", "noselect", "fuzzy"}

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

    {"gr", group = "builtin lsp commands"},

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

  vim.lsp.config.gopls = {
    cmd = { 'gopls' },
    root_markers = { 'go.work', 'go.mod' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    settings = {
      autoformat = true,
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
  }

  vim.lsp.enable({ 'gopls' })

  _G.pabianice_opts = opts
end

function M.gui(opts)
  vim.o.guifont = opts.gui_font or "Iosevka Term:h13"
  vim.g.neovide_cursor_vfx_mode = "ripple"

  if vim.loop.os_uname().sysname == "Darwin" then
    vim.g.neovide_show_border = true
  end
end

function M.lsp_on_attach(client, bufnr)
  local wk = require("which-key")

  wk.add({
    {
      buffer = bufnr,
      mode = "n",

      {"K", "<cmd>lua vim.lsp.buf.hover()<cr>"},

      {"grg", group = "custom lsp commands"},

      {
        "grgd", "<cmd>lua vim.lsp.buf.definition()<cr>",
        desc = "definition",
      },
      {
        "grgD", "<cmd>lua vim.lsp.buf.declaration()<cr>",
        desc = "declaration",
      },
      {
        "grgo", "<cmd>lua vim.lsp.buf.type_definition()<cr>",
        desc = "type definition",
      },
      {
        "grgs", "<cmd>lua vim.lsp.buf.signature_help()<cr>",
        desc = "signature help",
      },
      {
        "grgl", "<cmd>lua vim.diagnostic.open_float()<cr>",
        desc = "diagnostic details",
      },
      {
        "grgf", "<cmd>lua vim.lsp.buf.format({async = true})<cr>",
        buffer = bufnr, mode = {"n", "x"}, desc = "format current buffer",
      },
      {
        "grgh", "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>",
        desc = "toggle inlay hints",
      },
    },

  })

  vim.diagnostic.config({
    virtual_lines = true,
    severity_sort = true,
  })
end

return M
