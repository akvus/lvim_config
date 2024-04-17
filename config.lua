--[[
based on: https://gist.github.com/Antoniozinchenko/b7e1d3679a88ec4f1b3a3bd6e5b44961

1. Install and enable some NerdFont
2. :Lazy
3. :checkhealth and fix issues

Remove all branches but master PowerShell:  git branch -D  @(git branch | select-string -NotMatch "master" | Foreach {$_.Line.Trim()})

C:\Users\conta\AppData\Local\lvim
C:\Users\conta\AppData\Roaming\lunarvim



-- Defaults that came with LunarVim 1.3
vim.opt.shell = "pwsh.exe -NoLogo"
vim.opt.shellcmdflag =
"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
vim.cmd [[
		let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
		let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
		set shellquote= shellxquote=

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
]]


-- SETTINGS
lvim.log.level = "warn"
lvim.format_on_save.enabled = true
vim.opt.relativenumber = true
lvim.leader = ","

-- TODO consider replacing with https://github.com/coffebar/neovim-project since original plugin is no longer maintained
-- Set what files make a directory root of a project
-- defaults include other VCSs, Makefile, package.json
lvim.builtin.project.patterns = { ">Projects", ".git", "pubspec.yaml", "pom.xml" }

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
-- Move between quick fixes
lvim.keys.normal_mode["<space>j"] = ":cnext<CR>"
lvim.keys.normal_mode["<space>k"] = ":cprev<CR>"
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
lvim.keys.normal_mode['K'] = "<cmd>lua vim.lsp.buf.hover()<CR>"
lvim.keys.normal_mode['gi'] = "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>"
--lvim.keys.normal_mode['gi'] = "<cmd>lua vim.lsp.buf.implementation()<CR>"
lvim.keys.normal_mode['gd'] = "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>"
--lvim.keys.normal_mode['gd'] = "<cmd>lua vim.lsp.buf.definition()<CR>"
lvim.keys.normal_mode['gh'] = "<cmd>lua require('telescope.builtin').lsp_references()<CR>"
--lvim.keys.normal_mode['gh'] = "<cmd>lua vim.lsp.buf.references()<CR>"
lvim.keys.normal_mode['gr'] = "<cmd>lua vim.lsp.buf.rename()<CR>"

-- TODO: decide on one... :D
lvim.keys.normal_mode['ga'] = "<cmd>lua vim.lsp.buf.code_action()<CR>"
lvim.keys.normal_mode['<leader>aw'] = "<cmd>lua vim.lsp.buf.code_action()<CR>"

-- CMP
lvim.builtin.cmp.sources = {
  { name = "nvim_lsp", group_index = 2 },
  { name = "path",     group_index = 2 },
  { name = "luasnip",  group_index = 2 },
}

-- Telescope
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
    ["<C-c>"] = actions.close,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}
lvim.keys.normal_mode['<leader>T'] = ":Telescope<CR>"
lvim.keys.normal_mode['<leader>D'] = ":lua require'telescope.builtin'.live_grep{}<CR>"
lvim.keys.normal_mode['<leader>H'] = ":lua require'telescope.builtin'.oldfiles{}<CR>"
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.telescope.on_config_done = function(telescope)
  telescope.load_extension "flutter"
end
lvim.builtin.telescope.pickers = {
  find_files = {
    layout_strategy = 'horizontal',
    layout_config = {
      width = 0.95,
      height = 0.7,
    },
  },
  live_grep = {
    layout_strategy = 'horizontal',
    layout_config = {
      width = 0.95,
      height = 0.7,
    },
  },
}

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

-- worktree
list_worktrees = function()
  require('g-worktree').setup()
  require('telescope').extensions.g_worktree.list()
end

lvim.builtin.which_key.mappings["W"] = {
  name = "+Worktree",
  l = { "<cmd>lua list_worktrees()<cr>",
    "List with some other plugin" },
  c = { "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>", "Create" },
}

-- Flutter
lvim.builtin.which_key.mappings["F"] = {
  name = "+Flutter",
  a = { "<cmd>FlutterRun<cr>", "Run, no flavors" },
  b = { "<cmd>ter fvm flutter pub run build_runner build -d<cr>", "Run build runner" },
  c = { "<cmd>ter fvm flutter clean<cr>", "Flutter clean" },
  l = { "<cmd>Telescope flutter commands<cr>", "Open Flutter Commans" },
  d = { "<cmd>FlutterDevices<cr>", "Flutter Devices" },
  D = { "<cmd>FlutterRun --flavor development -t lib/main_development.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run development" },
  e = { "<cmd>FlutterEmulators<cr>", "Flutter Emulators" },
  o = { "<cmd>FlutterOutlineToggle<cr>", "Toggle outline" },
  P = { "<cmd>FlutterRun --flavor production -t lib/main_production.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run production" },
  r = { "<cmd>FlutterReload<cr>", "Hot Reload App" },
  R = { "<cmd>FlutterRestart<cr>", "Hot Restart app" },
  S = {
    "<cmd>FlutterRun --flavor staging -t lib/main_staging.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run staging" },
  SR = {
    "<cmd>FlutterRun --release --flavor staging -t lib/main_staging.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run staging release" },
  t = { "<cmd>FlutterDevTools<cr>", "Start dev tools" },
  q = { "<cmd>FlutterQuit<cr>", "Quit running application" },
  v = { "<cmd>Telescope flutter fvm<cr>", "Flutter version" },
  x = { "<cmd>FlutterLogClear<cr>", "Clear log" },
  w = { "<cmd>ter fvm dart run build_runner watch<cr>", "Build runner watch" },
}

-- Java
lvim.builtin.which_key.mappings["J"] = {
  -- TODO: think of writing a script to unify all my run commands for all types of projects
  m = { "<cmd>ter ./mvnw spring-boot:run<cr>", "Run spring boot with maven" },
}


-- Flutter command line
lvim.builtin.which_key.mappings["G"] = {
  d = {
    "<cmd>ter fvm flutter run --flavor development -t lib/main_development.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run development" },
  p = {
    "<cmd>ter fvm flutter run --flavor production -t lib/main_production.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run production" },
  P = {
    "<cmd>ter fvm flutter run --release --flavor production -t lib/main_production.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run production" },
  s = {
    "<cmd>ter fvm flutter run --flavor staging -t lib/main_staging.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run staging" },
  S = {
    "<cmd>ter fvm flutter run --release --flavor staging -t lib/main_staging.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run staging release" },
  t = { "<cmd>ter fvm dart format . && fvm flutter analyze lib test && fvm flutter test<cr>", "Test" },
  b = { "<cmd>ter fvm flutter pub run build_runner build -d<cr>", "Build" },
  g = { "<cmd>ter fvm flutter pub get<cr>", "Pub get" },
  c = {
    "<cmd>ter very_good test --coverage --exclude-coverage 'lib/{**/*.g.dart, gen/**/*.dart, firebase_options_*.dart}' --min-coverage 100<cr>",
    "Run tests with coverage check" },
}

lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  -- TODO: do I still need trouble? revmoe in favor of telescope + quickfix?
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  i = { "<cmd>Trouble lsp_implementations<cr>", "Implementations" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  t = { "<cmd>Trouble lsp_type_definitions<cr>", "Type Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
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
  "java",
  "javascript",
  "json",
  "lua",
  "typescript",
  "tsx",
  "yaml",
  "dart",
  "kotlin",
  "markdown",
  "markdown_inline",
}

lvim.builtin.treesitter.ignore_install = { "haskell", "php" }
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

-- Additional Plugins
lvim.plugins = {
  {
    'fei6409/log-highlight.nvim',
    config = function()
      require('log-highlight').setup {}
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      position = "bottom",            -- position of the list can be: bottom, top, left, right
      height = 10,                    -- height of the trouble list when position is top or bottom
      width = 50,                     -- width of the list when position is left or right
      icons = true,                   -- use devicons for filenames
      mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
      severity = nil,                 -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
      cycle_results = true,           -- cycle item list when reaching beginning or end of list
      action_keys = {
        -- key mappings for actions in the trouble list
        -- map to {} to remove a mapping, for example:
        -- close = {},
        close = "q",                                                                        -- close the list
        cancel = "<esc>",                                                                   -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r",                                                                      -- manually refresh
        jump = { "<cr>", "<tab>", "<2-leftmouse>" },                                        -- jump to the diagnostic or open / close folds
        open_split = { "<c-x>" },                                                           -- open buffer in new split
        open_vsplit = { "<c-v>" },                                                          -- open buffer in new vsplit
        open_tab = { "<c-t>" },                                                             -- open buffer in new tab
        jump_close = { "o" },                                                               -- jump to the diagnostic and close the list
        toggle_mode = "m",                                                                  -- toggle between "workspace" and "document" diagnostics mode
        switch_severity = "s",                                                              -- switch "diagnostics" severity filter level to HINT / INFO / WARN / ERROR
        toggle_preview = "P",                                                               -- toggle auto_preview
        hover = "K",                                                                        -- opens a small popup with the full multiline message
        preview = "p",                                                                      -- preview the diagnostic location
        open_code_href = "c",                                                               -- if present, open a URI with more information about the diagnostic error
        close_folds = { "zM", "zm" },                                                       -- close all folds
        open_folds = { "zR", "zr" },                                                        -- open all folds
        toggle_fold = { "zA", "za" },                                                       -- toggle fold of current file
        previous = "k",                                                                     -- previous item
        next = "j",                                                                         -- next item
        help = "?"                                                                          -- help menu
      },
      multiline = true,                                                                     -- render multi-line messages
      indent_lines = true,                                                                  -- add an indent guide below the fold icons
      win_config = { border = "single" },                                                   -- window configuration for floating windows. See |nvim_open_win()|.
      auto_open = false,                                                                    -- automatically open the list when you have diagnostics
      auto_close = true,                                                                    -- automatically close the list when you have no diagnostics
      auto_preview = true,                                                                  -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
      auto_fold = false,                                                                    -- automatically fold a file trouble list at creation
      auto_jump = { "lsp_definitions" },                                                    -- for the given modes, automatically jump if there is only a single result
      include_declaration = { "lsp_references", "lsp_implementations", "lsp_definitions" }, -- for the given modes, include the declaration of the current symbol in the results
      signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "",
      },
      use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
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
  -- Plenary is included in LVIM, but it's not getting updated
  {
    "nvim-lua/plenary.nvim",
    commit = "8aad439",
  },
  -- Telecsope is included in LVIM, but it's not getting updated
  {
    "nvim-telescope/telescope.nvim",
    commit = "31ddbea",
  },
  {
    "akvus/g-worktree.nvim",
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
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-w>",
            accept_word = false,
            accept_line = false,
            next = "<C-[>",
            prev = "<C-]>",
            dismiss = "<C-d>",
          },
        },
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup {}
    end
  },
  {
    "mfussenegger/nvim-jdtls",
    config = function()
      local config = {
        --cmd = { 'C:/users/conta/AppData/Roaming/lunarvim/lvim/utils/bin' },
        --root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
      }
      require('jdtls').start_or_attach(config)
    end
  }
}

-- copilot config
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

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
