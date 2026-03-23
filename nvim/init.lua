-- =============================================================================
-- Bootstrap lazy.nvim
-- =============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- Options
-- =============================================================================
vim.opt.incsearch      = true
vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.ruler          = true
vim.opt.showcmd        = true
vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
vim.opt.smartindent    = true
vim.opt.autoindent     = true
vim.opt.expandtab      = true
vim.opt.history        = 1000
vim.opt.wildmenu       = true
vim.opt.splitright     = true
vim.opt.splitbelow     = true
vim.opt.number         = true
vim.opt.termguicolors = true
vim.opt.mouse          = "a"
vim.opt.updatetime     = 750
vim.opt.fileformat     = "unix"
vim.opt.sessionoptions = "buffers,curdir,winsize"
vim.opt.foldmethod     = "syntax"
vim.opt.foldlevelstart = 10
vim.opt.foldcolumn     = "2"
vim.opt.completeopt    = { "menuone", "noinsert", "noselect" }
vim.opt.autoread       = true
vim.opt.fillchars:append({ eob = " ", vert = "▏" })
vim.opt.wildignore:append({
  "**/obj/**/*",
  "**/node_modules/**/*",
  "**/bin/**/*",
  "**/*.js-snapshots/**",
  "**/test-results/**",
  "**/dist/**",
})

-- =============================================================================
-- Ignore list
-- =============================================================================
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

-- =============================================================================
-- Theme (applied early so plugins inherit it)
-- =============================================================================
-- colorscheme is set after plugins load; see plugins section below

