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
        globals.mapleader = " ";
        keymaps = [
          {
            key = "<leader>w";
            mode = "n";
            silent = true;
            action = ":w!";
          }
          {
            key = "<leader>q";
            mode = "n";
            silent = true;
            action = ":q!";
          }
          {
            key = "<leader>l";
            mode = ["n" "x"];
            silent = true;
            action = "<cmd>cnext<CR>";
          }
        ];
      };
    };
  };
}
