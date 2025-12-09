function podstate --wraps='podman rm' --description '[Podman] Shows network settings of a container'
    podman inspect $argv | jq '.[] | .State'
end
