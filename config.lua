--[[
based on: https://gist.github.com/Antoniozinchenko/b7e1d3679a88ec4f1b3a3bd6e5b44961

1. Install and enable some NerdFont
2. :Lazy
3. :checkhealth and fix issues
]]

require "powershell"
require "flutter"
require "java"

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
lvim.keys.normal_mode['gd'] = "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>"
lvim.keys.normal_mode['gh'] = "<cmd>lua require('telescope.builtin').lsp_references()<CR>"
lvim.keys.normal_mode['gr'] = "<cmd>lua vim.lsp.buf.rename()<CR>"
lvim.keys.normal_mode['ga'] = "<cmd>lua vim.lsp.buf.code_action()<CR>"

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
lvim.keys.normal_mode['<leader>F'] = ":lua require'telescope.builtin'.find_files{}<CR>"
lvim.keys.normal_mode['<leader>D'] = ":lua require'telescope.builtin'.live_grep{}<CR>"
lvim.keys.normal_mode['<leader>H'] = ":lua require'telescope.builtin'.oldfiles{}<CR>"
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

lvim.builtin.telescope.pickers = {
  find_files = {
    layout_strategy = 'horizontal',
    layout_config = {
      width = 0.95,
      height = 0.7,
    }
  },
  live_grep = {
    layout_strategy = 'horizontal',
    layout_config = {
      width = 0.95,
      height = 0.7,
    },
  },
  oldfiles = {
    layout_strategy = 'horizontal',
    layout_config = {
      width = 0.95,
      height = 0.7,
    },
  },
}

-- Fugitive/git
-- TODO: make this work, should add some confirmation pop-up
function RemoveAllLocalGitBranches()
  if (IsWindows()) then
    -- PowerShell
    vim.cmd [[git branch | grep -v "develop" | grep -v "master" | grep -v "main" | xargs git branch -D]]
  else
    vim.cmd [[!git branch -D $(git branch | grep -v "master" | xargs)]]
  end
end

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
-- Fetch fix: https://morgan.cugerone.com/blog/workarounds-to-git-worktree-using-bare-repository-and-cannot-fetch-remote-branches/
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

lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  -- TODO: do I still need trouble? revmoe in favor of telescope + quickfix?
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
      if (IsWindows()) then
        local config = {
          cmd = { 'C:/users/conta/AppData/Roaming/lunarvim/lvim/utils/bin' },
          root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
        }
        require('jdtls').start_or_attach(config)
      end
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
