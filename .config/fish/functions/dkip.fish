function dkip --wraps='docker rm' --description '[Docker] Shows IP address of a container'
    podman inspect $argv | jq '.[] | .NetworkSettings | .IPAddress'
end
