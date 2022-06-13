local DATA_PATH = vim.fn.stdpath "data"

return {
  cmd = {
    DATA_PATH .. "/lspinstall/csharp/omnisharp/run",
    "--languageserver",
    "--hostPID",
    tostring(vim.fn.getpid()),
  },
}
