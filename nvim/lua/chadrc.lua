-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

-- Usages: to override the ui and all nvim config like theme so on

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "gruvbox",

  hl_override = {
    -- Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.nvdash = {
  load_on_startup = true,
  header = {
    "                                ",
    "   ███████╗██████╗ ███████╗     ",
    "   ██╔════╝██╔══██╗██╔════╝     ",
    "   █████╗  ██████╔╝█████╗       ",
    "   ██╔══╝  ██╔══██╗██╔══╝       ",
    "   ██║     ██║  ██║███████╗     ",
    "   ╚═╝     ╚═╝  ╚═╝╚══════╝     ",
    "     ┏━┓ ┏━┓ ┏━┓ ┏━┓ ┏━┓         ",
    "     ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃         ",
    "     ┗┳┛ ┗┳┛ ┗┳┛ ┗┳┛ ┗┳┛         ",
    "      ┃   ┃   ┃   ┃   ┃          ",
    "     ┏┻━━━┻━━━┻━━━┻━━━┻┓         ",
    "     ┃   F R E A K T O P U S  🐙 ┃",
    "     ┗━━━━━━━━━━━━━━━━━━━━━━━┛   ",
    "                                ",
    "                                 ",
    "                                ",
  },
}
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
--}

return M
