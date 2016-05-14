_various settings for bash, vim and git .._

# bashrc

### installation
The directory where bash looks for global configuration files may differ and/or
should be included in /etc/profile. Usually it should be `/etc/bash.bashrc`
though.

The following commands apply these settings globally for all users, thus you'll
need superuser permissions along the way.

+ __clone repository:__
  * `# git clone https://git.semjonov.de/ansemjo/rcfiles.git /etc/rcfiles`
+ __create symlinks in `/etc` (creating backups of any existing files):__
  * `# ln -svbS .bak /etc/rcfiles/bash.* /etc/`
  
### per-user customization
+ __copy & edit per-user-config file:__
  * `$ cp /etc/rcfiles/.bash_options ~/`
  * `$ vi ~/.bash_options`
+ __.. or copy it into the skeleton for new users:__
  * `# cp /etc/rcfiles/.bash_options /etc/skel/`
  
All the options are explained within the file. For colour escape codes see
[here](http://misc.flogisoft.com/bash/tip_colors_and_formatting) or use your new
bash alias 'colors'.


# vimrc

Your global vimrc should be either at `/etc/vimrc` or `/etc/vim/vimrc`:

+ __create symlink in `/etc` (creating a backup of any existing file):__
  * `# ln -svbS .bak /etc/rcfiles/vimrc /etc/`

Inside the file, you might need to change the `runtime! ...` line to reflect
your system. Look in your original vimrc for hints.