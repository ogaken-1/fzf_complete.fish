function __fzf_complete_git_source_author
  git log --format='%an <%ae>' | sort -u
end
