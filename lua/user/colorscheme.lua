vim.cmd [[
try
  colorscheme gruvbox-material
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]

local M = {}

function M.set_light()
  vim.opt.background = "light"
  vim.cmd("colorscheme gruvbox-material")
end

return M

