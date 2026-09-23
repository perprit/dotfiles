# kitty

## 설치

```sh
brew install --cask kitty
brew install --cask font-d2coding
```

## 적용

```sh
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
target="$HOME/.config/kitty"
mkdir -p "$HOME/.config"
if [ -e "$target" ] && [ "$(readlink "$target")" != "$DOTFILES/kitty" ]; then
  mv "$target" "$target.backup-$(date +%Y%m%d)"
fi
ln -sfn "$DOTFILES/kitty" "$target"
```

## 반영

- kitty 실행 중이면 `ctrl+cmd+,` 또는 `kill -USR1 $(pgrep -x kitty)`로 설정을 다시 불러온다.
- `startup.conf`(시작 세션)는 kitty 재시작 시 적용된다.

## 검증

```sh
readlink "$HOME/.config/kitty"   # $DOTFILES/kitty
/Applications/kitty.app/Contents/MacOS/kitty +runpy \
  'from kitty.config import load_config; load_config("'"$HOME"'/.config/kitty/kitty.conf"); print("ok")'
```

오류 없이 `ok`가 출력되면 통과.

## 파일

| 파일 | 역할 |
|---|---|
| `kitty.conf` | 메인 설정 (`include current-theme.conf`, `startup_session startup.conf`) |
| `current-theme.conf` | Sonokai Shusia 색상 테마 |
| `startup.conf` | 시작 세션: `~/develop`에서 기본 셸 실행 |

## 주의사항

- `~/develop` 폴더를 전제로 한다(`startup.conf`, `cmd+t` 등 새 탭 매핑). 없으면 만들거나 경로를 바꾼다.
- 한글 입력기(두벌식) 대응 매핑이 있다.
  - `ctrl+ㅋ`, `cmd+ㅊ` 등: 한글 상태에서도 ctrl/cmd 단축키가 동작하게 한다.
  - `ctrl+ㅠ>{키}`: herdr prefix(`ctrl+b`) 뒤 키를 입력기 조합 없이 `\x02{영문키}`로 바로 보낸다. herdr 바인딩을 추가하면 여기에도 같이 추가해야 한글 상태에서 동작한다. shift 조합은 `ctrl+ㅠ>shift+n`처럼 영문 키 이름으로 쓴다.
