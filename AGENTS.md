# AGENTS.md — dotfiles

macOS 개인 설정 저장소. 특정 사용자 경로에 의존하지 않으며, 어느 사용자 홈에서든 아래 절차로 적용한다.

## 구성

| 폴더 | 대상 앱 | 적용 위치 | 적용 방식 | 절차 |
|---|---|---|---|---|
| `kitty/` | kitty 터미널 | `~/.config/kitty` | 폴더 심볼릭 링크 | [kitty/README.md](kitty/README.md) |
| `nvim/` | Neovim | `~/.config/nvim` | 폴더 심볼릭 링크 | [nvim/README.md](nvim/README.md) |
| `herdr/` | herdr (터미널 멀티플렉서) | `~/.config/herdr/config.toml` | 파일 심볼릭 링크 | [herdr/README.md](herdr/README.md) |
| `karabiner/` | Karabiner-Elements | `~/.config/karabiner` | 폴더 심볼릭 링크 | [karabiner/README.md](karabiner/README.md) |
| `zed/` | Zed 에디터 | `~/.config/zed/settings.json` | 파일 심볼릭 링크 | [zed/README.md](zed/README.md) |
| `zsh/` | zsh (Oh My Zsh + p10k) | `~/.zshrc` | 파일 심볼릭 링크 | [zsh/README.md](zsh/README.md) |
| `worktrunk/` | worktrunk (`wt`) | `~/.config/worktrunk/config.toml` | 파일 심볼릭 링크 | [worktrunk/README.md](worktrunk/README.md) |
| `claude/` | Claude Code, Codex 전역 규칙 | `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md` | 파일 심볼릭 링크 | [claude/README.md](claude/README.md) |

## 적용 순서

1. 저장소 위치를 `DOTFILES`로 둔다. 모든 README 명령은 이 변수를 쓴다.
   ```sh
   export DOTFILES="${DOTFILES:-$HOME/dotfiles}"
   ```
2. 사용자가 요청한 폴더만 적용한다. 요청이 없으면 전체 적용 전에 확인한다.
3. 각 폴더 README의 순서대로 진행한다: 설치 → 기존 설정 백업 → 링크 → 반영 → 검증.

## 규칙

- **절대경로 금지**: 설정 파일에 `/Users/<이름>` 같은 사용자 경로를 넣지 않는다. `~` 또는 `$HOME`을 쓴다.
- **기존 설정 백업**: 적용 위치에 링크가 아닌 파일/폴더가 있으면 지우지 말고 `<경로>.backup-<YYYYMMDD>`로 옮긴 뒤 링크한다. 이미 `$DOTFILES`를 가리키는 링크면 건너뛴다.
- **수정은 저장소에서**: 설정 변경은 `$DOTFILES` 안의 파일을 고친다. 링크 대상이 앱에 의해 일반 파일로 바뀌었으면 내용을 저장소로 옮기고 다시 링크한다.
- **검증 필수**: 각 README의 검증 명령이 통과해야 적용 완료로 본다.
- **버전 고정**: 각 폴더의 `version.txt`에 동작이 확인된 도구 버전을 한 줄에 하나씩 `<도구> <버전>` 형식으로 적는다. git으로 받는 도구는 커밋 해시를 적는다.
  - 도구가 설치되어 있지 않으면 README의 설치 절차를 따르되 `version.txt`의 버전으로 설치한다. 그 버전을 설치할 수 없으면 다른 버전을 임의로 설치하지 말고 사용자에게 알린다.
  - 이미 설치된 버전이 `version.txt`와 다르면 업그레이드나 다운그레이드하지 말고 차이를 사용자에게 알린다.
  - 새 버전에서 동작을 확인했으면 `version.txt`를 갱신해 설정 변경과 같은 커밋에 넣는다.
- **커밋**: 폴더 단위로 `feat(kitty): ...`, `chore(nvim): ...` 형식을 쓴다.
- **PR로 반영**: `main`에 직접 커밋하거나 push하지 않는다. 변경마다 브랜치를 만들어 push하고 PR을 연다. PR 제목은 커밋 메시지 형식을 따른다.
