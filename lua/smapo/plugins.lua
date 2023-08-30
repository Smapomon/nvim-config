-- Define Plugins
require"paq"{
  -- Paq manages itself
  "savq/paq-nvim";

  --theme (bleep bloop)
  "ayu-theme/ayu-vim";
  "nvim-lualine/lualine.nvim";
  "ryanoasis/vim-webdevicons";
  "kyazdani42/nvim-web-devicons"; --for coloured icons
  "rcarriga/nvim-notify"; -- notifications

  {"glepnir/dashboard-nvim", event="VimEnter"};

  --syntax highlighting + lint/hint + language specifics
  "octol/vim-cpp-enhanced-highlight";
  "godlygeek/tabular";
  "norcalli/nvim-colorizer.lua";
  "iamcco/markdown-preview.nvim",
  {"nvim-treesitter/nvim-treesitter", run=':TSUpdate'};
  'andymass/vim-matchup';                               -- better % matcher
  'folke/trouble.nvim';                                 -- diagnostic listing

  --LSP and dependencies
  "neovim/nvim-lspconfig";                           -- Use native LSP
  'gfanto/fzf-lsp.nvim';                             -- fuzzy over lsp
  'nvim-lua/plenary.nvim';                           -- for fzf-lsp
  'mrded/nvim-lsp-notify';                           -- lsp progress
  { 'williamboman/mason.nvim', run=':MasonUpdate' }; -- lsp installer'
  'williamboman/mason-lspconfig.nvim';               -- LSP connection for mason
  'jose-elias-alvarez/null-ls.nvim';                 -- lsp helper

  --git integrations
  "tpope/vim-fugitive";
  "lewis6991/gitsigns.nvim";

  --File Navigation & Search
  "junegunn/fzf.vim";
  "junegunn/fzf";
  "kyazdani42/nvim-tree.lua";
  "akinsho/bufferline.nvim";

  --auto completion
  'windwp/nvim-autopairs';               -- Autopairs
  'windwp/nvim-ts-autotag';              -- Auto close and rename html tags
  "hrsh7th/nvim-cmp";                    -- Autocompletion for LSP
  'hrsh7th/cmp-nvim-lsp';                -- LSP source for nvim-cmp
  'hrsh7th/cmp-buffer';
  'hrsh7th/cmp-nvim-lua';
  'hrsh7th/cmp-path';
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-nvim-lsp-signature-help';
  'saadparwaiz1/cmp_luasnip';            -- Snippets source for nvim-cmp
  'lukas-reineke/cmp-rg';                -- ripgrep source for nvim-cmp
  'zbirenbaum/copilot.lua';              -- github copilot lua version
  'zbirenbaum/copilot-cmp';              -- use copilot as a CMP source

  --comment code
  "preservim/nerdcommenter";

  --surround operations
  "tpope/vim-surround";
  "tpope/vim-repeat";

  --snippets
  'L3MON4D3/LuaSnip';

  -- Folding code
  "kevinhwang91/promise-async";
  "kevinhwang91/nvim-ufo";
}

