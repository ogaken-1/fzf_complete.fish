# fzf_complete.fish
#
# Git completion patterns ported from zeno.zsh
# https://github.com/yuki-yano/zeno.zsh
#
# MIT License
# Copyright (c) 2021 Yuki Yano

# === User Configuration ===
set -g FZF_COMPLETE_GIT_CAT 'cat'
set -g FZF_COMPLETE_GIT_TREE 'tree'

# === Format Strings ===
set -g FZF_COMPLETE_GIT_LOG_FORMAT '%C(magenta)%h%x09%C(yellow)%cr%x09%C(blue)[%an]%x09%C(auto)%s%d'
set -g FZF_COMPLETE_GIT_REF_FORMAT '%(color:magenta)%(refname:short)%09%(color:yellow)%(authordate:short)%09%(color:blue)[%(authorname)]'
set -g FZF_COMPLETE_GIT_STASH_FORMAT '%C(magenta)%gd%x09%C(yellow)%cr%x09%C(auto)%s'

# === Source Commands ===
set -g FZF_COMPLETE_GIT_STATUS_SOURCE 'git -c color.status=always status --short'
set -g FZF_COMPLETE_GIT_LS_FILES_SOURCE 'git ls-files -z'
set -g FZF_COMPLETE_GIT_STAGED_SOURCE 'git diff --cached --name-only --relative -z'
set -g FZF_COMPLETE_GIT_MODIFIED_SOURCE 'git diff --name-only --relative -z'
set -g FZF_COMPLETE_GIT_LOG_SOURCE "git log --decorate --color=always --format='%C(green)[commit] $FZF_COMPLETE_GIT_LOG_FORMAT' | column -t -s (printf '\\t')"
set -g FZF_COMPLETE_GIT_BRANCH_SOURCE "git for-each-ref refs/heads refs/remotes --color=always --format='%(color:green)[branch] $FZF_COMPLETE_GIT_REF_FORMAT' 2>/dev/null | column -t -s (printf '\\t')"
set -g FZF_COMPLETE_GIT_REMOTE_BRANCH_SOURCE "git for-each-ref refs/remotes --color=always --format='%(color:green)[remote] $FZF_COMPLETE_GIT_REF_FORMAT' 2>/dev/null | column -t -s (printf '\\t')"
set -g FZF_COMPLETE_GIT_TAG_SOURCE "git for-each-ref refs/tags --color=always --format='%(color:green)[tag] $FZF_COMPLETE_GIT_REF_FORMAT' 2>/dev/null | column -t -s (printf '\\t')"
set -g FZF_COMPLETE_GIT_REFLOG_SOURCE "git reflog --decorate --color=always --format='%C(green)[reflog] $FZF_COMPLETE_GIT_LOG_FORMAT' 2>/dev/null | column -t -s (printf '\\t')"
set -g FZF_COMPLETE_GIT_STASH_SOURCE "git stash list --color=always --format='$FZF_COMPLETE_GIT_STASH_FORMAT' | column -t -s (printf '\\t')"
set -g FZF_COMPLETE_GIT_REMOTE_SOURCE 'git remote'

# Switch branch source: local branches + filtered remote branches
# Remote branches are shown if:
#   - No duplicate (only exists in one remote)
#   - Duplicate exists but checkout.defaultRemote is set and matches
# Remote branches are displayed without remote/ prefix
set -g FZF_COMPLETE_GIT_SWITCH_BRANCH_SOURCE '
  set -l default_remote (git config checkout.defaultRemote 2>/dev/null)
  set -l green (set_color green)
  set -l normal (set_color normal)
  set -l yellow (set_color yellow)
  set -l blue (set_color blue)
  git for-each-ref refs/heads refs/remotes \
    --format="%(refname)%09%(refname:short)%09%(authordate:short)%09%(authorname)" 2>/dev/null | \
  awk -F"\t" -v default_remote="$default_remote" -v green="$green" -v normal="$normal" -v yellow="$yellow" -v blue="$blue" '\''
    # First pass: collect all data
    {
      refname = $1
      short = $2
      date = $3
      author = $4

      if (refname ~ /^refs\/heads\//) {
        # Local branch
        branch = short
        local_branches[branch] = 1
        if (!(branch in first_date)) {
          first_date[branch] = date
          first_author[branch] = author
        }
      } else if (refname ~ /^refs\/remotes\//) {
        # Remote branch - skip HEAD refs
        if (short ~ /\/HEAD$/) next

        # Extract remote and branch name
        idx = index(short, "/")
        remote = substr(short, 1, idx - 1)
        branch = substr(short, idx + 1)

        # Count occurrences per branch
        remote_count[branch]++
        remote_names[branch, remote_count[branch]] = remote

        if (!(branch in first_date)) {
          first_date[branch] = date
          first_author[branch] = author
        }
      }
    }
    END {
      # Second pass: output filtered results
      for (branch in first_date) {
        include = 0
        if (branch in local_branches) {
          include = 1
        } else if (branch in remote_count) {
          if (remote_count[branch] == 1) {
            include = 1
          } else if (default_remote != "") {
            for (i = 1; i <= remote_count[branch]; i++) {
              if (remote_names[branch, i] == default_remote) {
                include = 1
                break
              }
            }
          }
        }
        if (include) {
          printf "%s[switch]%s %s\t%s%s\t%s[%s]%s\n", green, normal, branch, yellow, first_date[branch], blue, first_author[branch], normal
        }
      }
    }
  '\'' | sort -t" " -k2 | column -t -s (printf "\\t")
'

