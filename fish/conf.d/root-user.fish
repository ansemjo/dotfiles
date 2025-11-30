# print a warning for root
if status is-interactive && [ (id -un) = root ]
    echo (set_color red)" ~~ Here be dragons. This is a root shell! ~~"(set_color normal)
end
