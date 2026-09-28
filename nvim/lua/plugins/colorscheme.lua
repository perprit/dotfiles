return {
  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    init = function()
      -- sonokai는 vimscript 기반이라 colorscheme 적용 전에 vim.g로 설정한다
      -- style: default | atlantis | andromeda | shusia | maia | espresso
      vim.g.sonokai_style = "default"
      vim.g.sonokai_better_performance = 1
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_transparent_background = 0
    end,
    config = function()
      vim.cmd.colorscheme("sonokai")
    end,
  },
}
