local sta, statuscol = pcall(require, "statuscol")
if not sta then
  print(statuscol)
  return
end

local builtin
sta, builtin = pcall(require, "statuscol.builtin")
if not sta then
  print(builtin)
  return
end

statuscol.setup({
  relculright = true,
  segments = {
    { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
    {
      sign = { name = { "Diagnostic" }, maxwidth = 2, auto = true },
      click = "v:lua.ScSa"
    },
    { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
    {
      sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
      click = "v:lua.ScSa"
    },
  }
})
