return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "파일 찾기" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "전체 검색" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "버퍼 목록" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "도움말 검색" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "최근 파일" },
    },
    config = function()
      require("telescope").setup({})
      pcall(require("telescope").load_extension, "fzf")
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "파일 탐색기" },
    },
    opts = {},
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 300,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "  <author>, <author_time:%Y-%m-%d> · <summary>",
      current_line_blame_formatter_nc = "  커밋되지 않음",
    },
    keys = {
      { "<leader>gb", "<cmd>Gitsigns blame_line<CR>", desc = "현재 줄 blame 팝업" },
      { "<leader>gB", "<cmd>Gitsigns blame<CR>", desc = "파일 전체 blame 창" },
      { "<leader>gt", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "인라인 blame 토글" },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
