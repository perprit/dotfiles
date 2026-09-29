# Neovim

## 설치

```sh
xcode-select --install   # 없을 때만. telescope-fzf-native 빌드에 make/C 컴파일러 필요
brew install neovim ripgrep tree-sitter-cli pyrefly
```

- Neovim 0.10 이상 (`vim.uv` 사용)
- `ripgrep`: Telescope `live_grep`에 필요
- `tree-sitter` CLI: nvim-treesitter `main` 브랜치가 파서를 빌드할 때 필요 (`brew install tree-sitter-cli`)
- `pyrefly`: Python LSP 서버. Poetry 프로젝트(루트에 `poetry.lock`)면 `poetry env info -e`가 돌려주는 venv 인터프리터를 넘긴다. 빈 값이면 프로젝트에서 `poetry env use python3.X`로 env를 연결한다

## 적용

```sh
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
target="$HOME/.config/nvim"
mkdir -p "$HOME/.config"
if [ -e "$target" ] && [ "$(readlink "$target")" != "$DOTFILES/nvim" ]; then
  mv "$target" "$target.backup-$(date +%Y%m%d)"
fi
ln -sfn "$DOTFILES/nvim" "$target"
```

## 반영

첫 실행 시 lazy.nvim이 자동 설치되고 플러그인을 받는다(네트워크 필요). `lazy-lock.json` 버전에 맞추려면:

```sh
nvim --headless "+Lazy! restore" +qa
```

## 검증

```sh
readlink "$HOME/.config/nvim"   # $DOTFILES/nvim
nvim --headless -c 'lua io.write(vim.g.mapleader == " " and "ok\n" or "fail\n")' -c qa
```

`ok`가 출력되고 오류가 없으면 통과.

## 파일

| 파일 | 역할 |
|---|---|
| `init.lua` | leader(Space, localleader `\`) 지정 후 `config/*` 로드 |
| `lua/config/options.lua` | 편집 옵션 |
| `lua/config/lazy.lua` | lazy.nvim 부트스트랩, 플러그인 로드 |
| `lua/config/keymaps.lua` | 기본 키맵 |
| `lua/plugins/colorscheme.lua` | sonokai (default style) |
| `lua/plugins/editor.lua` | telescope, nvim-tree, gitsigns, which-key |
| `lua/plugins/lsp.lua` | nvim-lspconfig + pyrefly (Poetry venv 연결). 키맵은 nvim 기본 |
| `lua/plugins/treesitter.lua` | nvim-treesitter (`main` 브랜치) 파서 자동 설치 |
| `lua/plugins/ui.lua` | lualine |
| `lazy-lock.json` | 플러그인 버전 고정 |

## 키맵

| 키 | 동작 |
|---|---|
| `Space e` | nvim-tree 토글 |
| `Space ff` / `fg` / `fb` / `fh` / `fr` | Telescope 파일 찾기 / grep / 버퍼 / 도움말 / 최근 파일 |
| `Space gb` / `gB` / `gt` | gitsigns 현재 줄 blame / 파일 blame / 인라인 blame 토글 |
| `Ctrl-]` | LSP 정의로 이동 (`Ctrl-o`로 복귀, nvim 기본) |
| `K` / `grr` / `gri` / `grt` | 호버 / 참조 / 구현 / 타입 정의 (nvim 기본) |
| `grn` / `gra` | 이름 변경 / 코드 액션 (nvim 기본) |
| `Space w` / `q` | 저장 / 닫기 |
| `Ctrl h/j/k/l` | 창 이동 |
| `Esc` | 검색 하이라이트 끄기 |
