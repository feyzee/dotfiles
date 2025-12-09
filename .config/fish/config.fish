set -Ux GOPATH ~/.go
set -Ux GOPROXY https://proxy.golang.org,direct
# set -Ux QT_QPA_PLATFORMTHEME gnome
# set -Ux QT_STYLE_OVERRIDE adwaita-dark
# set -Ux QT_QPA_PLATFORM wayland
set -Ux EDITOR /opt/homebrew/bin/nvim
# set -Ux JAVA_HOME /usr/lib/jvm/java-11-openjdk/
set -Ux FZF_DEFAULT_COMMAND 'fd --type file --follow --color=always --hidden --exclude .git'
set -Ux FZF_FIND_FILE_COMMAND 'fd --type file --folloe --color=always --hidden --exclude=.git . \$dir'
set -Ux FZF_PREVIEW_DIR_CMD 'ls'
set -Ux FZF_DEFAULT_OPTS '-m --height=70% --preview="bat --theme 1337 {}" --preview-window=right:60%:wrap'
# set awsdi "--region ap-south-1 --profile di-demo"

# starship init fish | source

alias python "python3"
alias krg "kitty +kitten hyperlinked_grep"
alias cp "cp -pr"
alias ls "exa"
alias lsa "exa --long --all --git --header"
alias lsat "exa --long --all --git --header --tree"
alias lst "exa --long --git --header --tree"
alias cat "bat"
alias rmrf "rm -rf"
alias grep "rg"
alias find "fd"
alias ping "prettyping"
alias bat "bat --theme=Dracula"
alias n "nvim"
alias vim "nvim"
alias k "kubectl"
# alias steam "flatpak run com.valvesoftware.Steam"
# alias protontricks "flatpak run --command=protontricks com.valvesoftware.Steam --no-runtime"
alias urlencode='python3 -c "import sys, urllib.parse as ul; \
   print (ul.quote_plus(sys.argv[1]))"'
alias urldecode='python3 -c "import sys, urllib.parse as ul; \
    print(ul.unquote_plus(sys.argv[1]))"'

abbr kim "kitty +kitten icat"
abbr s "sudo"
abbr clr "clear"
# abbr sd "sudo dnf install"
# abbr sds "sudo dnf search"
# abbr update "sudo dnf update"
# abbr remove "sudo dnf remove"
abbr ps "procs"
abbr gc "git clone"
abbr ga "git add"
abbr gch "git checkout"
abbr gcom "git commit -m"
abbr gpo "git push origin"
abbr gpom "git push origin main"
abbr gpoms "git push origin master"
abbr gmg "git merge"
abbr gst "git status"
abbr tf "terraform"
abbr tfi "terraform init"
abbr tfp "terraform plan"
abbr tfa "terraform apply"
abbr tfd "terraform destroy"
abbr tfr "terraform refresh"
abbr dk "docker"
abbr dkr "docker run"
abbr dkb "docker build"
abbr dks "docker start"
abbr dkst "docker stop"
abbr dkrm "docker rm"
abbr dkrmi "docker rmi"
abbr dkp "docker pull"
abbr dkps "docker ps -a"
abbr dki "docker images"
abbr dkins "docker inspect"
abbr dkc "docker-compose"
abbr dkcu "docker-compose up"
abbr dkcs "docker-compose down"
abbr pod "podman"
abbr podr "podman run"
abbr podb "podman build -t"
abbr pods "podman start"
abbr podst "podman stop"
abbr podrm "podman rm"
abbr podrmi "podman rmi"
abbr podp "podman pull"
abbr podps "podman ps -a"
abbr podi "podman images"
abbr podimgp "podman image prune"
abbr podin "podinspect"
abbr podex "podman exec -it"
abbr podl "podman logs"
abbr podc "podman-compose"
abbr podcu "podman-compose up"
abbr podcs "podman-compose down"
abbr ka "kubeadm"
abbr kap "k apply"
abbr kapf "k apply -f"
abbr tmas "tmux attach-session -t"
abbr tmls "tmux ls"
abbr tmnew "tmux new -s"
abbr tmkill "tmux kill-session -t"
abbr xcs "xclip -sel clip"
abbr sc "sudo systemctl"
abbr sce "sudo systemctl enable"
abbr scs "sudo systemctl start"
abbr fd "fd -Hi" # hidden + ignore case
abbr fde "fd -e" # extension of file
abbr fds "find -S" # size based search
abbr fdd "fd -t d" # directory only
abbr py "python"
abbr py2 "python2"
abbr wcp "wl-copy"
abbr wps "wl-paste"
abbr vgi "vagrant init"
abbr vgup "vagrant up"
abbr vgh "vagrant halt"
abbr vgd "vagrant destroy -f"
abbr vgssh "vagrant ssh"
#abbr b64d "echo '' | base64 --decode"
#abbr b64e "echo '' | base64 --encode"
abbr pyserve "python -m http.server"
abbr kssh "kitty +kitten ssh"
abbr kssh-vg "kitty +kitten ssh -i .vagrant/machines/default/libvirt/private_key vagrant@192.168."
abbr gor "go run"
abbr goi "go install"
abbr got "go test"
abbr gog "go get"
abbr gogu "go get -u"
abbr gom "go mod"
abbr gomi "go mod init"
abbr y2j "wl-paste | yq eval -j | jq -c"
abbr j2y "wl-paste | yq eval -P"
abbr y2jcp "wl-paste | yq eval -j | jq -c | wl-copy"
abbr j2ycp "wl-paste | yq eval -P | wcp"

# fish_ssh_agent

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true

function bind_bang
    switch (commandline -t)[-1]
        case "!"
            commandline -t $history[1]; commandline -f repaint
        case "*"
            commandline -i !
    end
end

function bind_dollar
    switch (commandline -t)[-1]
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

function fish_user_key_bindings
    bind ! bind_bang
    bind '$' bind_dollar
end

zoxide init fish | source
