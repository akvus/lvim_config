--[[
based on: https://gist.github.com/Antoniozinchenko/b7e1d3679a88ec4f1b3a3bd6e5b44961

1. Install and enable some NerdFont
2. :PackerSync
3. :checkhealth and fix issues
]]
lvim.log.level = "warn"
lvim.format_on_save.enabled = true
lvim.colorscheme = "gruvbox"
vim.opt.relativenumber = true
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = ","
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )
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
lvim.keys.normal_mode["<leader>i"] = ":NvimTreeToggle<CR>"
lvim.keys.normal_mode["<F3>"] = ":NvimTreeFindFile<CR>"

-- Resize splits
lvim.keys.normal_mode["<leader>="] = ":vert res +10<CR>"
lvim.keys.normal_mode["<leader>-"] = ":vert res -10<CR>"

-- LSP
lvim.keys.normal_mode["g["] = ":lua vim.diagnostic.goto_next()<CR>"
lvim.keys.normal_mode["g]"] = ":lua vim.diagnostic.goto_prev()<CR>"
lvim.keys.normal_mode['<leader>ac'] = "<cmd>lua vim.lsp.buf.code_action()<CR>"
lvim.keys.normal_mode['<leader>aw'] = "<cmd>lua vim.lsp.buf.code_action()<CR>"

-- Telescope 
lvim.keys.normal_mode['<leader>T'] = ":Telescope<CR>"
lvim.keys.normal_mode['<leader>F'] = ":lua require'telescope.builtin'.live_grep{}<CR>"
lvim.keys.normal_mode['<leader>H'] = ":lua require'telescope.builtin'.oldfiles{}<CR>"

-- Fugitive
lvim.builtin.which_key.mappings["g"] = {
  name = "+Git",
  p = { "<cmd>G push<cr>", "Git push" },
  l = { "<cmd>G pull<cr>", "Git pull" },
  f = { "<cmd>G fetch<cr>", "Git fetch" },
  a = { "<cmd>G add .<cr>", "Git add all" },
  s = { "<cmd>G status<cr>", "Git status" },
  d = { "<cmd>G diff<cr>", "Git diff" },
}

-- Flutter
lvim.keys.normal_mode['<leader>cl'] = ":FlutterLogClear<CR>"

-- nvim spectre (find and replace)
lvim.keys.normal_mode["<leader>S"] = "<cmd>lua require('spectre').open()<CR>"

-- search current word
lvim.keys.normal_mode["<leader>Sw"] = "r<cmd>lua equire('spectre').open_visual({select_word=true})<CR>"
lvim.keys.normal_mode["<leader>SS"] = "<esc>:lua require('spectre').open_visual()<CR>"
--  search in current file
lvim.keys.normal_mode["<leader>Sf"] = "viw:lua require('spectre').open_file_search()<cr>"
-- run command :Spectre

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
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

-- lvim.builtin.theme.options.dim_inactive = true
-- lvim.builtin.theme.options.style = "storm"

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["F"] = {
  name = "+Flutter",
  c = { "<cmd>Telescope flutter commands<cr>", "Open Flutter Commans" },
  x = { "<cmd>FlutterLogClear<cr>", "Clear log" },
  t = { "<cmd>FlutterDevTools<cr>", "Start dev tools" },
  o = { "<cmd>FlutterOutlineToggle<cr>", "Toggle outline" },
  d = { "<cmd>FlutterDevices<cr>", "Flutter Devices" },
  e = { "<cmd>FlutterEmulators<cr>", "Flutter Emulators" },
  r = { "<cmd>FlutterReload<cr>", "Hot Reload App" },
  R = { "<cmd>FlutterRestart<cr>", "Hot Restart app" },
  q = { "<cmd>FlutterQuit<cr>", "Quit running application" },
  v = { "<cmd>Telescope flutter fvm<cr>", "Flutter version" },
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

-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
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
  "css",
  "yaml",
  "dart",
  "ruby",
  "markdown",
  "markdown_inline",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

-- generic LSP settings

-- -- make sure server will always be installed even if the server is in skipped_servers list
lvim.lsp.installer.setup.ensure_installed = {
  "jsonls",
  "tsserver",
}

---@usage disable automatic installation of servers
lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

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
  -- {
  --   -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
  --   command = "shellcheck",
  --   ---@usage arguments to pass to the formatter
  --   -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
  --   extra_args = { "--severity", "warning" },
  -- },
  {
    command = "eslint_d",
    filetypes = {
      "javascript", "javascriptreact",
      "typescript", "typescriptreact"
    }
  }
  -- {
  --   command = "codespell",
  --   ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
  --   filetypes = { "javascript", "typescript" },
  -- },
}

-- Additional Plugins
lvim.plugins = {
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "MTDL9/vim-log-highlighting",
  },
  {
    "ellisonleao/gruvbox.nvim",
  },
  { 
    "mg979/vim-visual-multi",
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
    ft = {"fugitive"}
  },
  {
    "akinsho/flutter-tools.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require('flutter-tools').setup {
        -- flutter_path = "C:/Users/conta/flutter/bin/flutter.bat",
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
          auto_open = false, -- if true this will open the outline automatically when it is first populated
        },
        debugger = {
          enabled = false,
          run_via_dap = false,
          register_configurations = function(_)
            local dap = require("dap")
            -- dap.adapters.dart = {
            -- 	type = "executable",
            -- 	command = "node",
            -- 	args = { debugger_path, "flutter" },
            -- }
            dap.set_log_level("TRACE")
            dap.configurations.dart = {}
            require("dap.ext.vscode").load_launchjs()
          end,
        },
        dev_log = {
          enabled = true,
          -- open_cmd = "tabedit",
        },
        lsp = {
          color = { -- show the derived colours for dart variables
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
          },
        },
      }
    end
  },
 -- Syntax highlight for mdx files: used by Storybook
  { "jxnblk/vim-mdx-js" },
  -- { "github/copilot.vim" },
  {
    "glepnir/lspsaga.nvim",
    config = function()
      local saga = require("lspsaga")

      saga.setup({
        -- keybinds for navigation in lspsaga window
        move_in_saga = { prev = "<C-k>", next = "<C-j>" },
        -- use enter to open file with finder
        finder = {
          open = "<CR>",
        },
        -- use enter to open file with definition preview
        definition = {
          edit = "<CR>",
        },
      })

      local keymap = vim.keymap.set

      -- Lsp finder find the symbol definition implement reference
      -- if there is no implement it will hide
      -- when you use action in finder like open vsplit then you can
      -- use <C-t> to jump back
      keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

      -- Rename
      keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })

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
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
      }
    end
  }

}

-- copilot additional configs
-- vim.g.copilot_no_tab_map = true
-- vim.g.copilot_assume_mapped = true
-- vim.g.copilot_tab_fallback = ""
-- lvim.builtin.cmp.mapping["<Tab>"] = function(fallback)
--   local copilot_keys = vim.fn["copilot#Accept"]()
--   if copilot_keys ~= "" then
--     vim.api.nvim_feedkeys(copilot_keys, "i", true)
--   else
--     fallback()
--   end
-- end


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

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })

require("packer").init({
	max_jobs = 10,
})