# === Preview Commands ===
set -g FZF_COMPLETE_GIT_STATUS_PREVIEW "! git diff --exit-code --color=always -- {-1} || ! git diff --exit-code --cached --color=always -- {-1} 2>/dev/null || $FZF_COMPLETE_GIT_TREE {-1} 2>/dev/null"
set -g FZF_COMPLETE_GIT_LS_FILES_PREVIEW "$FZF_COMPLETE_GIT_CAT {}"
set -g FZF_COMPLETE_GIT_STAGED_PREVIEW 'git diff --cached --color=always -- {}'
set -g FZF_COMPLETE_GIT_MODIFIED_PREVIEW 'git diff --color=always -- {}'
set -g FZF_COMPLETE_GIT_LOG_PREVIEW 'git show --color=always {2}'
set -g FZF_COMPLETE_GIT_STASH_PREVIEW 'git show --color=always {1}'
set -g FZF_COMPLETE_GIT_REF_PREVIEW "
  switch {1}
    case '[branch]' '[remote]'
      git log {2} --decorate --pretty='format:%C(yellow)%h %C(green)%cd %C(reset)%s%C(red)%d %C(cyan)[%an]' --date=iso --graph --color=always
    case '[switch]'
      # Try local branch first, then fall back to remote ref
      git log {2} --decorate --pretty='format:%C(yellow)%h %C(green)%cd %C(reset)%s%C(red)%d %C(cyan)[%an]' --date=iso --graph --color=always 2>/dev/null; or git log (git for-each-ref --format='%(refname:short)' 'refs/remotes/*/{2}' | head -1) --decorate --pretty='format:%C(yellow)%h %C(green)%cd %C(reset)%s%C(red)%d %C(cyan)[%an]' --date=iso --graph --color=always
    case '[tag]'
      git log {2} --pretty='format:%C(yellow)%h %C(green)%cd %C(reset)%s%C(red)%d %C(cyan)[%an]' --date=iso --graph --color=always
    case '[commit]' '[reflog]'
      git show --color=always {2}
  end
"

# === Key Bindings ===
set -g FZF_COMPLETE_GIT_DEFAULT_BIND 'ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up,?:toggle-preview'
set -g FZF_COMPLETE_GIT_REF_BIND "ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up,?:toggle-preview,ctrl-b:reload($FZF_COMPLETE_GIT_BRANCH_SOURCE),ctrl-c:reload($FZF_COMPLETE_GIT_LOG_SOURCE),ctrl-t:reload($FZF_COMPLETE_GIT_TAG_SOURCE),ctrl-r:reload($FZF_COMPLETE_GIT_REFLOG_SOURCE)"

# === Common Options
set -g FZF_COMPLETE_COMMON_OPTS \
  --ansi \
  --expect=alt-enter \
  --height='80%' \
  --print0 \
  --no-separator \
  --select-1

# === Headers ===
set -g FZF_COMPLETE_GIT_REF_HEADER_FULL 'C-b: branch, C-c: commit, C-t: tag, C-r: reflog'
set -g FZF_COMPLETE_GIT_REF_HEADER_NO_COMMIT 'C-b: branch, C-t: tag, C-r: reflog'

# === Preset Options ===
set -g FZF_COMPLETE_GIT_PRESET_STATUS \
  --multi --no-sort \
  --bind=$FZF_COMPLETE_GIT_DEFAULT_BIND \
  --preview=$FZF_COMPLETE_GIT_STATUS_PREVIEW

set -g FZF_COMPLETE_GIT_PRESET_LS_FILES \
  --multi --read0 \
  --bind=$FZF_COMPLETE_GIT_DEFAULT_BIND \
  --preview=$FZF_COMPLETE_GIT_LS_FILES_PREVIEW

set -g FZF_COMPLETE_GIT_PRESET_STAGED \
  --multi --read0 \
  --bind=$FZF_COMPLETE_GIT_DEFAULT_BIND \
  --preview=$FZF_COMPLETE_GIT_STAGED_PREVIEW

set -g FZF_COMPLETE_GIT_PRESET_MODIFIED \
  --multi --read0 \
  --bind=$FZF_COMPLETE_GIT_DEFAULT_BIND \
  --preview=$FZF_COMPLETE_GIT_MODIFIED_PREVIEW

set -g FZF_COMPLETE_GIT_PRESET_REF_NO_HEADER \
  --bind=$FZF_COMPLETE_GIT_REF_BIND \
  --preview=$FZF_COMPLETE_GIT_REF_PREVIEW \
  --preview-window=down

set -g FZF_COMPLETE_GIT_PRESET_REF \
  $FZF_COMPLETE_GIT_PRESET_REF_NO_HEADER \
  --header=$FZF_COMPLETE_GIT_REF_HEADER_FULL

set -g FZF_COMPLETE_GIT_PRESET_LOG_SIMPLE \
  --no-sort \
  --bind=$FZF_COMPLETE_GIT_DEFAULT_BIND \
  --preview=$FZF_COMPLETE_GIT_LOG_PREVIEW

set -g FZF_COMPLETE_GIT_PRESET_STASH \
  --bind=$FZF_COMPLETE_GIT_DEFAULT_BIND \
  --preview=$FZF_COMPLETE_GIT_STASH_PREVIEW

set -g FZF_COMPLETE_GIT_PRESET_REMOTE \
  --bind=$FZF_COMPLETE_GIT_DEFAULT_BIND

if [ -z "$FZF_COMPLETE_NO_DEFAULT_BINDING" ]
  bind tab fzf_complete
end