-- =============================================================================
-- Plugins
-- =============================================================================
require("lazy").setup({

  -- --------------------------------------------------------------------------
  -- Theme
  -- --------------------------------------------------------------------------
  {
    "tomasiser/vim-code-dark",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme codedark")
      -- Replicate highlight tweaks
      vim.cmd("hi NonText ctermfg=bg")
      vim.cmd("hi CursorLine ctermbg=235")
      vim.cmd("hi CursorColumn ctermbg=235")
      vim.cmd("hi FoldColumn ctermbg=bg ctermfg=237")
      vim.cmd("hi Folded ctermbg=235")
      vim.cmd("hi VertSplit ctermfg=235")
      vim.cmd("hi! link NvimTreeWinSeparator VertSplit")
    end,
  },

  -- --------------------------------------------------------------------------
  -- UI
  -- --------------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "codedark",
        powerline_fonts = true,
      },
      sections = {
        lualine_c = { "filename" },
        lualine_x = {
          function()
            local wc = vim.fn.wordcount()
            if wc.visual_words then
              return wc.visual_words .. " words (selected)"
            end
            return wc.words .. " words"
          end,
          "encoding", "fileformat", "filetype"
        },
      },
      extensions = { "nvim-tree", "fugitive" },
    },
  },

  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
        custom_filter = function(buf_number)
          if vim.fn.bufname(buf_number) == "" then
            return false
          end
          return true
        end,
      },
    },
  },

  -- --------------------------------------------------------------------------
  -- File tree (replaces NERDTree + nerdtree-git-plugin + vim-nerdtree-syntax-highlight)
  -- --------------------------------------------------------------------------
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 100 },
        renderer = {
          icons = {
            glyphs = {
              git = { unstaged = "✗", staged = "✓", unmerged = "", renamed = "➜",
                      untracked = "★", deleted = "", ignored = "◌" },
            },
          },
          root_folder_label = false,
        },
        filters = {
          dotfiles = true,
          custom = {
            ".DS_Store", "^.git$", "^node_modules$", "^bin$", "^obj$",
            "^tags$", "^packages$", "^logs$", "^dist$", "^.nuxt$",
            "^.public$", "^.temp$", "^test-results$",
          },
        },
      })
    end,
  },

  -- --------------------------------------------------------------------------
  -- Yank ring (replaces YankRing.vim)
  -- --------------------------------------------------------------------------
  {
    "gbprod/yanky.nvim",
    opts = {},
  },

  -- --------------------------------------------------------------------------
  -- Buffer deletion (replaces close-buffers.vim)
  -- --------------------------------------------------------------------------
  { "Asheq/close-buffers.vim" },

  -- --------------------------------------------------------------------------
  -- Motion (replaces vim-wordmotion)
  -- --------------------------------------------------------------------------
  {
    "chaoren/vim-wordmotion",
    init = function()
      vim.g.wordmotion_uppercase_spaces =
        { "'", '"', "<", ">", "(", ")", "{", "}", "[", "]", ".", ",", ":", ";", "$" }
    end,
  },

  -- --------------------------------------------------------------------------
  -- Fuzzy search (replaces fzf + fzf.vim)
  -- --------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "obj/", "node_modules/", "bin/", "dist/", ".nuxt/",
            "test%-results/", "%.js%-snapshots/",
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
      })
    end,
  },

  -- --------------------------------------------------------------------------
  -- Surround (replaces vim-surround)
  -- --------------------------------------------------------------------------
  { "kylechui/nvim-surround", opts = {} },

  -- --------------------------------------------------------------------------
  -- Git (vim-fugitive stays; gitgutter → gitsigns)
  -- --------------------------------------------------------------------------
  { "tpope/vim-fugitive" },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  -- --------------------------------------------------------------------------
  -- Comments (replaces vim-commentary)
  -- --------------------------------------------------------------------------
  { "numToStr/Comment.nvim", opts = {} },

  -- --------------------------------------------------------------------------
  -- Pairs (replaces vim-smartpairs)
  -- --------------------------------------------------------------------------
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  -- --------------------------------------------------------------------------
  -- Markdown (tabular + vim-markdown stay)
  -- --------------------------------------------------------------------------
  { "godlygeek/tabular" },
  {
    "preservim/vim-markdown",
    init = function()
      vim.g.vim_markdown_frontmatter        = 1
      vim.g.vim_markdown_new_list_item_indent = 2
      vim.g.vim_markdown_strikethrough      = 1
      vim.g.vim_markdown_fenced_languages   = { "csharp=cs", "javascript=js" }
      vim.g.vim_markdown_toc_autofit        = 1
      vim.g.vim_markdown_folding_disabled   = 1
    end,
  },

  -- --------------------------------------------------------------------------
  -- Treesitter (replaces vim-javascript + typescript-vim)
  -- --------------------------------------------------------------------------
  {
  "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "c_sharp", "javascript", "typescript", "vue", "json", "html", "css", "lua" },
      highlight = { enable = true },
      indent    = { enable = true },
    },
  },

  -- --------------------------------------------------------------------------
  -- LSP
  -- --------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      vim.lsp.config("ts_ls",  {})
      vim.lsp.config("eslint", {})
      vim.lsp.config("cssls",  {})
      vim.lsp.config("volar",  {})
      vim.lsp.enable({ "ts_ls", "eslint", "cssls", "volar" })
    end,
  },

  -- C# via Roslyn LSP (replaces omnisharp-vim + vim-sharpenup)
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
  },

  -- --------------------------------------------------------------------------
  -- Completion (replaces coc.nvim)
  -- --------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"]   = cmp.mapping.select_next_item(),
          ["<C-p>"]   = cmp.mapping.select_prev_item(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]    = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- --------------------------------------------------------------------------
  -- DAP / Debugging (replaces vimspector)
  -- --------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"]     = dapui.close

      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
        args = { "--interpreter=vscode" },
      }
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch",
          request = "launch",
          program = function()
            local cwd = vim.fn.getcwd()
            local projects = vim.fn.glob(cwd .. "/**/*.csproj", true, true)
            local dlls = {}
            for _, proj in ipairs(projects) do
              local content = vim.fn.readfile(proj)
              local is_runnable = false
              for _, line in ipairs(content) do
                if line:match("<OutputType>Exe</OutputType>")
                  or line:match('Sdk="Microsoft.NET.Sdk.Web"')
                  or line:match("Sdk='Microsoft.NET.Sdk.Web'") then
                  is_runnable = true
                  break
                end
              end
              if is_runnable then
                local name = vim.fn.fnamemodify(proj, ":t:r")
                local matches = vim.fn.glob(cwd .. "/**/bin/Debug/**/" .. name .. ".dll", true, true)
                for _, dll in ipairs(matches) do
                  table.insert(dlls, dll)
                end
              end
            end
            if #dlls == 1 then
              return dlls[1]
            elseif #dlls > 1 then
              local choices = {"Select program:"}
              for i, dll in ipairs(dlls) do
                table.insert(choices, i .. ". " .. dll)
              end
              local idx = vim.fn.inputlist(choices)
              return dlls[idx]
            else
              return vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/", "file")
            end
          end,
        },
      }
    end,
  },

  -- --------------------------------------------------------------------------
  -- CSS color preview (replaces ap/vim-css-color)
  -- --------------------------------------------------------------------------
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      filetypes = { "*", "!markdown" },
    },
  },

  -- --------------------------------------------------------------------------
  -- Session (replaces autosession augroup)
  -- --------------------------------------------------------------------------
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { dir = vim.fn.expand("~/.vim/sessions/") }, -- reuse existing sessions dir
  },

}, {
  -- lazy.nvim options
  ui = { border = "rounded" },
})

