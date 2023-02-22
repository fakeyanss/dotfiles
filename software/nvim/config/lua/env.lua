local env = {}
local os_name = vim.loop.os_uname().sysname

function env:load_variables()
    self.is_mac = os_name == "Darwin"
    self.is_linux = os_name == "Linux"
    self.is_windows = os_name == "Windows_NT"
    self.is_wsl = vim.fn.has("wsl") == 1
    self.vim_path = vim.fn.stdpath("config")

    local path_sep = self.is_windows and "\\" or "/"
    local home = self.is_windows and os.getenv("USERPROFILE") or os.getenv("HOME")
    self.home = home
    self.data_path = vim.fn.stdpath("data")
    self.state_path = vim.fn.stdpath("state")
    self.cache_path = home .. path_sep .. ".cache" .. path_sep .. "nvim"
end

env:load_variables()

return env
