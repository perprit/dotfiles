# zsh

Oh My Zsh + Powerlevel10k 기반 `~/.zshrc`.

## 설치

```sh
brew install fzf glow
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
```

## 적용

`~/.zshrc`는 홈 바로 아래에 있으므로 폴더가 아니라 파일만 링크한다.

```sh
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
target="$HOME/.zshrc"
if [ -e "$target" ] && [ "$(readlink "$target")" != "$DOTFILES/zsh/.zshrc" ]; then
  mv "$target" "$target.backup-$(date +%Y%m%d)"
fi
ln -sfn "$DOTFILES/zsh/.zshrc" "$target"
```

## 반영

```sh
exec zsh
```

## 검증

```sh
readlink "$HOME/.zshrc"        # $DOTFILES/zsh/.zshrc
bindkey '^[[1;3D'              # backward-word
bindkey '^[[1;3C'              # forward-word
```

## 주의사항

- `~/.p10k.zsh`는 `p10k configure`가 만드는 개인 프롬프트 설정이라 저장소에 넣지 않는다. 없으면 `.zshrc`가 알아서 건너뛴다.
- **Option+←/→ 단어 단위 이동**은 터미널이 `^[[1;3D` / `^[[1;3C`를 보내야 동작한다. macOS 기본값은 Option을 특수문자 입력으로 소비하므로 터미널 쪽 설정이 먼저다.
  - kitty: 기본으로 보낸다 (추가 설정 불필요)
  - Terminal.app: 설정 → 프로파일 → 키보드 → "Option 키를 Meta 키로 사용"
  - iTerm2: Profiles → Keys → Left/Right Option key → `Esc+`
  - VS Code: `"terminal.integrated.macOptionIsMeta": true`

  다른 시퀀스를 보내는 터미널이면 `cat -v`로 실제 값을 확인하고 `bindkey`를 그 값에 맞춘다. `^[b` / `^[f`(Meta 방식)는 zsh 기본 바인딩이라 별도 설정이 필요 없다.
- 머신마다 다른 값이나 저장소에 남기고 싶지 않은 설정은 `~/.zshrc.local`에 둔다. `.zshrc` 마지막 줄이 있으면 읽고 없으면 건너뛴다. 이 파일은 저장소에 넣지 않는다.

  ```sh
  cat >> ~/.zshrc.local <<'EOF'
  export AWS_PROFILE=<프로필 이름>
  EOF
  ```
