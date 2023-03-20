-- Define Plugins
require"paq"{
  -- Paq manages itself
  "savq/paq-nvim";

  --theme (bleep bloop)
  "liuchengxu/space-vim-theme";
  "ayu-theme/ayu-vim";
  "nvim-lualine/lualine.nvim";
  "jacoborus/tender.vim"; -- lightline colorscheme
  "ryanoasis/vim-webdevicons";
  "kyazdani42/nvim-web-devicons"; --for coloured icons
  "rcarriga/nvim-notify"; -- notifications

  {"glepnir/dashboard-nvim", event="VimEnter"};

  --syntax highlighting + lint/hint + language specifics
  "octol/vim-cpp-enhanced-highlight";
  "godlygeek/tabular";
  "chrisbra/colorizer";
  "ellisonleao/glow.nvim"; -- Markdown preview

  'tpope/vim-rails';                                    -- Probably not working either
  'tpope/vim-endwise';
  "vim-ruby/vim-ruby";                                  --Ruby motions and other stuff (not working now for some reason)
  {"nvim-treesitter/nvim-treesitter", run=':TSUpdate'};
  'hiphish/nvim-ts-rainbow2';                           -- rainbow pairs
  'andymass/vim-matchup';                               -- better % matcher
  'folke/trouble.nvim';                                 -- diagnostic listing
  'preservim/tagbar';                                   -- ctags browser

  --LSP and dependencies
  "neovim/nvim-lspconfig";    -- Use native LSP
  'gfanto/fzf-lsp.nvim';      -- fuzzy over lsp
  'nvim-lua/plenary.nvim';    -- for fzf-lsp
  'mrded/nvim-lsp-notify';    -- lsp progress

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
  --"vim-scripts/CmdlineComplete";
  "alvan/vim-closetag";
  'jiangmiao/auto-pairs';
  "hrsh7th/nvim-cmp";                    -- Autocompletion for LSP
  'hrsh7th/cmp-nvim-lsp';                -- LSP source for nvim-cmp
  'hrsh7th/cmp-buffer';
  'hrsh7th/cmp-nvim-lua';
  'hrsh7th/cmp-path';
  'hrsh7th/cmp-calc';
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-nvim-lsp-signature-help';
  'saadparwaiz1/cmp_luasnip';            -- Snippets source for nvim-cmp
  'rafamadriz/friendly-snippets';        -- framework snippets
  'lukas-reineke/cmp-rg';                -- ripgrep source for nvim-cmp

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
  --"luukvbaal/statuscol.nvim";
}

