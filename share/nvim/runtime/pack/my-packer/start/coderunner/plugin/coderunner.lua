local a = vim.api
local c = vim.cmd

local sta = nil
local config_coderunner = nil
local loaded_config_coderunner = nil

local coderunner_exe = function()
  if not loaded_config_coderunner then
    loaded_config_coderunner = 1
    sta, config_coderunner = pcall(require, 'code_runner')
    if not sta then
      print(config_coderunner)
      return
    end
    config_coderunner.setup({
      filetype = {
        python = 'python -u',
        c = 'cd $dir && ' ..
            'gcc $fileName -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o $fileNameWithoutExt && ' ..
            'strip -s $dir/$fileNameWithoutExt.exe && ' ..
            'upx --best $dir/$fileNameWithoutExt.exe && ' .. '$dir/$fileNameWithoutExt'
      },
    })
  end
  if not config_coderunner then
    return
  end
  c 'RunCode'
end

a.nvim_create_user_command('CodeRunner', function()
  coderunner_exe()
end, { nargs = '*', })

local s = vim.keymap.set
local opt = { silent = true }
s({ 'n', 'v' }, '<leader>rr', ':<c-u>CodeRunner<cr>', opt)
