local ls_ok, ls = pcall(require, "luasnip")

if not ls_ok then
  return;
end

local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local result = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(result, str)
  end
  return result
end

local function scandir(directory)
  local index, result, popen = 0, {}, io.popen
  local pfile = popen('ls -a "' .. directory .. '"')
  for filename in pfile:lines() do
    index = index + 1
    result[index] = filename
  end
  pfile:close()
  return result
end

local function trim(value)
  return (value:gsub("^%s*(.-)%s*$", "%1"))
end

local function compose_namespace(dir)
  local namespace = ""
  local has_csproj = false

  while not has_csproj do
    local splitted = split(dir, "/");
    local last_element = splitted[#splitted]
    local last_element_is_dir = not string.find(last_element, ".cs")

    if #splitted == 0 then
      return ""
    end

    if last_element_is_dir then
      dir = dir:gsub(last_element .. "/", "")
    else
      dir = dir:gsub(last_element, "")
    end

    local files = scandir(dir)

    local csprojs = vim.tbl_filter(function(file)
      return string.find(file, ".csproj") ~= nil
    end, files)

    has_csproj = #csprojs ~= 0

    if not has_csproj and last_element_is_dir then
      namespace = last_element .. "." .. namespace
    elseif has_csproj then
      local to_concat = ""

      if last_element_is_dir then
        to_concat = last_element
      end

      namespace = string.sub(csprojs[1], 0, #csprojs[1] - #".csproj") .. "." .. to_concat .. "." .. namespace
    end
  end

  namespace = trim(namespace:gsub("%.", " ")):gsub("%s+", ".")

  return namespace
end

local function get_current_buffer_filename()
  local buf_name = vim.api.nvim_buf_get_name(0);

  local splitted = split(buf_name, "/")

  return splitted[#splitted]:gsub(".cs", "");
end

function P(a)
  print(vim.inspect(a))
end

local function get_constructable_node()
  local constructable_nodes = { "abstract_class_declaration", "class_declaration", "record_declaration", "struct_declaration" }
  local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()

  while node ~= nil and not vim.tbl_contains(constructable_nodes, node:type()) do
    node = node:parent()
  end

  return node
end

local function get_node_identifier(node)
  for child in node:iter_children() do
    if child:type() == "identifier" then
      return require("vim.treesitter.query").get_node_text(child, 0)
    end
  end

  return get_current_buffer_filename()
end

local cs_snippets = {
  s(
    "nmsp",
    fmt(
      [[
      namespace {1};

      public {2} {3}
      {{
          {}
      }}
      ]],
      {
      f(function()
        local buf_name = vim.api.nvim_buf_get_name(0)

        return compose_namespace(buf_name)
      end),
      f(function()
        local filename = get_current_buffer_filename()
        local first_letter = filename:sub(0, 1)
        local second_letter = filename:sub(1, 2)

        if (first_letter == "I" and string.upper(second_letter) == second_letter) then
          return "interface"
        else
          return "class"
        end
      end),
      f(get_current_buffer_filename),
      i(0)
    }
    )
  ),
  s("prop", fmt("public {1} {} {{ get; }}", { i(1, "string"), i(0, "Propriedade") })),
  s(
    "ctor",
    fmt([[
        public {1}()
        {{
            {}
        }}
    ]],
      {
      f(function()
        return get_node_identifier(get_constructable_node())
      end),
      i(0)
    })
  ),
}

return cs_snippets
