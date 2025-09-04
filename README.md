# Pabianice

It is a really beautiful city.

## This is not plugin

It's just more sophisticated config file. Use it at your own risk. I wanted to
have some common configuration that I can sync between machines with just
single `:PlugUpdate`.

## Config file

Just paste below snippet into your `init.lua` file.

```lua
vim.loader.enable(true)

-- Bootstrap vim-plug
local plugpath = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"
local plugfirstime = false
if not (vim.uv or vim.loop).fs_stat(plugpath) then
  local plugscript = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  local out = vim.fn.system({ "curl", "-fLo", plugpath, "--create-dirs", plugscript })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to fetch vim-plug:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
  plugfirstime = true
end
vim.opt.rtp:prepend(plugpath)

local function Plug(t)
    vim.call('plug#begin')
    vim.iter(t):each(function(p) vim.fn['plug#'](p[1], p[2]) end)
    vim.call('plug#end')
end

Plug {
    { 'tpope/vim-fugitive', { commit = '61b51c09b7c9ce04e821f6cf76ea4f6f903e3cf4' } },
    { 'tpope/vim-obsession', { commit = 'ed9dfc7c2cc917ace8b24f4f9f80a91e05614b63' } },
    { 'tpope/vim-repeat', { commit = '65846025c15494983dafe5e3b46c8f88ab2e9635' } },

    { 'mhinz/vim-signify', { commit = '1a94c4124cd7d5b2f73352f7be38c14bd7441350' } },

    { 'folke/which-key.nvim', { commit = '370ec46f710e058c9c1646273e6b225acf47cbed' } },
    { 'onsails/lspkind.nvim', { commit = 'd79a1c3299ad0ef94e255d045bed9fa26025dab6' } },
    { 'ggandor/leap.nvim', { commit = 'e9cb442c0614a7e8185608f639e10c54e53bb083' } },

    { 'thinkofher/pabianice', { commit = 'c9c6834cc88cf80d60af86bb1faa11afa1b0de89' } },
}

if plugfirstime then
    vim.cmd.PlugInstall()
end

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require('leap').add_default_mappings()
require("pabianice").setup {
    icons = true,
    gui_font = "GohuFont uni14 Nerd Font:h14",
}

local au = vim.api.nvim_create_autocmd

au('LspAttach', {
    once = true,
    callback = function(ev)
        require("lspkind.").init()
    end,
})

vim.cmd.colorscheme "quiet"
```

Replace commit hashes if you want to update plugins. Remember to check the
generated diffs before with `:PlugDiff`. Don't just download random code from
the internet.
