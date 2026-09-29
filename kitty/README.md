# kitty

## 설치

```sh
brew install --cask kitty
brew install --cask font-d2coding-nerd-font
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
| `kitty.conf` | 메인 설정 (`include themes/sonokai.conf`, `startup_session startup.conf`, `geninclude ime-ctrl-keys.py`) |
| `themes/sonokai.conf` | Sonokai(default style) 색상 테마 |
| `open-actions.conf` | `file://` 링크 클릭 시 텍스트 파일을 `$EDITOR`로 오버레이 창에서 연다 |
| `startup.conf` | 시작 세션: `~/dev`에서 기본 셸 실행 |
| `ime-ctrl-keys.py` | 한글 입력기용 `ctrl+<영문키>` 매핑 생성 스크립트 (`geninclude`, 실행 권한 필요) |

## 주의사항

- `~/dev` 폴더를 전제로 한다(`startup.conf`, `cmd+t`/`cmd+n` 등 새 탭·창 매핑). 없으면 만들거나 경로를 바꾼다.
- 한글 입력기(두벌식) 대응
  - `ctrl+<영문키>`: `ime-ctrl-keys.py`가 a-z 전체에 `map --allow-fallback=ascii ctrl+{키} send_key ctrl+{키}`를 생성해, 한글 상태에서도 셸·herdr·nvim에 영문 ctrl 조합이 전달된다. 키를 하나씩 추가할 필요 없다.
  - `cmd+<영문키>`: kitty 기본 단축키는 이미 `--allow-fallback=shifted,ascii`라 따로 매핑하지 않는다. 직접 추가하는 `cmd+` 매핑에는 `--allow-fallback=shifted,ascii`를 붙인다.
  - herdr prefix(`ctrl+b`) 뒤의 키는 herdr `experimental.switch_ascii_input_source_in_prefix`가 처리한다([herdr/README.md](../herdr/README.md)).
