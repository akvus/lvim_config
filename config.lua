--[[
based on: https://gist.github.com/Antoniozinchenko/b7e1d3679a88ec4f1b3a3bd6e5b44961

1. Install and enable some NerdFont
2. :PackerSync
3. :checkhealth and fix issues

Remove all branches but master PowerShell:  git branch -D  @(git branch | select-string -NotMatch "master" | Foreach {$_.Line.Trim()})

C:\Users\conta\AppData\Local\lvim
C:\Users\conta\AppData\Roaming\lunarvim

]]

-- Defaults that came with LunarVim 1.3
--[[ Enable powershell as your default shell
vim.opt.shell = "pwsh.exe -NoLogo"
vim.opt.shellcmdflag =
"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
vim.cmd [[
		let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
		let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
		set shellquote= shellxquote=
  ]]
--[[
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

]]

-- SETTINGS
lvim.log.level = "warn"
lvim.format_on_save.enabled = true
vim.opt.relativenumber = true
lvim.leader = ","

-- Set what files make a directory root of a project
-- defaults include other VCSs, Makefile, package.json
lvim.builtin.project.patterns = { ">Projects", ".git", "pubspec.yaml" }

-- nvim-tree
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 40,
  },
  renderer = {
    group_empty = true,
  },
})

-- KEY MAPPINGS
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.insert_mode["jj"] = "<ESC>"
-- delete single character without copying into register
lvim.keys.normal_mode["x"] = '"_x'
-- spit windows verticall and horizontally
lvim.keys.normal_mode["<leader>|"] = ":vsplit<CR>"
lvim.keys.normal_mode["<leader>sv"] = ":vsplit<CR>"
lvim.keys.normal_mode["<leader>-"] = ":split<CR>"
-- aligh cursor on screen center during scroll
lvim.keys.normal_mode["<C-d>"] = "<C-d>zz"
lvim.keys.normal_mode["<C-u>"] = "<C-u>zz"
lvim.keys.normal_mode["<Tab>"] = ":bnext<CR>"
lvim.keys.normal_mode["<S-Tab>"] = ":bprev<CR>"
-- NvimTree
lvim.keys.normal_mode["<leader>i"] = ":NvimTreeFindFile<CR>"
lvim.keys.normal_mode["<leader>I"] = ":NvimTreeClose<CR>"
-- Resize splits
lvim.keys.normal_mode["<leader>="] = ":vert res +10<CR>"
lvim.keys.normal_mode["<leader>-"] = ":vert res -10<CR>"
-- LSP
lvim.keys.normal_mode["g["] = ":lua vim.diagnostic.goto_next()<CR>"
lvim.keys.normal_mode["g]"] = ":lua vim.diagnostic.goto_prev()<CR>"
lvim.keys.normal_mode["[g"] = ":lua vim.diagnostic.goto_next()<CR>"
lvim.keys.normal_mode["]g"] = ":lua vim.diagnostic.goto_prev()<CR>"
lvim.keys.normal_mode['<leader>aw'] = "<cmd>lua vim.lsp.buf.code_action()<CR>"
-- CMP
lvim.builtin.cmp.sources = {
  { name = "nvim_lsp", group_index = 2 },
  { name = "path",     group_index = 2 },
  { name = "luasnip",  group_index = 2 },
}
-- Telescope
lvim.keys.normal_mode['<leader>T'] = ":Telescope<CR>"
lvim.keys.normal_mode['<leader>D'] = ":lua require'telescope.builtin'.live_grep{}<CR>"
lvim.keys.normal_mode['<leader>H'] = ":lua require'telescope.builtin'.oldfiles{}<CR>"

local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}
lvim.builtin.telescope.on_config_done = function(telescope)
  telescope.load_extension "flutter"
end

-- worktree
-- TODO change to mappings?
lvim.keys.normal_mode['<leader>w'] = ":lua require('telescope').extensions.git_worktree.git_worktrees()"
lvim.keys.normal_mode['<leader>c'] = ":lua require('telescope').extensions.git_worktree.create_git_worktree()"

