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
  "dense-analysis/ale";
  "godlygeek/tabular";
  "chrisbra/colorizer";

  "vim-ruby/vim-ruby"; --Ruby motions and other stuff
  {"nvim-treesitter/nvim-treesitter", run=':TSUpdate'};

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
  { "neoclide/coc.nvim", branch = "release" };
  "vim-scripts/CmdlineComplete";
  "alvan/vim-closetag";

  --comment code
  "preservim/nerdcommenter";

  --surround operations
  "tpope/vim-surround";
  "tpope/vim-repeat";

  --snippets
  "marcweber/vim-addon-mw-utils";
  "tomtom/tlib_vim";
  "garbas/vim-snipmate";

  -- Folding code
  "kevinhwang91/promise-async";
  "kevinhwang91/nvim-ufo";
}