-- =============================================================================
-- Cursor shapes
-- =============================================================================
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

-- =============================================================================
-- Cursor line/column
-- =============================================================================
vim.opt.cursorline   = true
vim.opt.cursorcolumn = true

local cursorgroup = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "InsertLeave" }, {
  group = cursorgroup,
  callback = function()
    vim.opt_local.cursorline   = true
    vim.opt_local.cursorcolumn = true
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "InsertEnter" }, {
  group = cursorgroup,
  callback = function()
    vim.opt_local.cursorline   = false
    vim.opt_local.cursorcolumn = false
  end,
})

-- =============================================================================
-- Relative numbers toggle
-- =============================================================================
local numgroup = vim.api.nvim_create_augroup("NumberToggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = numgroup,
  callback = function()
    local ft = vim.bo.filetype
    if ft ~= "NvimTree" and vim.fn.mode() ~= "i" then
      vim.opt_local.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = numgroup,
  callback = function()
    vim.opt_local.relativenumber = false
  end,
})

-- =============================================================================
-- Autoread (replaces vim-autoread)
-- =============================================================================
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  command = "checktime",
})

-- =============================================================================
-- Reload previous buffers
-- =============================================================================
vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  callback = function()
    if vim.fn.argc() == 0 then
      pcall(require("persistence").load)
    end
  end,
})

-- =============================================================================
-- Remove whitespace on save
-- =============================================================================
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.cmd([[%s/\n\+\%$//e]])
    vim.fn.winrestview(save)
  end,
})

-- =============================================================================
-- Roslyn config
-- =============================================================================
vim.lsp.config("roslyn", {
  settings = {
    ["csharp|background_analysis"] = {
      dotnet_analyzer_diagnostics_scope = "openFiles",
      dotnet_compiler_diagnostics_scope = "openFiles",
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
  },
})

-- =============================================================================
-- Filetype overrides
-- =============================================================================
vim.api.nvim_create_augroup("vimrcEx", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "vimrcEx",
  pattern = { "text", "markdown" },
  callback = function()
    vim.opt_local.textwidth  = 80
    vim.opt_local.colorcolumn = "+1"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.tabstop     = 2
    vim.opt_local.shiftwidth  = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab   = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "css" },
  callback = function()
    vim.opt_local.tabstop     = 2
    vim.opt_local.shiftwidth  = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab   = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cs" },
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
    vim.opt_local.foldlevelstart = 99
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "vue", "json", "typescript" },
  callback = function()
    vim.opt_local.foldlevelstart = 30
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.props", "*.targets" },
  command = "set filetype=xml",
})

-- =============================================================================
-- LSP keymaps on attach (replaces omnisharp mappings + coc mappings)
-- =============================================================================
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local map = function(k, v) vim.keymap.set("n", k, v, { buffer = args.buf, silent = true }) end

    map("gd",  vim.lsp.buf.definition)
    map("<A-.>fu", vim.lsp.buf.references)
    map("<A-.>fi", vim.lsp.buf.implementation)
    map("<A-.>pd", vim.lsp.buf.hover)           -- preview definition / hover doc
    map("<A-.>nm", vim.lsp.buf.rename)
    map("<A-.><A-.>",  vim.lsp.buf.code_action)
    map("<A-.>fs", "<cmd>Telescope lsp_document_symbols<CR>")
    map("<A-e><A-e>", function()
      vim.diagnostic.setloclist()
    end)
    map("<A-O>",   function()
      vim.lsp.buf.format({ async = true })
    end)

    -- Signature help
    map("<C-s>", vim.lsp.buf.signature_help)
    vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, { buffer = args.buf, silent = true })

    -- Diagnostics navigation (replaces ]l / [l with ALE)
    map("]l", vim.diagnostic.goto_next)
    map("[l", vim.diagnostic.goto_prev)
  end,
})