-- Fugitive
lvim.builtin.which_key.mappings["g"] = {
  name = "+Git",
  p = { "<cmd>G push<cr>", "Git push" },
  l = { "<cmd>G pull<cr>", "Git pull" },
  f = { "<cmd>G fetch<cr>", "Git fetch" },
  a = { "<cmd>G add .<cr>", "Git add all" },
  s = { "<cmd>G status<cr>", "Git status" },
  d = { "<cmd>G diff<cr>", "Git diff" },
  x = { "<cmd>! git add . && git commit -m Update && git push<cr>", "Git add/commit/push at once" },
}
-- nvim spectre (find and replace)
lvim.keys.normal_mode["<leader>S"] = "<cmd>lua require('spectre').open()<CR>"
-- search current word
lvim.keys.normal_mode["<leader>Sw"] = "r<cmd>lua equire('spectre').open_visual({select_word=true})<CR>"
lvim.keys.normal_mode["<leader>SS"] = "<esc>:lua require('spectre').open_visual()<CR>"
--  search in current file
lvim.keys.normal_mode["<leader>Sf"] = "viw:lua require('spectre').open_file_search()<cr>"

lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- Flutter
lvim.builtin.which_key.mappings["F"] = {
  name = "+Flutter",
  a = { "<cmd>FlutterRun<cr>", "Run, no flavors" },
  b = { "<cmd>ter flutter pub run build_runner build -d<cr>", "Run build runner" },
  c = { "<cmd>Telescope flutter commands<cr>", "Open Flutter Commans" },
  d = { "<cmd>FlutterDevices<cr>", "Flutter Devices" },
  D = { "<cmd>FlutterRun --flavor development -t lib/main_development.dart<cr>", "Run development" },
  e = { "<cmd>FlutterEmulators<cr>", "Flutter Emulators" },
  o = { "<cmd>FlutterOutlineToggle<cr>", "Toggle outline" },
  P = { "<cmd>FlutterRun --flavor production -t lib/main_production.dart<cr>", "Run production" },
  r = { "<cmd>FlutterReload<cr>", "Hot Reload App" },
  R = { "<cmd>FlutterRestart<cr>", "Hot Restart app" },
  S = { "<cmd>FlutterRun --flavor staging -t lib/main_staging.dart<cr>", "Run staging" },
  t = { "<cmd>FlutterDevTools<cr>", "Start dev tools" },
  q = { "<cmd>FlutterQuit<cr>", "Quit running application" },
  v = { "<cmd>Telescope flutter fvm<cr>", "Flutter version" },
  x = { "<cmd>FlutterLogClear<cr>", "Clear log" },
}

lvim.builtin.which_key.mappings["G"] = {
  d = { "<cmd>ter fvm flutter run --flavor development -t lib/main_development.dart<cr>", "Run dev" },
  p = { "<cmd>ter fvm flutter run --flavor production -t lib/main_production.dart<cr>", "Run prod" },
  s = { "<cmd>ter fvm flutter run --flavor staging -t lib/main_staging.dart<cr>", "Run dev" },
  t = { "<cmd>ter fvm dart format . && fvm flutter analyze lib test && fvm flutter test<cr>", "Test" },
  b = { "<cmd>ter fvm flutter pub run build_runner build -d<cr>", "Build" },
  g = { "<cmd>ter fvm flutter pub get<cr>", "Pub get" },
  c = {
    "<cmd>ter very_good test --coverage --exclude-coverage 'lib/{**/*.g.dart, gen/**/*.dart, firebase_options_*.dart}' --min-coverage 100<cr>",
    "Run tests with coverage check" },
}

lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
}

lvim.builtin.which_key.mappings["n"] = {
  name = "+neotest",
  n = { "<cmd>lua require('neotest').run.run()<cr>", "Nearest" },
  f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "File" },
  d = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Debug nearest" },
  o = { "<cmd>lua require('neotest').output.open({ enter = true })<cr>", "Open output window" },
  p = { "<cmd>lua require('neotest').output_panel.toggle()<cr>", "Toggle output panel" },
  s = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Toggle summary panel" },
}

-- PLUGIN SETTINGS
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "typescript",
  "tsx",
  "yaml",
  "dart",
  "ruby",
  "markdown",
  "markdown_inline",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

-- generic LSP settings
lvim.lsp.installer.setup.ensure_installed = {
  "jsonls",
  "tsserver",
}

---@usage disable automatic installation of servers
lvim.lsp.installer.setup.automatic_installation = false

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
  { command = "isort", filetypes = { "python" } },
  {
    -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "prettier",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    extra_args = { "--print-with", "100", "--single-quote" },
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "typescript", "typescriptreact", 'javascript', 'javascriptreact' },
  },
}

