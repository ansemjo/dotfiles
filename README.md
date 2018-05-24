# dotfiles

This repository contains various configuration files which you can use in place
of your system's default ones. To apply these settings systemwide start by
cloning the repository into `/usr/local/etc/`. **Alternatively** you can use
the [Ansible role](https://github.com/ansemjo/role-dotfiles) that I created for
this purpose.

```bash
# dotfiles=/usr/local/etc/dotfiles
# git clone https://github.com/ansemjo/dotfiles "$rcfiles"
```

Then apply the configurations by symlinking to the appropriate files in `/etc`.

## bash

![screenshot from 2018-05-24 20-47-26](https://user-images.githubusercontent.com/11139925/40505161-ecadccc2-5f82-11e8-8331-5bf86bf9e683.png)

This bashrc mainly gives you a nice and colourful prompt and a good amount of
aliases. The aliases are individually split into seperate files in
`bash/aliases.d/`. Additional configuration files and the prompt builder are in
`bash/conf.d/`.

The path where bash looks for the global configuration file may differ but
should be included in `/etc/profile`. Usually it should be `/etc/bashrc` or
`/etc/bash.bashrc`.

```bash
ln -svb $dotfiles/bash/bashrc /etc/bashrc
ln -svb $dotfiles/bash/dot-bashrc /etc/skel/.bashrc
```

The `dot-bashrc` that is symlinked into the skel directory contains options
to customize the commandline prompt, so you might want to copy it to your own home, too.

## git

![screenshot from 2018-05-24 20-53-26](https://user-images.githubusercontent.com/11139925/40505468-c3f38406-5f83-11e8-927c-7eb0067e5c57.png)

You can set some default behaviour and command aliases in git. This config sets
things like pushing new tags and using a colorful ui by default, sets some
aliases (`graph`, `ls`, `st`, `co`, `br` ...) and defines a new pretty
format.

The system configuration should be at `/etc/gitconfig`. The global (per-user)
one is at `~/.gitconfig`.

```bash
ln -svb $dotfiles/git/gitconfig /etc/gitconfig
```

## vim

![screenshot from 2018-05-24 20-56-36](https://user-images.githubusercontent.com/11139925/40505592-391dc656-5f84-11e8-8e40-3dc02d5554db.png)

There are too many settings in that vimrc to list them all. I do, however, suggest that you install
[`vim-pathogen`](https://github.com/tpope/vim-pathogen) and [`vim-airline`](https://github.com/vim-airline/vim-airline).

Your global vimrc should be either at `/etc/vimrc` or `/etc/vim/vimrc`.

```bash
ln -svb $dotfiles/vim/vimrc /etc/vimrc
```

## others

Additionally there are currently some semi-maintained files for Ansible, i3 and an inputrc.
