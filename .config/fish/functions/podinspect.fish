function podinspect --wraps='podman rm' --description '[Podman] Inspect a given(argv) pod'
    podman inspect $argv | jq '.[]'
end
