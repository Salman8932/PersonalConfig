vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.python3_host_prog = vim.fn.exepath("python")


require("config.lazy")
require("config")


vim.opt.runtimepath:append(vim.fn.expand("~/current_course"))
print("APPEND RAN, rtp has current_course: " .. tostring(vim.tbl_contains(vim.opt.rtp:get(), vim.fn.expand("~/current_course"))))

