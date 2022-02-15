# more-than-dotfiles


* [What does this repository do?](#what-does-this-repository-do?)
* [Installation](#installation)
* [Supported software](#supported-software)

## What does this repository do?

Automation setup by a simple script.

This project changes a number of settings and configures software on MacOS.

Before you actually execute the script, please make sure what is dotfiles and what does it do.

> ## What is dotfiles？

> Dotfiles are important files that will play an integral role in your career as a software developer.

> ## Why use dotfiles?

> You spend a sufficient amount of time fine-tuning your setup. You curate configurations and settings that best suit your workflow, aesthetic, and preferences. And you end up with a development environment that helps you, personally, be more productive.

> What if after all that time you spent, you now have to switch to a new, different machine? Does that mean you have to start all over again from the beginning?

> How would you remember the exact settings and commands you used?

> Or what if you have a second machine and you want your set up to be exactly the same on both systems?

> One of the main goals of developers is to automate repetitive tasks.

> Creating a dotfile repository that is source-controlled and hosted on GitHub will save you time when you want to set up a new computer and install the exact same settings you created for your previous one.

> That way all your settings and preferences can be reusable and consistent on other machines.

## Installation

```bash
git clone https://ghproxy.com/https://github.com/fakeYanss/dotfiles.git --depth=1 ~/.dotfiles
cd ~/.dotfiles;
# run this using terminal (not iTerm, lest iTerm settings get discarded on exit)
bash bootstrap.sh
```

## Supported software

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

TODO: log as spacevim, colourful font

