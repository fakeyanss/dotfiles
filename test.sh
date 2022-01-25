# BREW_TAPS="$(brew tap)"
# for tap in ${BREW_TAPS[@]}; do
    # upstream=$(git -C "$(brew --repo $tap)" remote -v | grep -e 'origin.*fetch' | awk '{print $2}')
    # upstream="https://github.com/$tap.git"
    # git -C "$(brew --repo $tap)" remote set-url origin "$upstream"
    # echo $upstream
    # brew untap $tap
# done
# git -C "$(brew --repo clojure/tools)" remote set-url origin https://github.com/clojure/homebrew-tools.git

ln -sv /Users/guichen01/.gear/dotfiles/git/.gitconfig /Users/guichen01/.gitconfig