function __fzf_complete_docker_source_volume
  docker volume ls --format '{{"\033[35m"}}{{.Name}}{{"\033[0m"}}\t{{.Driver}}\t{{.Scope}}' 2>/dev/null | column -t -s (printf '\t')
end
