# Karabiner-Elements

## 설치

```sh
brew install --cask karabiner-elements
```

설치 후 Karabiner-Elements를 한 번 실행해 macOS 권한(입력 모니터링, 드라이버 확장)을 허용한다. 이 단계는 사용자가 직접 해야 한다.

## 적용

Karabiner는 설정 파일을 새로 써서 저장하므로 파일이 아니라 폴더 전체를 링크한다(공식 권장 방식).

```sh
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
target="$HOME/.config/karabiner"
mkdir -p "$HOME/.config"
if [ -e "$target" ] && [ "$(readlink "$target")" != "$DOTFILES/karabiner" ]; then
  mv "$target" "$target.backup-$(date +%Y%m%d)"
fi
ln -sfn "$DOTFILES/karabiner" "$target"
```

## 반영

```sh
launchctl kickstart -k gui/$(id -u)/org.pqrs.service.agent.karabiner_console_user_server
```

## 검증

```sh
readlink "$HOME/.config/karabiner"   # $DOTFILES/karabiner
python3 -c 'import json,os;d=json.load(open(os.path.expanduser("~/.config/karabiner/karabiner.json")));print([r["description"] for p in d["profiles"] for r in p.get("complex_modifications",{}).get("rules",[])])'
```

아래 두 규칙이 출력되면 통과.

## 규칙

- 마우스 버튼(`Left Command + ;`로 리매핑된 버튼) → 오른쪽 Space로 이동
- 마우스 버튼(`Left Command + '`로 리매핑된 버튼) → 왼쪽 Space로 이동

## 주의사항

- Karabiner가 폴더 안에 만드는 `automatic_backups/`, `assets/`는 `.gitignore`로 제외한다.