-- =============================================================================
-- DAP config
-- =============================================================================
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.bo.filetype:match("^dap") then
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
    end
  end,
})

-- =============================================================================
-- Commands (replaces vimscript commands)
-- =============================================================================

-- DeleteCurrentBuffer
vim.api.nvim_create_user_command("DeleteCurrentBuffer", function()
  if vim.bo.filetype == "NvimTree" then
    vim.cmd("wincmd l")
  end
  if vim.fn.expand("%") ~= "" then
    local curbuf  = vim.fn.bufnr()
    local buflist = vim.fn.getbufinfo({ buflisted = 1 })
    if #buflist <= 1 then
      vim.cmd("enew")
    else
      vim.cmd("bp")
      if vim.bo.buftype == "terminal" then vim.cmd("bp") end
    end
    vim.cmd("bd " .. curbuf)
  end
end, {})

-- Gundo
vim.api.nvim_create_user_command("Gundo", function()
  local f = vim.fn.expand("%")
  if vim.fn.confirm('Undo local changes to "' .. f .. '"?', "&Yes\n&No", 0) == 1 then
    print(vim.fn.system("git checkout HEAD -- " .. f))
    vim.cmd("e!")
  end
end, {})

-- Gcommit
vim.api.nvim_create_user_command("Gcommit", function()
  vim.cmd("G status")
  local message = vim.fn.input("Commit message: ")
  if #message > 0 then
    print(vim.fn.system("git add -A"))
    print(vim.fn.system("git commit -m '" .. message .. "'"))
  end
end, {})

-- RunThis
vim.api.nvim_create_user_command("RunThis", function()
  if vim.bo.filetype == "NvimTree" then vim.cmd("normal! \15") end -- C-W l
  if vim.fn.expand("%") ~= "" then vim.cmd("write") end
  if vim.fn.filereadable("Makefile") == 1 then
    vim.cmd("split | terminal make run")
    vim.cmd("startinsert")
  elseif vim.fn.filereadable("run.sh") == 1 then
    vim.cmd("split | terminal sh run.sh")
    vim.cmd("startinsert")
  else
    print("no run.sh!")
  end
end, {})

-- BuildThis
vim.api.nvim_create_user_command("BuildThis", function()
  if vim.bo.filetype == "NvimTree" then vim.cmd("wincmd l") end
  if vim.fn.expand("%") ~= "" then vim.cmd("write") end
  if vim.fn.filereadable("build.sh") == 1 then
    vim.cmd("split | terminal sh build.sh")
    vim.cmd("startinsert")
  elseif vim.fn.filereadable("Makefile") == 1 then
    vim.cmd("split | terminal make build")
    vim.cmd("startinsert")
  else
    print("no Makefile or build.sh!")
  end
end, {})

-- TestThis
vim.api.nvim_create_user_command("TestThis", function()
  if vim.bo.filetype == "NvimTree" then vim.cmd("wincmd l") end
  if vim.fn.expand("%") ~= "" then vim.cmd("write") end
  if vim.fn.filereadable("test.sh") == 1 then
    vim.cmd("split | terminal sh test.sh")
    vim.cmd("startinsert")
  elseif vim.fn.filereadable("Makefile") == 1 then
    vim.cmd("split | terminal make test")
    vim.cmd("startinsert")
  else
    print("no Makefile or test.sh!")
  end
end, {})

-- PushThis
vim.api.nvim_create_user_command("PushThis", function()
  if vim.bo.filetype == "NvimTree" then vim.cmd("wincmd l") end
  if vim.fn.expand("%") ~= "" then vim.cmd("write") end
  if vim.fn.filereadable("Makefile") == 1 then
    vim.cmd("split | terminal make push")
    vim.cmd("startinsert")
  elseif vim.fn.filereadable("push.sh") == 1 then
    vim.cmd("split | terminal sh push.sh")
    vim.cmd("startinsert")
  else
    print("no push.sh!")
  end
end, {})

