# environment variables
set -Ux GOPATH ~/.go
set -Ux GOPROXY https://proxy.golang.org,direct
set -Ux EDITOR /opt/homebrew/bin/nvim
# set -Ux JAVA_HOME /usr/lib/jvm/java-11-openjdk/
set -Ux FZF_DEFAULT_COMMAND 'fd --type file --follow --color=always --hidden --exclude .git'
set -Ux FZF_FIND_FILE_COMMAND 'fd --type file --folloe --color=always --hidden --exclude=.git . \$dir'
set -Ux FZF_PREVIEW_DIR_CMD ls
set -Ux FZF_DEFAULT_OPTS '-m --height=70% --preview="bat --theme 1337 {}" --preview-window=right:60%:wrap'

# aliases
alias python python3
alias py python
alias cp "cp -pr"
alias ls eza
alias lsa "eza --long --all --git --header"
alias lst "eza --long --git --header --tree"
alias lsat "eza --long --all --git --header --tree"
alias cat bat
alias rmrf "rm -rf"
alias grep rg
alias find fd
alias fd "fd -Hi" # hidden + ignore case
alias ping prettyping
alias vim nvim
alias n nvim
alias k kubectl
alias steam "flatpak run com.valvesoftware.Steam"
alias protontricks "flatpak run --command=protontricks com.valvesoftware.Steam --no-runtime"

# abbreviations
# podman + docker
abbr pds "podman start"
abbr pdst "podman stop"
abbr pdrm "podman rm"
abbr pdrmi "podman rmi"
abbr pdps "podman ps -a"
abbr pdi "podman images"
abbr pdx "podman exec -it"
abbr pdl "podman logs"
abbr dks "docker start"
abbr dkst "docker stop"
abbr dkrm "docker rm"
abbr dkrmi "docker rmi"
abbr dkps "docker ps -a"
abbr dki "docker images"
abbr dkx "docker exec -it"
abbr dkl "docker logs"

abbr ka "k apply"
abbr kaf "k apply -f"
abbr kd "k delete"
abbr kdf "k delete -f"

abbr tmas "tmux attach-session -t"
abbr tmls "tmux ls"
abbr tmnew "tmux new -s"
abbr tmkill "tmux kill-session -t"

abbr sc "sudo systemctl"
abbr sce "sudo systemctl enable"
abbr scs "sudo systemctl start"

abbr fde "fd -e" # extension of file
abbr fds "find -S" # size based search
abbr fdd "fd -t d" # directory only

abbr wcp wl-copy
abbr wps wl-paste

abbr gorn "go run"
abbr goi "go install"
abbr got "go test"
abbr gog "go get"
abbr gom "go mod"

abbr y2j "wl-paste | yq eval -j | jq -c"
abbr j2y "wl-paste | yq eval -P"
abbr y2jcp "wl-paste | yq eval -j | jq -c | wl-copy"
abbr j2ycp "wl-paste | yq eval -P | wcp"

# fish related configs
fish_config theme choose Catppuccin\ Macchiato
# fish_config theme save "Catppuccin Macchiato"

# add folders to $PATH
fish_add_path ~/go/bin
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin
fish_add_path /opt/homebrew/bin
fish_add_path /usr/local/go/bin
fish_add_path /usr/local/bin

# load zoxide
zoxide init fish | source
