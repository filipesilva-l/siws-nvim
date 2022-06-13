local dap_ok, dap = pcall(require, "dap");

if not dap_ok then
  return
end

local HOME = os.getenv "HOME"
local DEBUGGER_LOCATION = HOME .. "/.local/share/nvim/netcoredbg"

dap.adapters.coreclr = {
  type = 'executable',
  command = DEBUGGER_LOCATION .. "/netcoredbg",
  args = { '--interpreter=vscode' }
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}
