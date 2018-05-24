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

![screenshot from 2018-05-24 20-47-26](https://user-images.githubusercontent.com/11139925/40505161-ecadccc2-5f82-11e8-8331-5bf86bf9e683.png)

## git

You can set some default behaviour and command aliases in git. This config sets
things like pushing new tags and using a colorful ui by default, sets some
aliases (`graph`, `ls`, `st`, `co`, `br` ...) and defines a new pretty
format.

The system configuration should be at `/etc/gitconfig`. The global (per-user)
one is at `~/.gitconfig`.

```sh
# symlink systemwide gitconfig
ln -svb $rcfiles/git/gitconfig /etc/
```

## vim

There are to many settings in that vimrc to list them all.

Your global vimrc should be either at `/etc/vimrc` or `/etc/vim/vimrc`.

```sh
# symlink systemwide vimrc
ln -svb $rcfiles/vim/vimrc /etc/
```

You might need to uncomment a `runtime! ...` line to reflect your system. Look
in your original vimrc for hints.

This config includes some lines for vim-pathogen and vim-airline. Please refer
to your distribution docs or [tpope/vim-pathogen](https://github.com/tpope/vim-pathogen)
on how to install those. You can find your global runtime path with
`vim --cmd 'echo $VIMRUNTIME|q'`.
