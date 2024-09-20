vim.api.nvim_create_user_command("Pabianice", function() vim.print("Hello from Pabianice!") end, {})

vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Disable this thick vertical line between windows",
  once = false,
  nested = false,
  callback = function()
    vim.cmd.highlight({"VertSplit", "guibg=None"})
  end,
})
