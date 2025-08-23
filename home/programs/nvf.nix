{config, pkgs, ...}:

{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;

        languages = {
          enableLSP = true;
          enableTreesitter = true;
          enableFormat = true;

          nix.enable = true;
          rust.enable = true;
          python.enable = true;
        };

        terminal.toggleterm.lazygit = {
          enable = true;
        };

        globals.mapleader = " ";
        keymaps = [
          {
            key = "J";
            mode = "v";
            silent = true;
            action = ":m '>+1<CR>gv=gv";
          }
          {
            key = "K";
            mode = "v";
            silent = true;
            action = ":m '<-2<CR>gv=gv";
          }

          {
            key = "J";
            mode = "n";
            silent = true;
            action = "mzJ`z";
          }
          {
            key = "<C-d>";
            mode = "n";
            silent = true;
            action = "<C-d>zz";
          }
          {
            key = "<C-u>";
            mode = "n";
            silent = true;
            action = "<C-u>zz";
          }
          {
            key = "n";
            mode = "n";
            silent = true;
            action = "nzzzv";
          }
          {
            key = "N";
            mode = "n";
            silent = true;
            action = "Nzzzv";
          }
          
          {
            key = "<leader>p";
            mode = "x";
            silent = true;
            action = "\"_dP";
          }
          
          {
            key = "<leader>y";
            mode = ["n" "v"]; 
            silent = true;
            action = "\"+y";
          }
          {
            key = "<leader>Y";
            mode = "n";
            silent = true;
            action = "\"+Y";
          }
          {
            key = "Q";
            mode = "n";
            silent = true;
            action = "<nop>";
          }
          
          {
            key = "<leader>k";
            mode = "n";
            silent = true;
            action = "<cmd>lnext<CR>zz";
          }
          {
            key = "<leader>j";
            mode = "n";
            silent = true;
            action = "<cmd>lprev<CR>zz";
          }

          {
            key = "kj";
            mode = "i";
            silent = true;
            action = "<ESC>";
          }
          {
            key = "<leader>w";
            mode = "n";
            silent = true;
            action = ":w!<CR>";
          }
          {
            key = "<leader>q";
            mode = "n";
            silent = true;
            action = ":q!<CR>";
          }
          {
            key = "<leader>l";
            mode = ["n" "x"];
            silent = true;
            action = "<cmd>cnext<CR>";
          }
        ];

        filetree.nvimTree = {
            enable = true;
            setupOpts.modified.enable = true;
            mappings = {
              focus = "<leader>e";
              refresh = "<leader>tf";
              toggle = "<leader>tt";
            };
        };
      };
    };
  };
}
