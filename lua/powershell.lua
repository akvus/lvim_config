--[[
C:\Users\NAME\AppData\Local\lvim ------ LVIM CONFIG PATH ON WINDOWS
C:\Users\NAME\AppData\Roaming\lunarvim ------- OTHER LVIM STUFF ON WINDOWS
--]]

function IsWindows()
  return vim.loop.os_uname().sysname == 'Windows_NT';
end


function IsMacOs()
  return vim.loop.os_uname().sysname == 'Darwin';
end

if (IsWindows()) then
  -- Defaults that came with LunarVim 1.3
  vim.opt.shell = "pwsh.exe -NoLogo"
  vim.opt.shellcmdflag =
  "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  vim.cmd [[
      let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
      let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
      set shellquote= shellxquote=
  ]]

  -- Set a compatible clipboard manager
  vim.g.clipboard = {
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
  }
end
