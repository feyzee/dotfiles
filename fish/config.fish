# Environment Variables
set -Ux GOPATH ~/go
set -Ux GOPROXY https://proxy.golang.org,direct
set -Ux QT_QPA_PLATFORMTHEME gnome
set -Ux QT_STYLE_OVERRIDE adwaita-dark
set -Ux QT_QPA_PLATFORM wayland
set -Ux EDITOR /usr/bin/nvim
# set -Ux JAVA_HOME /usr/lib/jvm/java-11-openjdk/
set -Ux FZF_DEFAULT_COMMAND 'fd --type file --follow --color=always --hidden --exclude .git'
set -Ux FZF_FIND_FILE_COMMAND 'fd --type file --folloe --color=always --hidden --exclude=.git . \$dir'
set -Ux FZF_PREVIEW_DIR_CMD ls
set -Ux FZF_DEFAULT_OPTS '-m --height=70%'
set -gx USE_GKE_GCLOUD_AUTH_PLUGIN True
set -gx BAT_THEME ansi
set -gx OPENROUTER_API_KEY
set -gx OPEANAI_API_KEY

complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

kubectl completion fish | source
direnv hook fish | source

# Aliases
alias python python3
alias krg "kitty +kitten hyperlinked_grep"
alias protontricks "flatpak run --command=protontricks com.valvesoftware.Steam --no-runtime"
alias cp "cp -pr"
alias ls eza
alias lsa "eza --long --all --git --header"
alias lsat "eza --long --all --git --git-ignore --header --tree -I .git"
alias lst "eza --long --git --header --tree"
alias cat bat
alias rmrf "rm -rf"
alias grep rg
alias find fd
alias g git
alias n nvim
alias k kubectl
# alias cd "z"
alias tf terraform
alias tg terragrunt
alias lg lazygit
alias dk docker
# alias hyg "kitty +kitten hyperlinked_grep"
alias steam "flatpak run com.valvesoftware.Steam"
alias brightness "sudo ddcutil setvcp 0x10"
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.uquote_plus(sys.argv[1]))"'
alias kubectx "kubectl ctx"
alias neat "kubectl neat"
alias y2j "yq eval -o=json"
alias j2y "yq eval -P"
alias sun "sudoedit nvim"

# Abbreviations
abbr kim "kitty +kitten icat"
abbr s sudo
abbr clr clear
abbr dnfi "sudo dnf install"
abbr dnfs "sudo dnf search"
abbr update "sudo dnf update"
abbr dnfr "sudo dnf remove"
abbr ps procs
abbr gcom "g commit -m"
abbr gcoms "g commit -S -m"
abbr gc "g clone"
abbr gch "g checkout"
abbr gs "g switch"
abbr gbr "g branch"
abbr gmg "g merge"
abbr ga "g add"
abbr gpo "g push origin"
abbr gpom "g push origin main"
abbr gpoms "g push origin master"
abbr gst "g status"
abbr tfi "tf init"
abbr tfp "tf plan"
abbr tfa "tf apply"
abbr tfd "tf destroy"
abbr tfr "tf refresh"
abbr tgi "tg init"
abbr tgp "tg plan"
abbr tga "tg apply"
abbr tgd "tg destroy"
abbr tgr "tg refresh"
abbr dkr "dk run"
abbr dkb "dk build"
abbr dks "dk start"
abbr dkst "dk stop"
abbr dkrm "dk rm"
abbr dkrmi "dk rmi"
abbr dkp "dk pull"
abbr dkpu "dk push"
abbr dkps "dk ps -a"
abbr dki "dk images"
abbr dkins "dk inspect"
abbr pod podman
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
abbr podin podinspect
abbr podex "podman exec -it"
abbr podl "podman logs"
abbr podc podman-compose
abbr podcu "podman-compose up"
abbr podcs "podman-compose down"
abbr kg "k get"
abbr kgn "k get -n"
abbr kga "k get -A"
abbr kgal "k get all"
abbr kgpo "k get po"
abbr kd "k describe"
abbr kdn "k describe -n"
abbr kdpo "k describe po"
abbr kcc "k config current-context"
abbr kr "k run"
abbr ka "k apply"
abbr kaf "k apply -f"
abbr kc "k create"
abbr kcf "k create -f"
abbr kdel "k delete"
abbr kdelf "k delete -f"
abbr kad kubeadm
abbr tmas "tmux attach-session -t"
abbr tmls "tmux ls"
abbr tmnew "tmux new -s"
abbr tmkill "tmux kill-session -t"
abbr xcs "xclip -sel clip"
abbr pbcp pbcopy
abbr pbp pbpaste
abbr wps wl-paste
abbr wcp wl-copy
abbr sc "sudo systemctl"
abbr sce "sudo systemctl enable"
abbr scs "sudo systemctl start"
abbr fd "fd -Hi" # hidden + ignore case
abbr fde "fd -e" # extension of file
abbr fds "find -S" # size based search
abbr fdd "fd -t d" # directory only
abbr py python
abbr py2 python2
abbr vgi "vagrant init"
abbr vgup "vagrant up"
abbr vgh "vagrant halt"
abbr vgd "vagrant destroy -f"
abbr vgssh "vagrant ssh"
#abbr b64d "echo '' | base64 --decode"
#abbr b64e "echo '' | base64 --encode"
abbr pyserve "python -m http.server"
abbr kssh "kitty +kitten ssh"
abbr gor "go run"
abbr goi "go install"
abbr got "go test"
abbr gog "go get"
abbr gom "go mod"
abbr gomi "go mod init"
abbr knyq "neat | yq"
abbr knjq "neat | jq"
abbr jfmt "wl-paste | jq | wl-copy"
# abbr drn "--dry-run=client -o=yaml"
abbr dnsrt "sudo systemctl restart systemd-resolved.service"

# fish_ssh_agent

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true

function bind_bang
    switch (commandline -t)[-1]
        case "!"
            commandline -t $history[1]
            commandline -f repaint
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

function __direnv_export_eval --on-event fish_prompt

    /usr/bin/direnv export fish | source

    if test "$direnv_fish_mode" != disable_arrow

        function __direnv_cd_hook --on-variable PWD

            if test "$direnv_fish_mode" = eval_after_arrow

                set -g __direnv_export_again 0

            else

                /usr/bin/direnv export fish | source

            end

        end

    end

end

# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/home/stellarexplosions/tmp/google-cloud-sdk/path.fish.inc' ]; . '/home/stellarexplosions/tmp/google-cloud-sdk/path.fish.inc'; end

zoxide init fish | source
