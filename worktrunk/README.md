# worktrunk

`wt` 명령(git worktree 관리). 셸 연동은 [zsh/README.md](../zsh/README.md)에서 설치한다.

## 설치

```sh
brew install worktrunk
```

## 적용

`~/.config/worktrunk`에는 명령 승인 기록 같은 상태 파일이 생길 수 있으므로 폴더가 아니라 `config.toml` 파일만 링크한다.

```sh
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
target="$HOME/.config/worktrunk/config.toml"
mkdir -p "$HOME/.config/worktrunk"
if [ -e "$target" ] && [ "$(readlink "$target")" != "$DOTFILES/worktrunk/config.toml" ]; then
  mv "$target" "$target.backup-$(date +%Y%m%d)"
fi
ln -sfn "$DOTFILES/worktrunk/config.toml" "$target"
```

## 반영

매 실행마다 설정을 읽으므로 따로 할 일이 없다.

## 검증

```sh
readlink "$HOME/.config/worktrunk/config.toml"   # $DOTFILES/worktrunk/config.toml
wt config show | head -3                          # USER CONFIG 아래에 worktree-path 가 보인다
```

## 주의사항

- `worktree-path`: 새 worktree를 저장소 안 `.claude/worktrees/<branch>`에 만든다(`/`는 `-`로 바뀐다). 모든 저장소에 적용되므로, `.gitignore`에 `.claude/worktrees/`가 없는 저장소에서는 worktree 폴더가 추적되지 않은 파일로 보인다.
