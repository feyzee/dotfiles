function dkns --wraps='docker rm' --description '[Docker] Shows network settings of a container'
    podman inspect $argv | jq '.[] | .NetworkSettings'
end
