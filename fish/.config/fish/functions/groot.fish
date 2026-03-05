function gcd --description 'CD to root folder of [g]it [r]epo'
    cd (git rev-parse --show-toplevel 2>/dev/null)
end
