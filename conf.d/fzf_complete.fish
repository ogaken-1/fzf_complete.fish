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
set -g FZF_COMPLETE_GIT_TAG_SOURCE "git for-each-ref refs/tags --color=always --format='%(color:green)[tag] $FZF_COMPLETE_GIT_REF_FORMAT' 2>/dev/null | column -t -s (printf '\\t')"
set -g FZF_COMPLETE_GIT_REFLOG_SOURCE "git reflog --decorate --color=always --format='%C(green)[reflog] $FZF_COMPLETE_GIT_LOG_FORMAT' 2>/dev/null | column -t -s (printf '\\t')"
set -g FZF_COMPLETE_GIT_STASH_SOURCE "git stash list --color=always --format='$FZF_COMPLETE_GIT_STASH_FORMAT' | column -t -s (printf '\\t')"
set -g FZF_COMPLETE_GIT_REMOTE_SOURCE 'git remote'

# === Preview Commands ===
set -g FZF_COMPLETE_GIT_STATUS_PREVIEW "! git diff --exit-code --color=always -- {-1} || ! git diff --exit-code --cached --color=always -- {-1} 2>/dev/null || $FZF_COMPLETE_GIT_TREE {-1} 2>/dev/null"
set -g FZF_COMPLETE_GIT_LS_FILES_PREVIEW "$FZF_COMPLETE_GIT_CAT {}"
set -g FZF_COMPLETE_GIT_STAGED_PREVIEW 'git diff --cached --color=always -- {}'
set -g FZF_COMPLETE_GIT_MODIFIED_PREVIEW 'git diff --color=always -- {}'
set -g FZF_COMPLETE_GIT_LOG_PREVIEW 'git show --color=always {2}'
set -g FZF_COMPLETE_GIT_STASH_PREVIEW 'git show --color=always {1}'
set -g FZF_COMPLETE_GIT_REF_PREVIEW "
  switch {1}
    case '[branch]'
      git log {2} --decorate --pretty='format:%C(yellow)%h %C(green)%cd %C(reset)%s%C(red)%d %C(cyan)[%an]' --date=iso --graph --color=always
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

