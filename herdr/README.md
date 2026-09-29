# herdr

## 설치

```sh
brew install herdr
```

## 적용

`~/.config/herdr`에는 소켓, 로그, 세션 파일이 생기므로 폴더가 아니라 `config.toml` 파일만 링크한다.

```sh
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
target="$HOME/.config/herdr/config.toml"
mkdir -p "$HOME/.config/herdr"
if [ -e "$target" ] && [ "$(readlink "$target")" != "$DOTFILES/herdr/config.toml" ]; then
  mv "$target" "$target.backup-$(date +%Y%m%d)"
fi
ln -sfn "$DOTFILES/herdr/config.toml" "$target"
```

## 반영

```sh
herdr server reload-config   # 서버가 실행 중일 때
```

## 검증

```sh
readlink "$HOME/.config/herdr/config.toml"   # $DOTFILES/herdr/config.toml
herdr config check                          # config: ok
```

## 주의사항

- herdr 설정 UI(`prefix+s`)에서 값을 바꾸면 링크가 일반 파일로 바뀔 수 있다. 바꾼 뒤 `readlink`로 확인하고, 일반 파일이면 내용을 저장소로 옮긴 뒤 다시 링크한다.
- 한글 입력기: prefix(`ctrl+b`) 자체는 kitty의 `ime-ctrl-keys.py` 매핑으로, prefix 뒤의 키는 `[experimental] switch_ascii_input_source_in_prefix = true`로 처리한다. `[keys]`에 바인딩을 추가해도 kitty 쪽 매핑을 따로 늘릴 필요 없다.
- `[session] resume_agents_on_restore = true`는 `herdr integration install claude`로 Claude Code 연동을 설치해야 동작한다.
- `[theme] name = "terminal"`: kitty의 Sonokai 팔레트를 그대로 따른다.
- 새 workspace(`prefix+shift+n`)는 `[[keys.command]]`로 `~/dev`에서 연다. `terminal.new_cwd`는 pane/tab/workspace 공통이라 workspace만 따로 정할 수 없어서, 기본 `new_workspace` 바인딩은 비워 두었다. 사이드바 마우스로 만드는 workspace는 여전히 `new_cwd = "follow"`를 따른다.
