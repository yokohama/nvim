require'nvim-web-devicons'.get_icon(filename, extension, options)

--[[
local has_devicons, devicons = pcall(require, "nvim-web-devicons")

if not has_devicons then
    return
end

devicons.setup({
    -- ここでオプションを設定することができます
})
]]--
