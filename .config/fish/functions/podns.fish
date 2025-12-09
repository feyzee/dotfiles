function podns --wraps='podman rm' --description '[Podman] Shows network settings of a container'
    podman inspect $argv | jq '.[] | .NetworkSettings'
end
