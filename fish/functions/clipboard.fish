function clipboard -d "paste from or copy into clipboard"
    if isatty stdin
        # at the front of a pipe --> paste clipboard
        xclip -selection clipboard -out
    else
        # at the end of a pipe --> copy to clipboard
        xclip -selection clipboard -in
    end
end
