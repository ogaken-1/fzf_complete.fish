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
# Parse commandline and return completion metadata
# Output format: source_type\tmulti\tbind_type\tprompt
# source_type: branch, commit, tag, stash, status_file, ls_file (always singular)
# multi: true or false
# bind_type: ref_full, ref_simple, file, stash
# Returns 1 if no match found
function __fzf_complete_git_parse_cmdline
  set -l cmd $argv[1]

  # git add
  if string match -rq '^git add(?: .*)? $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Add Files> '
    return 0

  # git diff files (with --)
  else if string match -rq '^git diff(?=.* -- ) .* $' -- $cmd
    and not string match -rq '^git diff.* [^-].* -- ' -- $cmd
    and not string match -rq ' --no-index ' -- $cmd
    printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Diff Files> '
    return 0

  # git diff branch files
  else if string match -rq '^git diff(?=.* -- ) .* $' -- $cmd
    or string match -rq '^git diff(?=.* --no-index ) .* $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Diff Branch Files> '
    return 0

  # git diff
  else if string match -rq '^git diff(?: .*)? $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' branch true ref_full 'Git Diff> '
    return 0

  # git commit -c/-C/--fixup/--squash
  else if string match -rq '^git commit(?: .*)? -[cC] $' -- $cmd
    or string match -rq '^git commit(?: .*)? --fixup[= ](?:amend:|reword:)?$' -- $cmd
    or string match -rq '^git commit(?: .*)? --(?:(?:reuse|reedit)-message|squash)[= ]$' -- $cmd
    and not string match -rq ' -- ' -- $cmd
    printf '%s\t%s\t%s\t%s\n' commit false ref_simple 'Git Commit> '
    return 0

  # git commit files
  else if string match -rq '^git commit(?: .*) $' -- $cmd
    and not string match -rq ' -[mF] $' -- $cmd
    and not string match -rq ' --(?:author|date|template|trailer) $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Commit Files> '
    return 0

  # git checkout branch files
  else if string match -rq '^git checkout(?=.*(?<! (?:-[bBt]|--orphan|--track|--conflict|--pathspec-from-file)) [^-]) .* $' -- $cmd
    and not string match -rq ' --(?:conflict|pathspec-from-file) $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Checkout Branch Files> '
    return 0

  # git checkout
  else if string match -rq '^git checkout(?: .*)? (?:--track=)?$' -- $cmd
    and not string match -rq ' -- ' -- $cmd
    and not string match -rq ' --(?:conflict|pathspec-from-file) $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' branch false ref_simple 'Git Checkout> '
    return 0

  # git checkout files
  else if string match -rq '^git checkout(?: .*)? $' -- $cmd
    and not string match -rq ' --(?:conflict|pathspec-from-file) $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Checkout Files> '
    return 0

  # git branch -d/-D
  else if string match -rq '^git branch (?:-d|-D)(?: .*)? $' -- $cmd
    and not string match -rq ' --(?:conflict|pathspec-from-file) $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' branch true ref_simple 'Git Delete Branch> '
    return 0

  # git reset branch files
  else if string match -rq '^git reset(?=.*(?<! --pathspec-from-file) [^-]) .* $' -- $cmd
    and not string match -rq ' --pathspec-from-file $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Reset Branch Files> '
    return 0

  # git reset
  else if string match -rq '^git reset(?: .*)? $' -- $cmd
    and not string match -rq ' -- ' -- $cmd
    and not string match -rq ' --pathspec-from-file $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Reset> '
    return 0

  # git reset files (fallback)
  else if string match -rq '^git reset(?: .*)? $' -- $cmd
    and not string match -rq ' --pathspec-from-file $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Reset Files> '
    return 0

  # git switch
  else if string match -rq '^git switch(?: .*)? $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' branch false ref_simple 'Git Switch> '
    return 0

  # git restore --source
  else if string match -rq '^git restore(?: .*)? (?:-s |--source[= ])$' -- $cmd
    and not string match -rq ' -- ' -- $cmd
    printf '%s\t%s\t%s\t%s\n' branch false ref_full 'Git Restore Source> '
    return 0

  # git restore source files
  else if string match -rq '^git restore(?=.* (?:-s |--source[= ])) .* $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Restore Files> '
    return 0

  # git restore --staged --worktree (both) - worktree file completion
  else if string match -rq '^git restore .* $' -- $cmd
    and string match -rq ' (?:--staged|-[SW]*S[SW]*)' -- $cmd
    and string match -rq ' (?:--worktree|-[SW]*W[SW]*)' -- $cmd
    and not string match -rq ' (?:-s |--source[= ])' -- $cmd
    and not string match -rq ' --pathspec-from-file ' -- $cmd
    printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Restore> '
    return 0

  # git restore --staged (no source) - staged file completion
  else if string match -rq '^git restore .* $' -- $cmd
    and string match -rq ' (?:--staged|-[SW]*S[SW]*)' -- $cmd
    and not string match -rq ' (?:-s |--source[= ])' -- $cmd
    and not string match -rq ' (?:--worktree|-[SW]*W[SW]*)' -- $cmd
    and not string match -rq ' --pathspec-from-file ' -- $cmd
    printf '%s\t%s\t%s\t%s\n' staged_file true file 'Git Restore Staged> '
    return 0

  # git restore (no source) - worktree file completion
  else if string match -rq '^git restore(?: .*)? $' -- $cmd
    and not string match -rq ' (?:-s |--source[= ])' -- $cmd
    and not string match -rq ' --pathspec-from-file ' -- $cmd
    printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Restore> '
    return 0

  # git rebase branch
  else if string match -rq '^git rebase(?=.*(?<! (?:-[xsX]|--exec|--strategy(?:-options)?|--onto)) [^-]) .* $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' branch false ref_full 'Git Rebase Branch> '
    return 0

  # git rebase
  else if string match -rq '^git rebase(?: .*)? (?:--onto[= ])?$' -- $cmd
    and not string match -rq ' -[xsX] $' -- $cmd
    and not string match -rq ' --(?:exec|strategy(?:-option)?) $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Rebase> '
    return 0

  # git merge --into-name
  else if string match -rq '^git merge(?: .*)? --into-name[= ]$' -- $cmd
    printf '%s\t%s\t%s\t%s\n' branch false ref_full 'Git Merge Branch> '
    return 0

  # git merge
  else if string match -rq '^git merge(?: .*)? $' -- $cmd
    and not string match -rq ' -[mFsX] $' -- $cmd
    and not string match -rq ' --(?:file|strategy(?:-option)?) $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Merge> '
    return 0

  # git stash apply/drop/pop/show
  else if string match -rq '^git stash (?:apply|drop|pop|show)(?: .*)? $' -- $cmd
    or string match -rq '^git stash branch(?=.* [^-]) .* $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' stash false stash 'Git Stash> '
    return 0

  # git stash branch
  else if string match -rq '^git stash branch(?: .*)? $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' branch false ref_full 'Git Stash Branch> '
    return 0

  # git stash push files
  else if string match -rq '^git stash push(?: .*)? $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Stash Push Files> '
    return 0

  # git log file
  else if string match -rq '^git log(?=.* -- ) .* $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Log File> '
    return 0

  # git log
  else if string match -rq '^git log(?: .*)? $' -- $cmd
    and not string match -rq ' --(?:skip|since|after|until|before|author|committer|date) $' -- $cmd
    and not string match -rq ' --(?:branches|tags|remotes|glob|exclude|pretty|format) $' -- $cmd
    and not string match -rq ' --grep(?:-reflog)? $' -- $cmd
    and not string match -rq ' --(?:min|max)-parents $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' branch false ref_full 'Git Log> '
    return 0

  # git tag list commit
  else if string match -rq '^git tag(?=.* (?:-l|--list) )(?: .*)? --(?:(?:no-)?(?:contains|merged)|points-at) $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Tag List Commit> '
    return 0

  # git tag delete
  else if string match -rq '^git tag(?=.* (?:-d|--delete) )(?: .*)? $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' tag false ref_simple 'Git Tag Delete> '
    return 0

  # git tag
  else if string match -rq '^git tag(?: .*)? $' -- $cmd
    and not string match -rq ' -[umF] $' -- $cmd
    and not string match -rq ' --(?:local-user|format) $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' tag false ref_simple 'Git Tag> '
    return 0

  # git mv files
  else if string match -rq '^git mv(?: .*)? $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Mv Files> '
    return 0

  # git rm files
  else if string match -rq '^git rm(?: .*)? $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Rm Files> '
    return 0

  # git show
  else if string match -rq '^git show(?: .*)? $' -- $cmd
    and not string match -rq ' --(?:pretty|format) $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Show> '
    return 0

  # git revert
  else if string match -rq '^git revert(?: .*)? $' -- $cmd
    printf '%s\t%s\t%s\t%s\n' commit false ref_simple 'Git Revert> '
    return 0

  # git cherry-pick
  else if string match -rq '^git cherry-pick(?: .*)? $' -- $cmd
    and not string match -rq ' --(?:continue|abort|skip|quit)' -- $cmd
    printf '%s\t%s\t%s\t%s\n' commit true ref_full 'Git Cherry-pick> '
    return 0

  else
    return 1
  end
