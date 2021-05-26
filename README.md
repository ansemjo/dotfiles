# dotfiles

This repository contains various configuration files which you can use in place
of your system's default ones. To apply these settings systemwide start by
cloning the repository into `/usr/local/etc/` and then symlink the desired
configurations in `/etc` appropriately.

You can use the `install.sh` script to create the symlinks aswell.

```bash
cd /usr/local/etc
git clone https://github.com/ansemjo/dotfiles
cd dotfiles/
./install.sh -B -abgtv
```

## bash

![dotfiles-bash](https://user-images.githubusercontent.com/11139925/64062822-21205c00-cbec-11e9-8030-61beb5066905.png)

This bashrc mainly gives you a nice and colourful prompt and a good amount of
aliases. The aliases are individually split into seperate files in
[`bash/aliases.d/`](bash/aliases.d/). Additional configuration files and the
prompt builder are in [`bash/conf.d/`](bash/conf.d/). Some highlights:

* `ll`, `lla`, `lll` - `ls` aliases to display long, all and recursively
* `tmp` - create a temporary playground in `/tmp` and remove it upon exit
* `bak` - quickly create a backup of a file or dir with `.bak` suffix
* `cb` - read or write system clipboard with xclip, e.g. `date | cb` or `var=$(cb)`
* `sd` - use `pushd` to cycle through or add directories on stack
* `hh`, `ff` - bash history and find-filename grep-ing
* `suu` - `sudo su`
* `tm` - attach to or start a new named tmux session
* `timestampfn` - output current date in iso-like format for filenames
* `docker-ssh-socket` - forward and use a Docker socket from a remote machine via an ssh tunnel
* `ffmpeg-*` - some convenience functions for ffmpeg
* `haveibeenpwned` - check piped-in passwords against leaked databases
* `ìpaddr` - parse `ip addr` output to cleanly display only addresses
* `wtfismyip` - contact `wtfismyip.com` to get public addresses
* `markman` - read a markdown file with `man`
* `nuke` - delete all files with `shred` and remove directory
* `openssl-*` - convenience functions for openssl to display certificate info etc.
* `ports` - show listening ports in reduced tabular output
* `qrclip` - display clipboard contents as qr code in terminal
* `randomname` - Docker's random naming function converted for bash
* `random{char,hex,mac,ip,key,words,star}` - various randomness functions
* `rosenbridge`, `rbsend` - pipe data back from a host through a temporary ssh tunnel

The path where bash looks for the global configuration file may differ but
it should be included in `/etc/profile`. Usually it is `/etc/bashrc` or
`/etc/bash.bashrc`.

```bash
ln -svb $dotfiles/bash/bashrc /etc/bashrc
ln -svb $dotfiles/bash/dot-bashrc /etc/skel/.bashrc
```

The `dot-bashrc` that is symlinked into the skel directory contains options
to customize the commandline prompt, so you might want to copy it to your own home, too.

## git

![dotfiles-git](https://user-images.githubusercontent.com/11139925/64062823-21205c00-cbec-11e9-9173-c2c2b14220dd.png)

You can set some default behaviour and command aliases in git. This config sets
things like pushing new tags and using a colorful interface by default, defines
a new pretty format and sets some useful aliases:

* `ll` - log last ten commits
* `st` - short status output
* `co`, `br`, `re` - aliases for `checkout`, `branch` and `remote`
* `cc` - quickly clean files
* `hash` - print current HEAD hash
* `upstream` - push to a remote and mark it as upstream
* `cl` - show a changelog, overview of commits since last tag
* `nv` - parse previous annotated tags and create a new semver-incremented
    tag (`patch`, `minor` or `major`)
* `patch` - begin adding changes with the `--patch` flag
* `rinse` - deep scrub clean up: expire reflog, gc, prune and fsck
* `output ref path/to/file` - output a specific version of a file to stdout
* `download` - save current HEAD archive as gzipped tar to stdout, as if it
    was a download from GitHub etc.


The system configuration should be at `/etc/gitconfig`. The global (per-user)
one is at `~/.gitconfig`.

```bash
ln -svb $dotfiles/git/gitconfig /etc/gitconfig
```

## vim

![dotfiles-vim](https://user-images.githubusercontent.com/11139925/64062825-21205c00-cbec-11e9-9b47-ed5ae907544a.png)

There are too many settings in that vimrc to list them all. I do, however,
suggest that you install [`vim-pathogen`](https://github.com/tpope/vim-pathogen)
and [`vim-airline`](https://github.com/vim-airline/vim-airline).

Your global vimrc should be either at `/etc/vimrc` or `/etc/vim/vimrc`.

```bash
ln -svb $dotfiles/vim/vimrc /etc/vimrc
```

## tmux

![dotfiles-tmux](https://user-images.githubusercontent.com/11139925/64062824-21205c00-cbec-11e9-8154-111a97327937.png)

After a while of constantly forgetting common `tmux` keys, I spent an evening
customizing my configuration to make it usable and more intuitive to me.

Highlights include:

* prefix key on <kbd>ctrl</kbd>-<kbd>a</kbd>
* switch panes with <kbd>alt</kbd>-<kbd>arrows</kbd>
* split panes with <kbd>prefix</kbd>-<kbd>\\</kbd> (horizontally) and
    <kbd>prefix</kbd>-<kbd>-</kbd> (vertically)
* switch windows with <kbd>prefix</kbd>-<kbd>left</kbd> (previous) and
    <kbd>prefix</kbd>-<kbd>right</kbd> (next)
* distinctive status line that should be compatible with older versions

There is also a bash alias `tm` to attach to an existing session or create
a new one if none exists.

```bash
ln -svb $dotfiles/tmux/tmux.conf /etc/tmux.conf
```

## others

Additionally there are currently some semi-maintained files for Ansible, i3 and an inputrc.

## colors

The colorscheme used above is [Base 16 Bright Dark](https://github.com/aaron-williamson/base16-gnome-terminal).
