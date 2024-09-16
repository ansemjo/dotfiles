# add a few common directories to path (dynamically to expand ~ at runtime)

# rust / cargo
if command -q cargo
    fish_add_path -g ~/.cargo/bin/
end

# deno
if command -q deno
    fish_add_path -g ~/.deno/bin/
end

# golang
if command -q go
    # change go path for tidier home
    set -xg GOPATH ~/.local/go
    fish_add_path -g ~/.local/go/bin
    # keep mod cache writable (golang/go #31481)
    set -xg GOFLAGS $GOFLAGS" -modcacherw"
end

# yarn
if command -q yarn
    fish_add_path -g ~/.yarn/bin
end

# use scripts from my dotfiles
fish_add_path -g /usr/local/etc/dotfiles/scripts

# .local/bin should always take precedence
fish_add_path -mg ~/.local/bin
