# __fzf_complete_git.fish - Git Completion rules
# See: ../conf.d/fzf_complete.fish ./fzf_complete.fish
#
# Git completion patterns ported from zeno.zsh
# https://github.com/yuki-yano/zeno.zsh
#
# MIT License
# Copyright (c) 2021 Yuki Yano

# === Transformers ===
# fzfでの選択結果をcommandline引数形式に変換
function __fzf_complete_git_status_to_arg
  cat | string sub -s 4
end

function __fzf_complete_git_ref_to_arg
  cat | string split \t | head -1 | awk '{ print $2 }'
end

function __fzf_complete_git_stash_to_arg
  cat | string split \t | head -1 | awk '{ print $1 }'
end

# === Parser ===
# Parse commandline and return completion type and prompt
# Output format: type\tpreset_variant\tprompt
# type: status_file, ls_file, branch, commit, tag, stash (singular = no extra --multi)
#       status_files, ls_files, branches, commits, tags, stashes (plural = add --multi for ref types)
# preset_variant: normal, no_header, log_simple, no_transformer
# Returns 1 if no match found
function __fzf_complete_git_parse_cmdline
  set -l cmd $argv[1]

  # git add
  if string match -rq '^git add(?: .*)? $' -- $cmd
    echo "status_file\tnormal\tGit Add Files> "
    return 0

  # git diff files (with --)
  else if string match -rq '^git diff(?=.* -- ) .* $' -- $cmd
    and not string match -rq '^git diff.* [^-].* -- ' -- $cmd
    and not string match -rq ' --no-index ' -- $cmd
    echo "status_file\tnormal\tGit Diff Files> "
    return 0

  # git diff branch files
  else if string match -rq '^git diff(?=.* -- ) .* $' -- $cmd
    or string match -rq '^git diff(?=.* --no-index ) .* $' -- $cmd
    echo "ls_file\tnormal\tGit Diff Branch Files> "
    return 0

  # git diff
  else if string match -rq '^git diff(?: .*)? $' -- $cmd
    echo "branches\tnormal\tGit Diff> "
    return 0

  # git commit -c/-C/--fixup/--squash
  else if string match -rq '^git commit(?: .*)? -[cC] $' -- $cmd
    or string match -rq '^git commit(?: .*)? --fixup[= ](?:amend:|reword:)?$' -- $cmd
    or string match -rq '^git commit(?: .*)? --(?:(?:reuse|reedit)-message|squash)[= ]$' -- $cmd
    and not string match -rq ' -- ' -- $cmd
    echo "commit\tlog_simple\tGit Commit> "
    return 0

  # git commit files
  else if string match -rq '^git commit(?: .*) $' -- $cmd
    and not string match -rq ' -[mF] $' -- $cmd
    and not string match -rq ' --(?:author|date|template|trailer) $' -- $cmd
    echo "status_file\tnormal\tGit Commit Files> "
    return 0

  # git checkout branch files
  else if string match -rq '^git checkout(?=.*(?<! (?:-[bBt]|--orphan|--track|--conflict|--pathspec-from-file)) [^-]) .* $' -- $cmd
    and not string match -rq ' --(?:conflict|pathspec-from-file) $' -- $cmd
    echo "ls_file\tnormal\tGit Checkout Branch Files> "
    return 0

  # git checkout
  else if string match -rq '^git checkout(?: .*)? (?:--track=)?$' -- $cmd
    and not string match -rq ' -- ' -- $cmd
    and not string match -rq ' --(?:conflict|pathspec-from-file) $' -- $cmd
    echo "branch\tno_header\tGit Checkout> "
    return 0

  # git checkout files
  else if string match -rq '^git checkout(?: .*)? $' -- $cmd
    and not string match -rq ' --(?:conflict|pathspec-from-file) $' -- $cmd
    echo "status_file\tnormal\tGit Checkout Files> "
    return 0

  # git branch -d/-D
  else if string match -rq '^git branch (?:-d|-D)(?: .*)? $' -- $cmd
    and not string match -rq ' --(?:conflict|pathspec-from-file) $' -- $cmd
    echo "branches\tnormal\tGit Delete Branch> "
    return 0

  # git reset branch files
  else if string match -rq '^git reset(?=.*(?<! --pathspec-from-file) [^-]) .* $' -- $cmd
    and not string match -rq ' --pathspec-from-file $' -- $cmd
    echo "ls_file\tnormal\tGit Reset Branch Files> "
    return 0

  # git reset
  else if string match -rq '^git reset(?: .*)? $' -- $cmd
    and not string match -rq ' -- ' -- $cmd
    and not string match -rq ' --pathspec-from-file $' -- $cmd
    echo "commit\tnormal\tGit Reset> "
    return 0

  # git reset files (fallback)
  else if string match -rq '^git reset(?: .*)? $' -- $cmd
    and not string match -rq ' --pathspec-from-file $' -- $cmd
    echo "status_file\tnormal\tGit Reset Files> "
    return 0

  # git switch
  else if string match -rq '^git switch(?: .*)? $' -- $cmd
    echo "branch\tno_header\tGit Switch> "
    return 0

  # git restore --source
  else if string match -rq '^git restore(?: .*)? (?:-s |--source[= ])$' -- $cmd
    and not string match -rq ' -- ' -- $cmd
    echo "branch\tnormal\tGit Restore Source> "
    return 0

  # git restore source files
  else if string match -rq '^git restore(?=.* (?:-s |--source[= ])) .* $' -- $cmd
    echo "ls_file\tnormal\tGit Restore Files> "
    return 0

  # git rebase branch
  else if string match -rq '^git rebase(?=.*(?<! (?:-[xsX]|--exec|--strategy(?:-options)?|--onto)) [^-]) .* $' -- $cmd
    echo "branch\tnormal\tGit Rebase Branch> "
    return 0

  # git rebase
  else if string match -rq '^git rebase(?: .*)? (?:--onto[= ])?$' -- $cmd
    and not string match -rq ' -[xsX] $' -- $cmd
    and not string match -rq ' --(?:exec|strategy(?:-option)?) $' -- $cmd
    echo "commit\tnormal\tGit Rebase Branch> "
    return 0

  # git merge --into-name
  else if string match -rq '^git merge(?: .*)? --into-name[= ]$' -- $cmd
    echo "branch\tnormal\tGit Merge Branch> "
    return 0

  # git merge
  else if string match -rq 'git merge(?: .*)? $' -- $cmd
    and not string match -rq ' -[mFsX] $' -- $cmd
    and not string match -rq ' --(?:file|strategy(?:-option)?) $' -- $cmd
    echo "commit\tnormal\tGit Merge> "
    return 0

  # git stash apply/drop/pop/show
  else if string match -rq 'git stash (?:apply|drop|pop|show)(?: .*)? $' -- $cmd
    or string match -rq 'git stash branch(?=.* [^-]) .* $' -- $cmd
    echo "stash\tnormal\tGit Stash> "
    return 0

  # git stash branch
  else if string match -rq 'git stash branch(?: .*)? $' -- $cmd
    echo "branch\tnormal\tGit Stash Branch> "
    return 0

  # git stash push files
  else if string match -rq 'git stash push(?: .*)? $' -- $cmd
    echo "status_file\tnormal\tGit Stash Push Files> "
    return 0

  # git log file
  else if string match -rq '^git log(?=.* -- ) .* $' -- $cmd
    echo "ls_file\tnormal\tGit Log File> "
    return 0

  # git log
  else if string match -rq '^git log(?: .*)? $' -- $cmd
    and not string match -rq ' --(?:skip|since|after|until|before|author|committer|date) $' -- $cmd
    and not string match -rq ' --(?:branches|tags|remotes|glob|exclude|pretty|format) $' -- $cmd
    and not string match -rq ' --grep(?:-reflog)? $' -- $cmd
    and not string match -rq ' --(?:min|max)-parents $' -- $cmd
    echo "branch\tnormal\tGit Log> "
    return 0

  # git tag list commit
  else if string match -rq '^git tag(?=.* (?:-l|--list) )(?: .*)? --(?:(?:no-)?(?:contains|merged)|points-at) $' -- $cmd
    echo "commit\tnormal\tGit Tag List Commit> "
    return 0

  # git tag delete
  else if string match -rq '^git tag(?=.* (?:-d|--delete) )(?: .*)? $' -- $cmd
    echo "tag\tnormal\tGit Tag Delete> "
    return 0

  # git tag
  else if string match -rq '^git tag(?: .*)? $' -- $cmd
    and not string match -rq ' -[umF] $' -- $cmd
    and not string match -rq ' --(?:local-user|format) $' -- $cmd
    echo "tag\tnormal\tGit Tag> "
    return 0

  # git mv files
  else if string match -rq '^git mv(?: .*)? $' -- $cmd
    echo "ls_file\tnormal\tGit Mv Files> "
    return 0

  # git rm files
  else if string match -rq '^git rm(?: .*)? $' -- $cmd
    echo "ls_file\tnormal\tGit Rm Files> "
    return 0

  # git show
  else if string match -rq '^git show(?: .*)? $' -- $cmd
    and not string match -rq ' --(?:pretty|format) $' -- $cmd
    echo "commit\tnormal\tGit Show> "
    return 0

  # git revert
  else if string match -rq '^git revert(?: .*)? $' -- $cmd
    echo "commit\tlog_simple\tGit Revert> "
    return 0

  else
    return 1
  end
