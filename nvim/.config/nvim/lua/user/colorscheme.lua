local colorschemes = {
    "tokyonight-moon", -- dark
    "tokyonight-day", -- bright
    "gruvbox" -- dark 
}
local scheme_index = 1


local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorschemes[scheme_index])
if not status_ok then
  vim.notify("colorscheme " .. colorschemes[scheme_index] .. " not found!")
  return
end
