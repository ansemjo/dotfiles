# Various settings for bash and vim

## bashrc
This is how your bash prompt might look like:

![](https://i.imgur.com/uNOXvNM.png "preview hosted on imgur")

### installation
The directory where bash looks for global configuration files may differ and/or should be included in /etc/profile. Usually it should be `/etc/bash.bashrc` though.

The following commands apply these settings globally for all users, thus you'll need superuser permissions along the way.

+ __clone repository:__
  * `# git clone https://github.com/ansemjo/bashrc.git /etc/bashgit`
+ __create symlinks (creating backups of any existing files):__
  * `# ln -svbS .bak /etc/bashgit/bash.bashrc /etc/bashgit/bash.aliases /etc/`
  
### per-user customization
+ __copy & edit per-user-config file:__
  * `$ cp /etc/bashgit/.bash_options ~/`
  * `$ vi ~/.bash_options`
  
All the options are explained within the file. For colour escape codes see [here](http://misc.flogisoft.com/bash/tip_colors_and_formatting) or use your new bash alias 'colors'.


## vimrc

Your global vimrc should be either at `/etc/vimrc` or `/etc/vim/vimrc`:

+ __create symlink (creating a backup of any existing file):__
  * `# ln -svbS .bak /etc/bashgit/vimrc /etc/vim/`

Inside the file, you might need to change `runtime! archlinux.vim` to reflect your system. Look in your original vimrc for hints.
