M = {}

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

function M.find(pattern)
  local uv = vim.uv
  local outf = vim.fn.tempname()
  local getlist = vim.schedule_wrap(vim.cmd.cgetfile)
  local notify = vim.schedule_wrap(vim.notify)

  uv.fs_open(outf, "w", tonumber('666', 8), function(_err, out)
    assert(not _err, _err)

    local opts = {
      stdio = { nil, out, nil },
      args = {
        "--color", "never", "--hidden", "--follow",
        "--exclude", ".git", "--exclude", "node_modules",
        "-t", "f", "--format", "{}:1:1: <<{/}>>", pattern,
      },
    }
    uv.spawn("fd", opts, function(code, signal)
      assert(code == 0, "failed to spawn fd")

      uv.fs_close(out, function(_err)
        assert(not _err, _err)
        getlist(outf)
        notify("search is done")
      end)
    end)
  end)
end

function M.grep(pattern)
  local uv = vim.uv
  local outf = vim.fn.tempname()
  local getlist = vim.schedule_wrap(vim.cmd.cfile)
  local notify = vim.schedule_wrap(vim.notify)

  uv.fs_open(outf, "w", tonumber('666', 8), function(_err, out)
    assert(not _err, _err)

    local opts = {
      stdio = { nil, out, nil },
      args = {"--vimgrep", "-uu", pattern},
    }
    uv.spawn("rg", opts, function(code, signal)
      uv.fs_close(out, function(_err)
        assert(not _err, _err)

        if code == 0 then
          getlist(outf)
          notify("grep is done")
        else
          notify("grep is empty")
        end
      end)
    end)
  end)
end

return M
