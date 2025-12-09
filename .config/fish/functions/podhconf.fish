function podhconfig --wraps='podman rm' --description '[Podman] Shows host configuration of a container'
    podman inspect $argv | jq '.[] | .HostConfig'
end
