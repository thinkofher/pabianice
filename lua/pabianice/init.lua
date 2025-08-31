M = {}

function M.setup(opts)
  -- colorscheme
  vim.opt.termguicolors = true
  vim.o.background = "dark"

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
  vim.opt.wildignore = { ".git", "*.o", "*.a", "__pycache__", "node_modules" }
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

  function _G.rg_findfunc(cmdarg, _cmdcomplete)
    local fnames = vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git"')
    if #cmdarg == 0 then
      return fnames
    else
      return vim.fn.matchfuzzy(fnames, cmdarg)
    end
  end

  vim.o.findfunc = 'v:lua.rg_findfunc'
  vim.o.pumheight = 12

  local feed = function(cmd)
    return function()
      vim.fn.feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "c")
    end
  end

  local wk = require("which-key")
  local feed_find = feed(':lua require("pabianice.1905").find([[]])<Left><Left><Left>')

  wk.add({
    {
      mode = "n",

      {"<c-p>", feed(":find "), desc = "Fuzzy file search"},

      {"<leader>f", group = "async find"},
      {
        "<leader>ff", feed(':lua require("pabianice.1905").find([[]])<Left><Left><Left>'),
        desc = "file search",
      },
      {
        "<leader>fg", feed(':lua require("pabianice.1905").grep([[]])<Left><Left><Left>'),
        desc = "grep",
      },
    },

    {"gr", group = "builtin lsp commands"},

    -- terminal settings
    {"<c-v><esc>", "<c-\\><c-n>", mode = "t", desc = "leave terminal"},
    {"<leader>t", ":tabnew<cr>:terminal<cr>", mode = "n", desc = "open terminal"},

    {"<leader>co", ":cope<cr>", mode = "n", desc = "open qf"},
    {"<leader>cl", ":ccl<cr>", mode = "n", desc = "close qf"},

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
end

function M.gui(opts)
  vim.o.guifont = opts.gui_font or "Iosevka Term:h13"
  vim.g.neovide_cursor_vfx_mode = "ripple"

  if vim.loop.os_uname().sysname == "Darwin" then
    vim.g.neovide_show_border = true
  end
end

return M
