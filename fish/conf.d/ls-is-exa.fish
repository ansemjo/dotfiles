# nicer directory listings with exa/eza
if command -q exa

    # use dracula theme
    set -xg EXA_COLORS "uu=36:gu=37:sn=32:sb=32:da=34:ur=34:uw=35:ux=36:ue=36:gr=34:gw=35:gx=36:tr=34:tw=35:tx=36:"

    # useful aliases
    alias ls "exa --group-directories-first --classify"
    alias ll "ls --long"
    alias lt "ls --tree"

end
