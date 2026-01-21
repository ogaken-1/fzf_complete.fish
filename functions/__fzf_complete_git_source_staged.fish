function __fzf_complete_git_source_staged
  git diff --cached --name-only --relative -z
end
