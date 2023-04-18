local M = {}

---@class Config
local defaults = {
  icons = {
    symlink = '',
    directory = '',
    file = '',
  },
  use_devicons = true,
  mappings = {},
}

local d = vim.keymap.del
local p = pcall
local o = {buffer = true}

local mapclear_buffer = function()

  -- p(d, {'n', 'v'}, '<RightMouse>', o)
  -- p(d, 'n', '<2-LeftMouse>', o)
  -- p(d, 'n', '<C-LeftMouse>', o)
  -- p(d, 'n', '<LeftMouse>', o)
  -- p(d, 'n', '<MiddleMouse>', o)
  -- p(d, 'n', '<S-LeftDrag>', o)
  -- p(d, 'n', '<S-LeftMouse>', o)

  p(d, 'n', 'mA', o)
  p(d, 'n', 'mB', o)
  p(d, 'n', 'mF', o)
  p(d, 'n', 'mT', o)
  p(d, 'n', 'mX', o)
  p(d, 'n', 'ma', o)
  p(d, 'n', 'mb', o)
  p(d, 'n', 'mc', o)
  p(d, 'n', 'md', o)
  p(d, 'n', 'me', o)
  p(d, 'n', 'mf', o)
  p(d, 'n', 'mg', o)
  p(d, 'n', 'mh', o)
  p(d, 'n', 'mm', o)
  p(d, 'n', 'mp', o)
  p(d, 'n', 'mr', o)
  p(d, 'n', 'ms', o)
  p(d, 'n', 'mt', o)
  p(d, 'n', 'mu', o)
  p(d, 'n', 'mv', o)
  p(d, 'n', 'mx', o)
  p(d, 'n', 'mz', o)

  p(d, 'n', '%', o)
  -- p(d, 'n', '-', o)
  -- p(d, 'n', '<C-H>', o)
  -- p(d, 'n', '<C-L>', o)
  p(d, 'n', '<C-R>', o)
  -- p(d, 'n', '<CR>', o)
  p(d, 'n', '<F1>', o)
  -- p(d, 'n', '<S-CR>', o)
  p(d, 'n', '<S-Down>', o)
  p(d, 'n', '<S-Up>', o)
  p(d, 'n', 'C', o)
  -- p(d, 'n', 'I', o)
  p(d, 'n', 'O', o)
  p(d, 'n', 'P', o)
  p(d, 'n', 'S', o)
  p(d, 'n', 'Tb', o)
  p(d, 'n', 'Th', o)
  -- p(d, 'n', 'U', o)
  p(d, 'n', 'X', o)
  p(d, 'n', '[', o)
  p(d, 'n', '[[', o)
  p(d, 'n', '[]', o)
  p(d, 'n', ']', o)
  p(d, 'n', '][', o)
  p(d, 'n', ']]', o)
  p(d, 'n', 'a', o)
  p(d, 'n', 'cB', o)
  p(d, 'n', 'cb', o)
  p(d, 'n', 'cd', o)
  p(d, 'n', 'd', o)
  p(d, 'n', 'gb', o)
  p(d, 'n', 'gd', o)
  p(d, 'n', 'gf', o)
  p(d, 'n', 'gh', o)
  p(d, 'n', 'gn', o)
  p(d, 'n', 'gp', o)
  -- p(d, 'n', 'i', o)
  p(d, 'n', 'o', o)
  p(d, 'n', 'p', o)
  p(d, 'n', 'qF', o)
  p(d, 'n', 'qL', o)
  p(d, 'n', 'qb', o)
  p(d, 'n', 'qf', o)
  -- p(d, 'n', 'r', o)
  -- p(d, 'n', 's', o)
  p(d, 'n', 't', o)
  -- p(d, 'n', 'u', o)
  p(d, 'n', 'v', o)
  p(d, 'n', 'x', o)
  p(d, {'n', 'v'}, '<Del>', o)
  p(d, {'n', 'v'}, 'D', o)
  p(d, {'n', 'v'}, 'R', o)

end

---@type Config
M.options = {}

local s = vim.keymap.set
local c = vim.cmd
local opts = { noremap = true, silent = true, nowait = true, buffer = true}

---@param options Config|nil
function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})

  -- Hook on BufModifiedSet to configure the netrw buffer.
  vim.api.nvim_create_autocmd('BufModifiedSet', {
    pattern = {"*"},
    callback = function()
      if not (vim.bo and vim.bo.filetype == 'netrw') then
        return
      end

      mapclear_buffer()

      vim.opt.number = true
      vim.opt.relativenumber = true

      if vim.b.netrw_liststyle == 2 then
        s({'n', 'v'}, 'q', function() c[[ call feedkeys("-") ]] end, opts)
        s({'n', 'v'}, 'o', function() c[[ call feedkeys("\<cr>") ]] end, opts)
        s({'n', 'v'}, 'a', function() c[[ call feedkeys("\<cr>") ]] end, opts)
        return
      end

      local bufnr = vim.api.nvim_get_current_buf()
      require'netrw.ui'.embelish(bufnr)
      require'netrw.actions'.bind(bufnr)
    end,
    group = vim.api.nvim_create_augroup("netrw", {clear = false}),
  })
end

return M
