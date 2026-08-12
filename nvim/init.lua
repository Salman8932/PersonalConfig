vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.python3_host_prog = [[C:\Users\charg\AppData\Local\Programs\Python\Python312\python.exe]]


require("config.lazy")
require("config")


vim.opt.runtimepath:append(vim.fn.expand("~/current_course"))
print("APPEND RAN, rtp has current_course: " .. tostring(vim.tbl_contains(vim.opt.rtp:get(), vim.fn.expand("~/current_course"))))