-- =============================================================================
-- Key mappings
-- =============================================================================
local map = vim.keymap.set

-- Open vimrc/init.lua
map("n", "<A-,>", ":e ~/.config/nvim/init.lua<CR>")

-- Semicolon behaviours
map("i", "<A-;>", "<End>;")
map("n", "<A-;>", "A;<Esc>")
map("n", ";", ":")  -- ; opens command without shift (kept as-is)

-- Clear search on escape
map("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- Buffer management
map("n", "<A-w>", ":DeleteCurrentBuffer<CR>")
map("n", "<A-W>", ":Bdelete hidden<CR>")

-- Close / quit
map("n", "<A-q><A-w>", ":close<CR>")
map("n", "<A-q><A-q>", ":qa<CR>")

-- Save
map("n", "<A-s>", ":w<CR>")
map("n", "<A-S>", ":wa<CR>")

-- Window navigation
map("n", "<A-l>", "<C-W>l")
map("n", "<A-h>", "<C-W>h")
map("n", "<A-j>", "<C-W>j")
map("n", "<A-k>", "<C-W>k")
map("t", "<A-l>", "<C-\\><C-n><C-W>l")
map("t", "<A-h>", "<C-\\><C-n><C-W>h")
map("t", "<A-j>", "<C-\\><C-n><C-W>j")
map("t", "<A-k>", "<C-\\><C-n><C-W>k")

-- Buffer navigation
map("n", "<A-L>", ":bn<CR>")
map("t", "<A-L>", "<C-w>:bn<CR>")
map("n", "<A-H>", ":bp<CR>")
map("t", "<A-H>", "<C-w>:bp<CR>")

-- Move lines
map("n", "<A-J>", "ddp")
map("n", "<A-K>", "ddkkp")

-- Split line (opposite of J)
map("n", "K", "i<CR><Esc>l")

-- NvimTree
map("n", "<A-n>", ":NvimTreeToggle<CR>")
map("t", "<A-n>", "<C-w>:NvimTreeToggle<CR>")
map("n", "<A-f>", ":NvimTreeFindFile<CR><C-W>l")

-- Yank ring (replaces YRShow)
map("n", "<A-p>", ":YankyRingHistory<CR>")

-- Clipboard
map({ "n", "v" }, "<A-v>", '"+P')   -- paste from clipboard
map({ "n", "v" }, "<A-c>", '"+y')   -- yank to clipboard

-- Select all
map("n", "<A-a>", "ggVG")

-- Window resize
map("n", "<A->>", "<C-w>>")
map("n", "<A-<>", "<C-w><")

-- Run / build / test / push
map("n", "<A-r><A-r>", ":RunThis<CR>")
map("n", "<A-r><A-p>", ":PushThis<CR>")
map("n", "<A-b>",  ":BuildThis<CR>")
map("n", "<A-r>a", ":TestThis<CR>")

-- Replace char with x
map("n", "<A-x>", "rx")

-- Telescope (replaces FZF)
map("n", "<A-t>",  ":Telescope find_files<CR>")
map("n", "<A-t><A-t>", ":Telescope git_files<CR>")

-- Fugitive
map("n", "<A-g><A-g>", ":G<CR>")
map("n", "<A-g><A-s>", ":G status<CR>")
map("n", "<A-g><A-c>", ":Gcommit<CR>")
map("n", "<A-g><A-p>", ":G push<CR>")
map("n", "<A-g><A-P>", ":G pull<CR>")
map("n", "<A-g><A-d>", ":Gvdiffsplit!<CR>")
map("n", "<A-g><A-r>", ":Gundo<CR>", { silent = true })

-- DAP (replaces vimspector VISUAL_STUDIO mappings)
map("n", "<F5>",  function() require("dap").continue() end)
map("n", "<F10>", function() require("dap").step_over() end)
map("n", "<F11>", function() require("dap").step_into() end)
map("n", "<F12>", function() require("dap").step_out() end)
map("n", "<F9>",  function() require("dap").toggle_breakpoint() end)
