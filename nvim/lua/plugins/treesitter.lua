-- nvim-treesitter `main` 브랜치 API (구버전 nvim-treesitter.configs 방식과 다름)
local ensure_installed = {
  "lua", "vim", "vimdoc", "bash", "python",
  "javascript", "typescript", "tsx", "json", "yaml", "toml",
  "markdown", "markdown_inline", "html", "css",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()

      local installed = require("nvim-treesitter.config").get_installed("parsers")
      local missing = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, ensure_installed)
      if #missing > 0 then
        require("nvim-treesitter").install(missing)
      end

      -- 파서가 있는 파일타입에서만 하이라이트/들여쓰기 활성화
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not (lang and vim.treesitter.language.add(lang)) then
            return
          end
          vim.treesitter.start(ev.buf, lang)
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
