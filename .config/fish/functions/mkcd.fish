function mkcd --description "Create a directory and cd into it"
  mkdir -p $argv
  and cd $argv
end
