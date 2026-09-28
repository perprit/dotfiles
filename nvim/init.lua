-- leader는 lazy.nvim 부트스트랩 전에 지정해야 한다
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.lazy")
require("config.keymaps")
