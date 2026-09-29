-- Neovim 0.11+ 내장 LSP API(vim.lsp.config / vim.lsp.enable).
-- nvim-lspconfig는 서버별 기본 설정(cmd, root_markers)만 제공한다.

-- Poetry 프로젝트면 그 venv 인터프리터를 돌려준다. 아니면 nil.
-- pyrefly는 스스로 찾게 두면 상위 디렉터리의 다른 .venv를 잡을 수 있다.
local function poetry_python(root)
  if not root or vim.fn.executable("poetry") == 0 then
    return nil
  end
  if not (vim.uv or vim.loop).fs_stat(root .. "/poetry.lock") then
    return nil
  end
  local out = vim.system({ "poetry", "env", "info", "-e" }, { cwd = root, text = true }):wait()
  local path = vim.trim(out.stdout or "")
  if out.code ~= 0 or path == "" then
    return nil
  end
  return path
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.lsp.config("pyrefly", {
        -- workspace/configuration 응답은 client.settings에서 나간다(before_init의 config가 아님)
        on_init = function(client)
          local python = poetry_python(client.root_dir)
          if python then
            client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
              python = { pythonPath = python },
            })
            client:notify("workspace/didChangeConfiguration", { settings = client.settings })
          end
        end,
      })
      vim.lsp.enable("pyrefly")
      -- 키맵은 nvim 기본을 쓴다: Ctrl-] 정의, K 호버, grr 참조, gri 구현, grt 타입 정의,
      -- grn 이름 변경, gra 코드 액션
    end,
  },
}
