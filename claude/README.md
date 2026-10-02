# claude

Claude Code 전역 규칙(`~/.claude/CLAUDE.md`, `~/.claude/AGENTS.md`). `CLAUDE.md`는 `@AGENTS.md`로 `AGENTS.md`를 불러오기만 하고, 규칙 본문은 `AGENTS.md`에 쓴다.

## 설치

```sh
brew install --cask claude-code
```

## 적용

`~/.claude`에는 세션 기록, 메모리, 설정 같은 앱 데이터가 있으므로 폴더가 아니라 `CLAUDE.md`, `AGENTS.md` 파일만 링크한다.

```sh
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
mkdir -p "$HOME/.claude"
for f in CLAUDE.md AGENTS.md; do
  target="$HOME/.claude/$f"
  if [ -e "$target" ] && [ "$(readlink "$target")" != "$DOTFILES/claude/$f" ]; then
    mv "$target" "$target.backup-$(date +%Y%m%d)"
  fi
  ln -sfn "$DOTFILES/claude/$f" "$target"
done
```

## 반영

새 세션을 시작할 때 읽는다. 실행 중인 세션에는 반영되지 않는다.

## 검증

```sh
readlink "$HOME/.claude/CLAUDE.md"   # $DOTFILES/claude/CLAUDE.md
readlink "$HOME/.claude/AGENTS.md"   # $DOTFILES/claude/AGENTS.md
head -1 "$HOME/.claude/AGENTS.md"    # # AGENTS.md: 전역 규칙
```
