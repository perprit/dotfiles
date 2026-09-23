# Neovim

## 설치

```sh
xcode-select --install   # 없을 때만. telescope-fzf-native 빌드에 make/C 컴파일러 필요
brew install neovim git ripgrep
```

- Neovim 0.10 이상 (`vim.uv` 사용)
- `ripgrep`: Telescope `live_grep`에 필요

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
| `init.lua` | 옵션, leader(Space), lazy.nvim 부트스트랩 |
| `lua/plugins/*.lua` | 플러그인: sonokai(테마), nvim-tree, telescope |
| `lazy-lock.json` | 플러그인 버전 고정 |

## 키맵

| 키 | 동작 |
|---|---|
| `Space e` | nvim-tree 토글 |
| `Space ff` / `fg` / `fb` | Telescope 파일 찾기 / grep / 버퍼 |
