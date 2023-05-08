local c = vim.cmd
local f = vim.fn
local o = vim.opt

local sta

local add_pack_help = function(plugnames)
  local _sta, _path
  _sta, _path = pcall(require, "plenary.path")
  if not _sta then
    print(_path)
    return nil
  end
  local doc_path
  local packadd
  _path = _path:new(f.expand("$VIMRUNTIME"))
  local opt_path = _path:joinpath('pack', 'packer', 'opt')
  for _, plugname in ipairs(plugnames) do
    doc_path = opt_path:joinpath(plugname, 'doc')
    _sta, packadd = pcall(c, 'packadd ' .. plugname)
    if not _sta then
      print(packadd)
      return nil
    end
    if doc_path:is_dir() then
      c('helptags ' .. doc_path.filename)
    end
  end
  return true
end

add_pack_help({
  'nvim-cmp',
  'cmp-cmdline',
  'cmp-buffer',
  'cmp-nvim-lsp',
  'cmp-nvim-ultisnips',
  'cmp-path',
})


local cmp
sta, cmp = pcall(require, "cmp")
if not sta then
  print(cmp)
  return
end

local types
sta, types = pcall(require, 'cmp.types')
if not sta then
  print(types)
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
    ["qo"] = cmp.mapping.confirm({ select = false }),
    ["qi"] = {
      i = function()
        if cmp.visible() then
          cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
          cmp.confirm({ select = false })
        else
          cmp.complete()
        end
      end,
    },
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

cmp.setup.cmdline({ '/', '?' }, {
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
