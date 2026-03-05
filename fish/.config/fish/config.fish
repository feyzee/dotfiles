# environment variables
set -Ux GOPATH ~/.go
set -Ux GOPROXY https://proxy.golang.org,direct
# set -Ux JAVA_HOME /usr/lib/jvm/java-11-openjdk/
set -Ux FZF_DEFAULT_COMMAND 'fd --type file --follow --color=always --hidden --exclude .git'
set -Ux FZF_FIND_FILE_COMMAND 'fd --type file --folloe --color=always --hidden --exclude=.git . \$dir'
set -Ux FZF_PREVIEW_DIR_CMD ls
set -Ux FZF_DEFAULT_OPTS '-m --height=70% --preview="bat --theme 1337 {}" --preview-window=right:60%:wrap'


# TODO: add conditional
if test (uname -a) = "Darwin"
    set -Ux EDITOR /opt/homebrew/bin/nvim
else
    set -Ux EDITOR /usr/bin/nvim
end

fish_config theme choose Catppuccin\ Macchiato

# add folders to $PATH
fish_add_path ~/.local/bin
fish_add_path ~/.local/bin/npm/bin
fish_add_path ~/.bun/bin
fish_add_path ~/go/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.opencode/bin
fish_add_path ~/.krew/bin/
fish_add_path /opt/homebrew/bin
fish_add_path /usr/local/go/bin
fish_add_path /usr/local/bin

function fish_greeting
end

# Navigation
function ..
    cd ..
end
function ...
    cd ../..
end
function ....
    cd ../../..
end
function .....
    cd ../../../..
end

source ~/.config/fish/aliases.fish

# load zoxide
zoxide init fish | source

# load direnv
direnv hook fish | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
