-- Define Plugins
require"paq"{
  -- Paq manages itself
  "savq/paq-nvim";

  --theme (bleep bloop)
  "shatur/neovim-ayu";
  "nvim-lualine/lualine.nvim";
  "ryanoasis/vim-webdevicons";
  "kyazdani42/nvim-web-devicons"; --for coloured icons
  "nvim-tree/nvim-web-devicons"; --for coloured icons

  --syntax highlighting + lint/hint + language specifics
  "octol/vim-cpp-enhanced-highlight";
  "godlygeek/tabular";
  {"toppair/peek.nvim", build='deno task --quiet build:fast'};
  {"nvim-treesitter/nvim-treesitter", build=':TSUpdate'};
  'andymass/vim-matchup';                               -- better % matcher
  'folke/trouble.nvim';                                 -- diagnostic listing
  'm-demare/hlargs.nvim';                               -- better highlights for args
  'm00qek/baleia.nvim';                                 -- read ansi color coded (for logs and term scrollback)
  "olexsmir/gopher.nvim";                               -- golang support
  "epwalsh/obsidian.nvim";                              -- Obsidian integration

  --LSP and dependencies
  "neovim/nvim-lspconfig";                             -- Use native LSP
  'gfanto/fzf-lsp.nvim';                               -- fuzzy over lsp
  'nvim-lua/plenary.nvim';                             -- for fzf-lsp
  { 'mason-org/mason.nvim', build=':MasonUpdate' };    -- lsp installer'
  'mason-org/mason-lspconfig.nvim';                    -- LSP connection for mason
  'onsails/lspkind-nvim';                              -- lsp icons
  'nvim-flutter/flutter-tools.nvim';

  --git integrations
  "tpope/vim-fugitive";
  "lewis6991/gitsigns.nvim";

  --File Navigation & Search
  "ibhagwan/fzf-lua";
  "kyazdani42/nvim-tree.lua";
  "akinsho/bufferline.nvim";

  --auto completion
  'windwp/nvim-autopairs';
  'windwp/nvim-ts-autotag';
  "hrsh7th/nvim-cmp";
  'hrsh7th/cmp-nvim-lsp';
  'hrsh7th/cmp-buffer';
  'hrsh7th/cmp-nvim-lua';
  'hrsh7th/cmp-path';
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-nvim-lsp-signature-help';
  'saadparwaiz1/cmp_luasnip';
  'lukas-reineke/cmp-rg';

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

  -- convenience
  "laytan/cloak.nvim";
  "stevearc/oil.nvim";
  "SmiteshP/nvim-navic";
  "NStefan002/screenkey.nvim";

  -- debugging
  "mfussenegger/nvim-dap";
  "leoluz/nvim-dap-go";

  -- Dependencies
  "MunifTanjim/nui.nvim"; -- avante
  "MeanderingProgrammer/render-markdown.nvim"; -- avante

  -- AI Stuff
  "supermaven-inc/supermaven-nvim";
  --{ "yetone/avante.nvim", build='make' };
}