end

# === Config Builder ===
# Build configuration based on completion type
# Arguments: type preset_variant prompt
# Output format (null-separated): source\0transformer\0opt1\0opt2\0...
function __fzf_complete_git_build_config
  set -l type $argv[1]
  set -l preset_variant $argv[2]
  set -l prompt $argv[3]

  set -l source ''
  set -l opts
  set -l transformer ''

  # Determine if multi-select based on type suffix (for branch/commit/tag/stash only)
  # Note: status_file and ls_file presets already include --multi
  set -l multi false
  switch $type
    case branches commits tags stashes
      set multi true
  end

  # Normalize type to singular form for mapping
  set -l base_type $type
  switch $type
    case branches
      set base_type branch
    case commits
      set base_type commit
    case tags
      set base_type tag
    case stashes
      set base_type stash
  end

  # Set source, preset, and transformer based on base type
  switch $base_type
    case status_file
      set source $FZF_COMPLETE_GIT_STATUS_SOURCE
      set -a opts $FZF_COMPLETE_GIT_PRESET_STATUS
      set transformer __fzf_complete_git_status_to_arg

    case ls_file
      set source $FZF_COMPLETE_GIT_LS_FILES_SOURCE
      set -a opts $FZF_COMPLETE_GIT_PRESET_LS_FILES

    case branch
      set source $FZF_COMPLETE_GIT_BRANCH_SOURCE
      if test "$preset_variant" = no_header
        set -a opts $FZF_COMPLETE_GIT_PRESET_REF_NO_HEADER --header=$FZF_COMPLETE_GIT_REF_HEADER_NO_COMMIT
      else
        set -a opts $FZF_COMPLETE_GIT_PRESET_REF
      end
      set transformer __fzf_complete_git_ref_to_arg

    case commit
      set source $FZF_COMPLETE_GIT_LOG_SOURCE
      if test "$preset_variant" = log_simple
        set -a opts $FZF_COMPLETE_GIT_PRESET_LOG_SIMPLE
      else
        set -a opts $FZF_COMPLETE_GIT_PRESET_REF
      end
      set transformer __fzf_complete_git_ref_to_arg

    case tag
      set source $FZF_COMPLETE_GIT_TAG_SOURCE
      set -a opts $FZF_COMPLETE_GIT_PRESET_REF
      set transformer __fzf_complete_git_ref_to_arg

    case stash
      set source $FZF_COMPLETE_GIT_STASH_SOURCE
      set -a opts $FZF_COMPLETE_GIT_PRESET_STASH
      set transformer __fzf_complete_git_stash_to_arg
  end

  # Add --multi if plural type (for ref types that don't have --multi in preset)
  if test "$multi" = true
    set -a opts --multi
  end

  # Add prompt
  set -a opts --prompt=$prompt

  # Output null-separated: source, transformer, then opts
  printf '%s\0' $source $transformer $opts
end

function __fzf_complete_rule_git
  set -l cmd (commandline)

  # Parse commandline to get completion type and prompt
  set -l parse_result (__fzf_complete_git_parse_cmdline $cmd)
  or return 1

  # Split result into type, preset_variant, and prompt
  set -l parts (string split \t $parse_result)
  set -l type $parts[1]
  set -l preset_variant $parts[2]
  set -l prompt $parts[3]

  # Build configuration and parse null-separated output
  set -l config_output (__fzf_complete_git_build_config $type $preset_variant $prompt | string split0)

  # First element is source, second is transformer, rest are opts
  set -l source $config_output[1]
  set -l transformer $config_output[2]
  set -l opts $FZF_COMPLETE_COMMON_OPTS $config_output[3..]

  __fzf_complete_run "$source" "$transformer" $opts
  return 0
end
