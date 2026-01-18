# Test __fzf_complete_git_build_config output format and values
# The function outputs null-separated: source, transformer, then opts

source (status dirname)/../functions/__fzf_complete_rule_git.fish
source (status dirname)/../conf.d/fzf_complete.fish

# Helper function to parse build_config output
function _parse_build_config
  set -l type $argv[1]
  set -l preset_variant $argv[2]
  set -l prompt $argv[3]

  # Parse null-separated output
  set -l output (__fzf_complete_git_build_config $type $preset_variant $prompt | string split0)

  # First is source, second is transformer, rest are opts
  set -l source $output[1]
  set -l transformer $output[2]
  set -l opts $output[3..]

  # Return results
  echo "source:$source"
  if test -z "$transformer"
    echo "transformer:EMPTY"
  else
    echo "transformer:$transformer"
  end
  if contains -- --multi $opts
    echo "opts:has_multi"
  else
    echo "opts:no_multi"
  end
  if string match -q "*--prompt=*" -- $opts
    echo "opts:has_prompt"
  else
    echo "opts:no_prompt"
  end
end

# === Test status_file type ===
@test "status_file: source is status source" (
  set result (_parse_build_config status_file normal "Test> ")
  string match -q "source:*status*" -- $result
) $status -eq 0

@test "status_file: transformer is status_to_arg" (
  set result (_parse_build_config status_file normal "Test> ")
  string match -q "*transformer:__fzf_complete_git_status_to_arg*" -- $result
) $status -eq 0

@test "status_file: opts has prompt" (
  set result (_parse_build_config status_file normal "Test> ")
  string match -q "*opts:has_prompt*" -- $result
) $status -eq 0

# === Test branch type (singular - no --multi) ===
@test "branch: source is branch source" (
  set result (_parse_build_config branch normal "Test> ")
  string match -q "source:*for-each-ref*" -- $result
) $status -eq 0

@test "branch: transformer is ref_to_arg" (
  set result (_parse_build_config branch normal "Test> ")
  string match -q "*transformer:__fzf_complete_git_ref_to_arg*" -- $result
) $status -eq 0

@test "branch: opts does not have multi" (
  set result (_parse_build_config branch normal "Test> ")
  string match -q "*opts:no_multi*" -- $result
) $status -eq 0

# === Test branches type (plural - has --multi) ===
@test "branches: opts has multi" (
  set result (_parse_build_config branches normal "Test> ")
  string match -q "*opts:has_multi*" -- $result
) $status -eq 0

# === Test commit type ===
@test "commit: source is log source" (
  set result (_parse_build_config commit normal "Test> ")
  string match -q "source:*git log*" -- $result
) $status -eq 0

@test "commit: transformer is ref_to_arg" (
  set result (_parse_build_config commit normal "Test> ")
  string match -q "*transformer:__fzf_complete_git_ref_to_arg*" -- $result
) $status -eq 0

# === Test ls_file type ===
@test "ls_file: source is ls-files" (
  set result (_parse_build_config ls_file normal "Test> ")
  string match -q "source:*ls-files*" -- $result
) $status -eq 0

@test "ls_file: transformer is empty" (
  set result (_parse_build_config ls_file normal "Test> ")
  string match -q "*transformer:EMPTY*" -- $result
) $status -eq 0

# === Test tag type ===
@test "tag: source is tag source" (
  set result (_parse_build_config tag normal "Test> ")
  string match -q "source:*refs/tags*" -- $result
) $status -eq 0

@test "tag: transformer is ref_to_arg" (
  set result (_parse_build_config tag normal "Test> ")
  string match -q "*transformer:__fzf_complete_git_ref_to_arg*" -- $result
) $status -eq 0

# === Test stash type ===
@test "stash: source is stash source" (
  set result (_parse_build_config stash normal "Test> ")
  string match -q "source:*stash list*" -- $result
) $status -eq 0

@test "stash: transformer is stash_to_arg" (
  set result (_parse_build_config stash normal "Test> ")
  string match -q "*transformer:__fzf_complete_git_stash_to_arg*" -- $result
) $status -eq 0

# === Test branch with no_header preset_variant ===
@test "branch no_header: source is still branch source" (
  set result (_parse_build_config branch no_header "Test> ")
  string match -q "source:*for-each-ref*" -- $result
) $status -eq 0

# === Test commits (plural) ===
@test "commits: has multi option" (
  set result (_parse_build_config commits normal "Test> ")
  string match -q "*opts:has_multi*" -- $result
) $status -eq 0

# === Test tags (plural) ===
@test "tags: has multi option" (
  set result (_parse_build_config tags normal "Test> ")
  string match -q "*opts:has_multi*" -- $result
) $status -eq 0

# === Test stashes (plural) ===
@test "stashes: has multi option" (
  set result (_parse_build_config stashes normal "Test> ")
  string match -q "*opts:has_multi*" -- $result
) $status -eq 0
