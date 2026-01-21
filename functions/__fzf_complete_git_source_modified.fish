function __fzf_complete_git_source_modified
  git diff --name-only --relative -z
end
