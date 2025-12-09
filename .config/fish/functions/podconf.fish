function podconf --wraps='podman rm' --description '[Podman] Shows configuration of a container'
    podman inspect $argv | jq '.[] | .Config'
end
