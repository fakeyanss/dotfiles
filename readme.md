# dotfiles

## set up
1. init
```
git init --bare $HOME/.cfg
alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc
```

2. add dotfile
```
dotfiles status
dotfiles add ~/.vim/vimrc
dotfiles commit -m 'Add vimrc'
dotfiles add ~/.bashrc
dotfiles commit -m 'Add bashrc'
```

3. create remote repository and push
```
git remote add origin <git-repo-url>
git push origin master
```

## clone on a new machine

1. alias
```
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
echo ".cfg" >> .gitignore
```

2. clone
```
git clone --bare <git-repo-url> $HOME/.cfg
```

3. checkout
```
dotfiles checkout
```

if checkout error
```
error: The following untracked working tree files would be overwritten by checkout:
    .bashrc
    .gitignore
Please move or remove them before you can switch branches.
Aborting
```

move existed files and backup
```
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}
```

and try checkout again
```
dotfiles checkout
```

