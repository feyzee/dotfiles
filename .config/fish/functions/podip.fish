function podip --wraps='podman rm' --description '[Podman] Shows IP address of a container'
    podman inspect $argv | jq '.[] | select(.State.Running).NetworkSettings.IPAddress'
end
