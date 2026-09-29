# zed

## 설치

```sh
brew install --cask zed
brew install --cask font-d2coding-nerd-font
```

## 적용

`~/.config/zed`에는 prompts 등 앱이 만드는 데이터가 있으므로 폴더가 아니라 `settings.json` 파일만 링크한다.

```sh
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
target="$HOME/.config/zed/settings.json"
mkdir -p "$HOME/.config/zed"
if [ -e "$target" ] && [ "$(readlink "$target")" != "$DOTFILES/zed/settings.json" ]; then
  mv "$target" "$target.backup-$(date +%Y%m%d)"
fi
ln -sfn "$DOTFILES/zed/settings.json" "$target"
```

## 반영

Zed는 설정 파일 변경을 자동으로 감지한다. 처음 적용할 때는 Zed를 재시작하면 `auto_install_extensions`에 적힌 확장(Sonokai 테마)이 자동으로 설치된다.

## 검증

```sh
readlink "$HOME/.config/zed/settings.json"   # $DOTFILES/zed/settings.json
ls "$HOME/Library/Application Support/Zed/extensions/installed"   # sonokai
```

## 주의사항

- Zed 설정 UI에서 값을 바꾸면 링크가 일반 파일로 바뀔 수 있다. 바꾼 뒤 `readlink`로 확인하고, 일반 파일이면 내용을 저장소로 옮긴 뒤 다시 링크한다.
- 테마: `theme.dark = "Sonokai"`. kitty·nvim과 같은 Sonokai 팔레트를 쓴다. Sonokai 확장은 다크 변형(Maia, Shusia, Atlantis, Espresso, Andromeda)만 제공한다.
- 폰트: 에디터·터미널 모두 `D2KodingLigature Nerd Font`를 쓴다(크기는 kitty와 같은 13). 따로 설치해야 한다. kitty의 `... Nerd Font Mono`는 한글 폭이 반각이라 Zed에서 글자가 겹치므로 쓰지 않는다.
