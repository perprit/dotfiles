# claude

Claude Code, Codex 공용 전역 규칙과 Claude Code 사용자 스킬. 규칙 본문은 `AGENTS.md` 하나에만 쓴다. 스킬은 `skills/<이름>/SKILL.md`에 둔다.

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

## 스킬

`skills/` 아래 폴더 하나가 Claude Code 스킬 하나다. `~/.claude/skills/`에는 앱이 동기화하는 스킬(`synced/`)도 있다. 그래서 폴더 전체가 아니라 스킬 폴더마다 링크한다. 백업은 `~/.claude/skills/` 밖에 둔다. 안에 두면 백업도 스킬로 읽힌다.

### 적용

```sh
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
mkdir -p "$HOME/.claude/skills"
for src in "$DOTFILES"/claude/skills/*/; do
  src="${src%/}"
  name="$(basename "$src")"
  target="$HOME/.claude/skills/$name"
  if [ -e "$target" ] && [ "$(readlink "$target")" != "$src" ]; then
    mv "$target" "$HOME/.claude/$name.backup-$(date +%Y%m%d)"
  fi
  ln -sfn "$src" "$target"
done
```

### 반영

새 세션을 시작할 때 읽는다. 실행 중인 세션에는 반영되지 않는다.

### 검증

```sh
for src in "$DOTFILES"/claude/skills/*/; do
  readlink "$HOME/.claude/skills/$(basename "$src")"   # $DOTFILES/claude/skills/<이름>
done
```
