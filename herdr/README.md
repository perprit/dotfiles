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
- 키 바인딩(`[keys]`)을 추가하면 한글 입력기 대응을 위해 `kitty/kitty.conf`의 `ctrl+ㅠ>{키}` 매핑도 같이 추가한다 ([kitty/README.md](../kitty/README.md)).
