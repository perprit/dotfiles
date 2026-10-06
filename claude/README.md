# claude

Claude Code, Codex 공용 전역 규칙. 규칙 본문은 `AGENTS.md` 하나에만 쓴다.

Claude Code는 `~/.claude/AGENTS.md`를 읽지 않고 `~/.claude/CLAUDE.md`만 읽는다. 그래서 `~/.claude/CLAUDE.md` 이름으로 `AGENTS.md`를 링크한다. Codex는 `~/.codex/AGENTS.md`를 읽는다.

## 설치

```sh
brew install --cask claude-code
```

## 적용

`~/.claude`, `~/.codex`에는 세션 기록, 메모리, 설정 같은 앱 데이터가 있으므로 폴더가 아니라 파일만 링크한다.

```sh
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
for target in "$HOME/.claude/CLAUDE.md" "$HOME/.codex/AGENTS.md"; do
  mkdir -p "$(dirname "$target")"
  if [ -e "$target" ] && [ "$(readlink "$target")" != "$DOTFILES/claude/AGENTS.md" ]; then
    mv "$target" "$target.backup-$(date +%Y%m%d)"
  fi
  ln -sfn "$DOTFILES/claude/AGENTS.md" "$target"
done
```

## 반영

새 세션을 시작할 때 읽는다. 실행 중인 세션에는 반영되지 않는다.

## 검증

```sh
readlink "$HOME/.claude/CLAUDE.md"   # $DOTFILES/claude/AGENTS.md
readlink "$HOME/.codex/AGENTS.md"    # $DOTFILES/claude/AGENTS.md
head -1 "$HOME/.claude/CLAUDE.md"    # # AGENTS.md: 전역 규칙
```
