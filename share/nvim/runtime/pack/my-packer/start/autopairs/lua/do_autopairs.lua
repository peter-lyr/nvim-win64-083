local sta, autopairs = pcall(require, "nvim-autopairs")
if not sta then
  print(autopairs)
  return
end

autopairs.setup()
