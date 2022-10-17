-- Define Plugins
require"paq"{
  -- Paq manages itself
  "savq/paq-nvim";

  --theme (bleep bloop)
  "liuchengxu/space-vim-theme";
  "nvim-lualine/lualine.nvim";
  "jacoborus/tender.vim"; -- lightline colorscheme
  "ryanoasis/vim-webdevicons";
  "kyazdani42/nvim-web-devicons"; --for coloured icons

  --syntax highlighting + lint/hint + language specifics
  "octol/vim-cpp-enhanced-highlight";
  "godlygeek/tabular";
  "chrisbra/colorizer";
  "ellisonleao/glow.nvim";
  'tpope/vim-rails';

  "vim-ruby/vim-ruby"; --Ruby motions and other stuff
  {"nvim-treesitter/nvim-treesitter", run=':TSUpdate'};

  --LSP and dependencies
  "neovim/nvim-lspconfig";    -- Use native LSP
  'gfanto/fzf-lsp.nvim';      -- fuzzy over lsp
  'nvim-lua/plenary.nvim';    -- for fzf-lsp
  'j-hui/fidget.nvim';        -- lsp progress

  --git integrations
  "tpope/vim-fugitive";
  "tpope/vim-rhubarb";
  "christoomey/vim-conflicted";
  "airblade/vim-gitgutter";
  "junegunn/gv.vim";
  "akinsho/git-conflict.nvim";
  "lewis6991/gitsigns.nvim";

  --File Navigation & Search
  "dyng/ctrlsf.vim";
  "junegunn/fzf.vim";
  "junegunn/fzf";
  "kyazdani42/nvim-tree.lua";
  "akinsho/bufferline.nvim";

  --auto completion
  "vim-scripts/CmdlineComplete";
  "alvan/vim-closetag";
  'jiangmiao/auto-pairs';
  "hrsh7th/nvim-cmp";             --  Autocompletion for LSP
  'hrsh7th/cmp-nvim-lsp';         --  LSP source for nvim-cmp
  'hrsh7th/cmp-buffer';
  'hrsh7th/cmp-path';
  'saadparwaiz1/cmp_luasnip';     --  Snippets source for nvim-cmp
  'rafamadriz/friendly-snippets'; --  framework snippets

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

