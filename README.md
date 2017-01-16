# rcfiles

This repository contains various configuration files which you can use in place
of your system's default ones. To apply these settings systemwide start by
cloning the repository into `/usr/local/etc/` or `/etc/`, whichever you prefer.

```
# clone repository:
rcfiles=/usr/local/etc/rcfiles
git clone https://git.semjonov.de/ansemjo/rcfiles.git $rcfiles
```

Now apply the configurations by symlinking.



# bash

This bashrc mainly gives you a nice and colourful prompt and a good amount of
aliases. The aliases are individually split into seperate files in
`$rcfiles/bash/bash.aliases/`.

The path where bash looks for the global configuration file may differ but
should be included in `/etc/profile`. Usually it should be `/etc/bash.bashrc`
though.

```
# symlink systemwide bashrc and skel, making backup of any existing files
ln -svb $rcfiles/bash/bash.bashrc /etc/
ln -svb $rcfiles/bash/skel/.bashrc /etc/skel/
```

The `.bashrc` that is symlinked into the skeleton directory contains options
to customize the PS1 prompt, so you might want to copy it to your own home, too.
For usable colour escape codes either use your new bash alias `colors` or look
[here](http://misc.flogisoft.com/bash/tip_colors_and_formatting).



# git

You can set some default behaviour and command aliases in git. This config sets
things like pushing new tags and using a colorful ui by default, sets some
aliases (`graph`, `summary`, `st`, `co`, `br` ...) and defines a new pretty
format.

The system
configuration should be at `/etc/gitconfig`. The global (per-user) one is at
`~/.gitconfig`.

```
# symlink systemwide gitconfig
ln -svf $rcfiles/git/gitconfig /etc/
```



# vim

There are to many settings in that vimrc to list them all.

Your global vimrc should be either at `/etc/vimrc` or `/etc/vim/vimrc`.

```
# symlink systemwide vimrc
ln -svb $rcfiles/vim/vimrc /etc/
```

You might need to uncomment a `runtime! ...` line to reflect your system. Look
in your original vimrc for hints.