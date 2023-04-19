local c = vim.cmd
local f = vim.fn
local o = vim.opt

local sta
local packadd

sta, packadd = pcall(c, 'packadd nvim-cmp')
if not sta then
  print(packadd)
end

sta, packadd = pcall(c, 'packadd cmp-cmdline')
if not sta then
  print(packadd)
end

sta, packadd = pcall(c, 'packadd cmp-buffer')
if not sta then
  print(packadd)
end

sta, packadd = pcall(c, 'packadd cmp-nvim-lsp')
if not sta then
  print(packadd)
end

sta, packadd = pcall(c, 'packadd cmp-nvim-ultisnips')
if not sta then
  print(packadd)
end

sta, packadd = pcall(c, 'packadd cmp-path')
if not sta then
  print(packadd)
end

local cmp
sta, cmp = pcall(require, "cmp")
if not sta then
  print(cmp)
  return
end

o.completeopt = "menu,menuone,noselect"

cmp.setup({
  snippet = {
    expand = function(args)
      f["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
  }),
  sources = cmp.config.sources(
    {
      { name = "nvim_lsp" },
      { name = "ultisnips" },
      { name = "path" },
    },
    {
      { name = "buffer" },
    }
  ),
})

cmp.setup.cmdline({'/', '?'}, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    {
      { name = 'path' }
    },
    {
      { name = 'cmdline' }
    }
  )
})
