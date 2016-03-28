#a collection of settings and aliases for bash

## preview
![preview image](https://i.imgur.com/CAFiwm6.png "preview hosted on imgur")

## installation / usage
The directory where bash looks for global configuration files may differ and/or should be included in /etc/profile.

The following commands apply these settings globally for all users, thus you'll need superuser permissions along the way.

+ clone repository
  * ` # git clone https://github.com/ansemjo/bashrc.git /etc/bashgit`
+ create symlinks (doing backups of any existing files)
  * `# ln -svbS .bak /etc/bashgit/bash.bashrc /etc/bashgit/bash.aliases /etc/`
  
## per-user customization
+ copy & edit per-user-config file
  * `$ cp /etc/bashgit/.bash_options ~/`
  * `$ vi ~/.bash_options`
  
All the options are explained within the file. For colour escape codes see [here](http://misc.flogisoft.com/bash/tip_colors_and_formatting) or use your new bash alias 'colors'.
