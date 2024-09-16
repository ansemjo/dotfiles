if status is-interactive

    # configure the fish_git_prompt to be more verbose
    # https://fishshell.com/docs/current/cmds/fish_git_prompt.html
    set __fish_git_prompt_showdirtystate yes
    set __fish_git_prompt_showuntrackedfiles yes
    set __fish_git_prompt_showupstream auto
    set __fish_git_prompt_showstashstate yes
    set __fish_git_prompt_showcolorhints yes
    set __fish_git_prompt_color_prefix yellow
    set __fish_git_prompt_color_suffix yellow

end
