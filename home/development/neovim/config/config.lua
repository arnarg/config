-- Set go bin path to path
vim.env.PATH = vim.env.PATH .. ":" .. (vim.env.GOPATH or (vim.env.HOME .. "/go")) .. "/bin"

-- Load rest of config
require("conf")