-- Flutter snippets enable
local luasnip = require("luasnip")
luasnip.filetype_extend("dart", { "flutter" })

-- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    command = "eslint_d",
    filetypes = {
      "javascript", "javascriptreact",
      "typescript", "typescriptreact"
    }
  }
}

-- Additional Plugins
lvim.plugins = {
  {
    "MTDL9/vim-log-highlighting",
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
    },
    cmd = "TroubleToggle",
  },
  {
    "mg979/vim-visual-multi",
  },
  {
    'sidlatau/neotest-dart',
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter"
    },
    config = function()
    end
  },
  {
    "nvim-neotest/neotest",
    dependencies = { 'sidlatau/neotest-dart' },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-dart') {
            command = 'fvm flutter',
            use_lsp = true,
          },
        }
      })
    end
  },
  {
    "vim-test/vim-test",
  },
  {
    "tpope/vim-surround",
  },
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = { "fugitive" }
  },
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    config = function()
      require('flutter-tools').setup {
        flutter_path = ".fvm/flutter_sdk/bin/flutter.bat",
        -- fvm = true, -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
        ui = {
          border = "rounded",
          notification_style = "plugin",
        },
        decorations = {
          statusline = {
            app_version = true,
            device = true,
          },
        },
        outline = {
          open_cmd = "30vnew", -- command to use to open the outline buffer
          auto_open = false,   -- if true this will open the outline automatically when it is first populated
        },
        debugger = {
          enabled = false,
          run_via_dap = false,
          register_configurations = function(_)
            local dap = require("dap")
            dap.set_log_level("TRACE")
            dap.configurations.dart = {}
            require("dap.ext.vscode").load_launchjs()
          end,
        },
        dev_log = {
          enabled = true,
        },
        lsp = {
          color = {
            enabled = true,
            background = true,      -- highlight the background
            foreground = false,     -- highlight the foreground
            virtual_text = true,    -- show the highlight using virtual text
            virtual_text_str = "■", -- the virtual text character to highlight
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
            enableSdkFormatter = true,
            lineLength = 80,
          },
        },
      }
    end
  },
  {
    "github/copilot.vim"
  },
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      local saga = require("lspsaga")

      saga.setup({
        move_in_saga = { prev = "<C-k>", next = "<C-j>" },
        finder = {
          open = "<CR>",
        },
        definition = {
          edit = "<CR>",
        },
        diagnostic = {
          max_width = 0.8,
          max_show_width = 0.9,
        },
        request_timeout = 3000,
        lightbulb = {
          enable = false,
        },
      })

      local keymap = vim.keymap.set

      -- Lsp finder find the symbol definition implement reference
      -- if there is no implement it will hide
      -- when you use action in finder like open vsplit then you can
      -- use <C-t> to jump back>
      keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

      keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")
      keymap("n", "<leader>sw", "<cmd>Lspsaga show_workspace_diagnostics<CR>")
      keymap("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")

      -- Rename
      keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })

      keymap({ "n", "v" }, "<leader>ac", "<cmd>Lspsaga code_action<CR>")

      -- Peek Definition
      -- you can edit the definition file in this flaotwindow
      -- also support open/vsplit/etc operation check definition_action_keys
      -- support tagstack C-t jump back
      keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

      -- Hover Doc
      keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

      -- Float terminal
      keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm<CR>", { silent = true })
      keymap("n", "∂", "<cmd>Lspsaga open_floaterm<CR>", { silent = true }) -- macos ALT+d(Option+d) binding
      -- close floaterm
      keymap("t", "<A-d>", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], { silent = true })
      keymap("t", "∂", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], { silent = true }) -- macos ALT+d(Option+d) binding
    end,
  },
  {
    "windwp/nvim-spectre",
    config = function()
      require("spectre").setup()
    end,
  },
  {
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup {}
    end
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    config = function()
      require("git-worktree").setup({
      })
    end
  }
}

-- copilot config
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""
lvim.builtin.cmp.mapping["<C-w>"] = function(fallback)
  local copilot_keys = vim.fn["copilot#Accept"]()
  if copilot_keys ~= "" then
    vim.api.nvim_feedkeys(copilot_keys, "i", true)
  else
    fallback()
  end
end

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.json", "*.jsonc", "*.arb" },
  -- enable wrap mode for json files only
  command = "setlocal wrap",
})

-- Flutter .arb files should be considered as json files
vim.filetype.add {
  extension = {
    arb = 'json',
  }
}
