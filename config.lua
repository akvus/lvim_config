--[[
1. Install and enable some NerdFont
2. :Lazy
3. :checkhealth and fix issues

- <leader>d for DAP
]]

require "powershell"
require "flutter"
require "javaconfig"

require('lspconfig').kotlin_language_server.setup {}

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
lvim.keys.normal_mode['gi'] = "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>"
lvim.keys.normal_mode['gd'] = "<cmd>lua vim.lsp.buf.definition()<CR>"
lvim.keys.normal_mode['gD'] = "<cmd>lua vim.lsp.buf.declaration()<CR>"
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
  "kotlin",
  "javascript",
  "json",
  "lua",
  "typescript",
  "tsx",
  "yaml",
  "dart",
  "markdown",
  "markdown_inline",
  "python",
}

lvim.builtin.treesitter.ignore_install = { "haskell", "php" }
lvim.builtin.treesitter.highlight.enable = true

-- generic LSP settings
lvim.lsp.installer.setup.ensure_installed = {
  "jsonls",
  "tsserver",
  "kotlin_language_server",
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
    "mg979/vim-visual-multi",
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      -- REQUIRED
      harpoon:setup()
      -- REQUIRED

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<C-S-J>", function() harpoon:list():prev() end)
      vim.keymap.set("n", "<C-S-K>", function() harpoon:list():next() end)
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      'sidlatau/neotest-dart',
      "nvim-neotest/nvim-nio",
    },
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
    -- commit = "8aad439",
  },
  -- Telecsope is included in LVIM, but it's not getting updated
  {
    "nvim-telescope/telescope.nvim",
    -- commit = "31ddbea",
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
        -- flutter_path = ".fvm/flutter_sdk/bin/flutter.bat",
        fvm = true, -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
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
            background = true, -- highlight the background
            foreground = false, -- highlight the foreground
            virtual_text = true, -- show the highlight using virtual text
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
    'nvim-java/nvim-java',
    config = function()
      require('java').setup({})
      require('lspconfig').jdtls.setup({
        settings = {
          java = {
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-21",
                  path = "/opt/jdk-21",
                  default = true,
                }
              }
            }
          }
        }
      })
    end,
    dependencies = {
      'nvim-java/lua-async-await',
      'nvim-java/nvim-java-refactor',
      'nvim-java/nvim-java-core',
      'nvim-java/nvim-java-test',
      'nvim-java/nvim-java-dap',
      'MunifTanjim/nui.nvim',
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      {
        'JavaHello/spring-boot.nvim',
        commit = '218c0c26c14d99feca778e4d13f5ec3e8b1b60f0',
      },
      {
        'williamboman/mason.nvim',
        config = function(_, opts)
          local conf = vim.tbl_deep_extend('keep', opts, {
            ui = {
              icons = {
                package_installed = '✓',
                package_pending = '➜',
                package_uninstalled = '✗',
              },
            },
            registries = {
              'github:nvim-java/mason-registry',
              'github:mason-org/mason-registry',
            },
          })
          -- ^^^^^ Here we are basically merge you configuration with OPTS
          -- OPTS contains configurations defined elsewhere like nvim-java

          require('mason').setup(conf)
        end,
      },
    },

  },
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
