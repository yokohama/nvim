-- Autotag
local status, autotag = pcall(require, "nvim-ts-autotag")
if (not status) then return end

autotag.setup({})


-- Autopair
require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})
