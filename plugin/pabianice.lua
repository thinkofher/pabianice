local au = vim.api.nvim_create_autocmd

local group = vim.api.nvim_create_augroup('Pabianice', {
  clear = true,
})

au('ColorScheme', {
  group = group,
  desc = 'Disable this thick vertical line between windows',
  once = false,
  nested = false,
  callback = function()
    vim.cmd.highlight({'VertSplit', 'guibg=None'})
  end,
})

au('LspAttach', {
  group = group,
  callback = function(ev)
    local pb = require('pabianice.1905')

    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method('textDocument/willSaveWaitUntil')
      and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end

    pb.lsp_on_attach(client, ev.buf)
  end,
})
