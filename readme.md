# more-than-dotfiles

```
   _   __  _   ___   ___   _____ _ __  _   _  __      ____ __ __   ___   ___
  / \,' /,' \ / o | / _/  /_  _//// /.' \ / |/ /     / __// // /  / _/ ,' _/
 / \,' // o |/  ,' / _/    / / / ` // o // || /     / _/ / // /_ / _/ _\ `.
/_/ /_/ |_,'/_/`_\/___/   /_/ /_n_//_n_//_/|_/  () /_/  /_//___//___//___,'

```

[English](readme.md) | [中文版](readme-zh.md)


* [What does this repository do?](#what-does-this-repository-do?)
* [Installation](#installation)
* [Supported software](#supported-software)

## What does this repository do?

Automation setup by a simple script.

This project changes a number of settings and configures software on MacOS.

Before you actually execute the script, please make sure what is dotfiles and what does it do.

<details>
<summary><b>What is dotfiles？</b></summary>

> Dotfiles are important files that will play an integral role in your career as a software developer.

</details>

<details>

<summary><b>Why use dotfiles?</b></summary>

> You spend a sufficient amount of time fine-tuning your setup. You curate configurations and settings that best suit your workflow, aesthetic, and preferences. And you end up with a development environment that helps you, personally, be more productive.
>
> What if after all that time you spent, you now have to switch to a new, different machine? Does that mean you have to start all over again from the beginning?
>
> How would you remember the exact settings and commands you used?
>
> Or what if you have a second machine and you want your set up to be exactly the same on both systems?
>
> One of the main goals of developers is to automate repetitive tasks.
>
> Creating a dotfile repository that is source-controlled and hosted on GitHub will save you time when you want to set up a new computer and install the exact same settings you created for your previous one.
>
> That way all your settings and preferences can be reusable and consistent on other machines.

</details>

## Installation

```bash
git clone https://ghproxy.com/https://github.com/fakeYanss/dotfiles.git --depth=1 ~/.dotfiles
cd ~/.dotfiles;
# run this using terminal (not iTerm, lest iTerm settings get discarded on exit)
bash bootstrap.sh
```

## Supported software

> TODO: log as spacevim, colourful font for cool logging

Here is the supported software list.

| name                                       | description                                                                                              | support |
|--------------------------------------------|----------------------------------------------------------------------------------------------------------|---------|
| git                                        | prerequirement, and upgrade by homebrew in a moment                                                      | ✔       |
| homebrew                                   | the beginning of all things                                                                              | ✔       |
| zsh & oh my zsh                            | using evalcache, speeding up the zsh loading                                                             | ✔       |
| neovim                                     | neovim config, support markdown, lsp, autocomplete, highlight...                                         | ✔       |
| java                                       | using AdoptOpenJdk and jenv                                                                              | ✔       |
| go                                         | using goenv                                                                                              | ✔       |
| python                                     | using pyenv                                                                                              | ✔       |
| node                                       | using nvm                                                                                                | ✔       |
| hammonspoon                                | caffinate, window manager, clipboard history, wallpaper from unsplash, network speed in menubar...       | ✔       |
| picgo                                      | picture bed integration and uploader                                                                     | ✔       |
| customized function & alias                | sudo passwordless, switch darkmode and lightmode, pbcopy & pbpaste                                       | ✔       |
| localizational for users in Mainland China | for network environment, default support homebrew proxy and mirror, github proxy, npm mirror, pip mirror | ✔       |

## Usage

### git

available commands as follow:

```
git st # status
git lg #
git co # checkout
git ranks # code line statistic
```

### homebrew

available commands as follow:

```
HOMEBREW_NO_AUTO_UPDATE=1 brew install $1 # install without brew update
```

### neovim

Use alias vim as nvim.

Use <Space> as <Leader>

#### Packer

available commands as follow:

```
vim +PackerSync
PackerStatus
```

#### window

```
<Leader>m # toggle nvim-tree
<Leader>, # toggle symbols outline
<ALT>H # bufferline cycle next
<ALT>L # bufferline cycle pre
<Leader>w\ # split window vertical
<Leader>w- # split window horizontal
<Leader>wc # close current window
<Leader>wo # close other window
<Leader>h # focus on left window 
<Leader>j # focus on below window 
<Leader>k # focus on upper window 
<Leader>l # focus on right window 
```

#### find

#### lsp

#### markdown

#### venn

Draw ASCII diagrams 

available commands as follow:

```
<space>v # toggle venn mode

Visual Block + f # draw a single line box

:VBox # draw a single line box or arrow
┌───┐
│box│
└───┘

:VBoxD # draw a double line box or arrow
╔══╗
║aa║
╚══╝

:VBoxH # draw a heavy line box or arrow
┏━━┓
┃bb┃
┗━━┛

:VFill # fill the area with a solid color
███
███

<shift>hjkl # draw arrow
     ▲
     │
 ◄──   ──►
     │
     ▼
```

### java

available commands as follow:

```
jenv global 1.8 # set global java version
jenv local 1.8 # generate a .java-version file in current folder
```

### go

available commands as follow:

```
goenv install -l # list available go versions
goenv install $1 # install go version
goenv global $1 # set global go version 
```

### python

available commands as follow:

```
pyenv install -l # list avaliable python versions
pyenv_install $1 # install python version from mirror
pyenv global $1 # set global python version
```

### node

available commands as follow:

```
nvm ls-remote --lts # list available node versions
nvm ls # list installed node versions
```

### harmerspoon

available commands as follow:

```
<CMD>q # hold to quit
<CTRL><ALT>m # caffeine
<CMD><SHIFT>v # clipboard
<ALT>d # open aria2 panel

<ALT>r # enable windows manipulation mode
-- q # quit windows manipulation mode
-- <TAB> # open cheatsheet 
-- h # lefthalf
-- l # righthalf
-- j # downhalf
-- k # uphalf
-- c # center
-- <UP> # move to above monitor
-- <DOWN> # move to below monitor
```

### useful function

```
gitclone # customized function, using ghproxy.com for proxy
darklight # toggle darkmode lightmode on macOS
``` 

