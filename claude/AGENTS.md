# AGENTS.md: 전역 규칙

## 툴 설정 파일

- 툴 설정(kitty, nvim, herdr, karabiner, zed 등)을 확인하거나 바꿀 때는 먼저 dotfiles 저장소(`${DOTFILES:-$HOME/dotfiles}`)를 참고한다. 저장소의 `AGENTS.md`와 각 폴더 README의 절차를 따른다.
- `~/.config/...`는 dotfiles를 가리키는 심볼릭 링크다. 설정은 저장소 안의 파일을 고친다. 링크가 일반 파일로 바뀌어 있으면 내용을 저장소로 옮기고 다시 링크한다.
- dotfiles에 아직 없는 툴의 설정을 만들거나 바꾸면 저장소에 추가하는 것을 제안한다.

## 글쓰기

- em dash, 중간점(·) 사용하지 않음. 중간점 대신 쉼표(,) 사용.
- em dash 이후에 따라오는 비유/설명문 사용하지 않음. (사실은 이렇다, A가 아니다, B다)
