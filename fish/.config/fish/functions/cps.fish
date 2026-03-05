function cps --description "Clipboard paste"
    # Detect platform
    set os (uname -s)
    switch $os
        case Darwin
            pbpaste
        case Linux
            wl-paste
        case '*'
            echo "OS not supported"
    end
end
