function __fzf_complete_git_source_status
  git -c color.status=always status --short
end
