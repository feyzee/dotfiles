# Docker specific functions
function dkns --wraps='docker rm' --description '[Docker] Shows network settings of a container'
    podman inspect $argv | jq '.[] | .NetworkSettings'
end

function dkip --wraps='docker rm' --description '[Docker] Shows IP address of a container'
    podman inspect $argv | jq '.[] | .NetworkSettings | .IPAddress'
end

# Podman specific functions
function podconf --wraps='podman rm' --description '[Podman] Shows configuration of a container'
    podman inspect $argv | jq '.[] | .Config'
end

function podhconfig --wraps='podman rm' --description '[Podman] Shows host configuration of a container'
    podman inspect $argv | jq '.[] | .HostConfig'
end

function podip --wraps='podman rm' --description '[Podman] Shows IP address of a container'
    podman inspect $argv | jq '.[] | select(.State.Running).NetworkSettings.IPAddress'
end

function podns --wraps='podman rm' --description '[Podman] Shows network settings of a container'
    podman inspect $argv | jq '.[] | .NetworkSettings'
end

function podstate --wraps='podman rm' --description '[Podman] Shows network settings of a container'
    podman inspect $argv | jq '.[] | .State'
end

function podinspect --wraps='podman rm' --description '[Podman] Inspect a given(argv) pod'
    podman inspect $argv | jq '.[]'
end