end

# === Config Builder ===
# Build configuration based on completion metadata
# Arguments: source_type multi bind_type prompt
# Output format (null-separated): source\0transformer\0opt1\0opt2\0...
function __fzf_complete_git_build_config
  set -l source_type $argv[1]
  set -l multi $argv[2]
  set -l bind_type $argv[3]
  set -l prompt $argv[4]

  set -l source ''
  set -l opts
  set -l transformer ''

  # Set source and transformer based on source_type
  switch $source_type
    case status_file
      set source $FZF_COMPLETE_GIT_STATUS_SOURCE
      set -a opts $FZF_COMPLETE_GIT_PRESET_STATUS
      set transformer __fzf_complete_git_status_to_arg

    case ls_file
      set source $FZF_COMPLETE_GIT_LS_FILES_SOURCE
      set -a opts $FZF_COMPLETE_GIT_PRESET_LS_FILES

    case staged_file
      set source $FZF_COMPLETE_GIT_STAGED_SOURCE
      set -a opts $FZF_COMPLETE_GIT_PRESET_STAGED

    case branch
      set source $FZF_COMPLETE_GIT_BRANCH_SOURCE
      set transformer __fzf_complete_git_ref_to_arg

    case commit
      set source $FZF_COMPLETE_GIT_LOG_SOURCE
      set transformer __fzf_complete_git_ref_to_arg

    case tag
      set source $FZF_COMPLETE_GIT_TAG_SOURCE
      set transformer __fzf_complete_git_ref_to_arg

    case stash
      set source $FZF_COMPLETE_GIT_STASH_SOURCE
      set -a opts $FZF_COMPLETE_GIT_PRESET_STASH
      set transformer __fzf_complete_git_stash_to_arg
  end

  # Set opts based on bind_type for ref types (branch, commit, tag)
  switch $source_type
    case branch commit tag
      switch $bind_type
        case ref_full
          # Full preset with header (shows reload keys)
          set -a opts $FZF_COMPLETE_GIT_PRESET_REF
        case ref_simple
          # Simple preset: use LOG_SIMPLE for commits, no header for branches/tags
          switch $source_type
            case commit
              set -a opts $FZF_COMPLETE_GIT_PRESET_LOG_SIMPLE
            case branch tag
              set -a opts $FZF_COMPLETE_GIT_PRESET_REF_NO_HEADER
          end
      end
  end

  # Add --multi if needed
  # Note: status_file and ls_file presets already include --multi
  if test "$multi" = true
    switch $source_type
      case branch commit tag stash
        set -a opts --multi
    end
  end

  # Add prompt
  set -a opts --prompt=$prompt

  # Output null-separated: source, transformer, then opts
  printf '%s\0' $source $transformer $opts
end

function __fzf_complete_rule_git
  set -l cmd (commandline)

  # Parse commandline to get completion metadata
  set -l parse_result (__fzf_complete_git_parse_cmdline $cmd)
  or return 1

  # Split result into source_type, multi, bind_type, and prompt
  set -l parts (string split \t $parse_result)
  set -l source_type $parts[1]
  set -l multi $parts[2]
  set -l bind_type $parts[3]
  set -l prompt $parts[4]

  # Build configuration and parse null-separated output
  set -l config_output (__fzf_complete_git_build_config $source_type $multi $bind_type $prompt | string split0)

  # First element is source, second is transformer, rest are opts
  set -l source $config_output[1]
  set -l transformer $config_output[2]
  set -l opts $FZF_COMPLETE_COMMON_OPTS $config_output[3..]

  __fzf_complete_run "$source" "$transformer" $opts
  return 0
end
