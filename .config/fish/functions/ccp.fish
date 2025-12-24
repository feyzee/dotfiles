function ccp --description "Clipboard copy"
    # Detect platform
    set os (uname -s)
    switch $os
        case Darwin
            pbcopy
        case Linux
            wl-copy
        case '*'
            echo "OS not supported"
    end
    return 1
end
