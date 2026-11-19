#!/usr/bin/env bash
# installs bashed_desktop: links bin/bashed_desktop into ~/.local/bin
set -eu

#bash 5 check, macOS ships bash 3
if (( BASH_VERSINFO[0] < 5 )); then
    echo "need bash 5 (macOS: brew install bash)" >&2
    exit 1
fi

#the folder this script lives in, so it works from anywhere
here=$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)

#make the launcher runnable, then link it
mkdir -p "$HOME/.local/bin"
chmod +x "$here/bin/bashed_desktop"
ln -sf "$here/bin/bashed_desktop" "$HOME/.local/bin/bashed_desktop"

echo "installed: ~/.local/bin/bashed_desktop"

#tell the user if ~/.local/bin is not on their PATH yet
case :$PATH: in
    *":$HOME/.local/bin:"*) echo "run it with: bashed_desktop" ;;
    *)
        echo "add this line to ~/.zshrc, then open a new terminal:"
        #shellcheck disable=SC2016  # the $HOME is meant to be printed as text
        echo '  export PATH="$HOME/.local/bin:$PATH"'
        ;;
esac