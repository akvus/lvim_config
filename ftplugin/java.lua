local cmd
local home_dir = os.getenv("HOME")

if (IsWindows()) then
  cmd = 'C:/users/conta/AppData/Roaming/lunarvim/lvim/utils/bin'
else
  cmd = home_dir .. "/tools/jdt-language-server-1.35.0-202404251256/bin/jdtls"
end

local config = {
  cmd = { cmd },
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
}

require('jdtls').start_or_attach(config)
