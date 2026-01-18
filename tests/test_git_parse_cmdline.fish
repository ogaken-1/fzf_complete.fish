# Test __fzf_complete_git_parse_cmdline

source (status dirname)/../functions/__fzf_complete_rule_git.fish

# ============================================================
# 1. git add
# ============================================================
@test "git add" (__fzf_complete_git_parse_cmdline "git add ") = "status_file\tnormal\tGit Add Files> "
@test "git add with options" (__fzf_complete_git_parse_cmdline "git add -v ") = "status_file\tnormal\tGit Add Files> "
@test "git add with file" (__fzf_complete_git_parse_cmdline "git add foo.txt ") = "status_file\tnormal\tGit Add Files> "

# ============================================================
# 2. git diff files (with --)
# ============================================================
@test "git diff with -- only" (__fzf_complete_git_parse_cmdline "git diff -- ") = "status_file\tnormal\tGit Diff Files> "
@test "git diff with options and --" (__fzf_complete_git_parse_cmdline "git diff --staged -- ") = "status_file\tnormal\tGit Diff Files> "

# ============================================================
# 3. git diff branch files (with -- and non-option arg before, or --no-index)
# ============================================================
@test "git diff with branch and --" (__fzf_complete_git_parse_cmdline "git diff main -- ") = "ls_file\tnormal\tGit Diff Branch Files> "
@test "git diff with --no-index" (__fzf_complete_git_parse_cmdline "git diff --no-index ") = "ls_file\tnormal\tGit Diff Branch Files> "
@test "git diff -- with --no-index" (__fzf_complete_git_parse_cmdline "git diff --no-index -- ") = "ls_file\tnormal\tGit Diff Branch Files> "
@test "git diff -- with --no-index and file" (__fzf_complete_git_parse_cmdline "git diff --no-index file1 ") = "ls_file\tnormal\tGit Diff Branch Files> "

# ============================================================
# 4. git diff (basic - branches completion)
# ============================================================
@test "git diff" (__fzf_complete_git_parse_cmdline "git diff ") = "branches\tnormal\tGit Diff> "
@test "git diff with options" (__fzf_complete_git_parse_cmdline "git diff --staged ") = "branches\tnormal\tGit Diff> "

# ============================================================
# 5. git commit -c/-C/--fixup/--squash
# ============================================================
@test "git commit -c" (__fzf_complete_git_parse_cmdline "git commit -c ") = "commit\tlog_simple\tGit Commit> "
@test "git commit -C" (__fzf_complete_git_parse_cmdline "git commit -C ") = "commit\tlog_simple\tGit Commit> "
@test "git commit --fixup=" (__fzf_complete_git_parse_cmdline "git commit --fixup=") = "commit\tlog_simple\tGit Commit> "
@test "git commit --fixup " (__fzf_complete_git_parse_cmdline "git commit --fixup ") = "commit\tlog_simple\tGit Commit> "
@test "git commit --fixup=amend:" (__fzf_complete_git_parse_cmdline "git commit --fixup=amend:") = "commit\tlog_simple\tGit Commit> "
@test "git commit --fixup=reword:" (__fzf_complete_git_parse_cmdline "git commit --fixup=reword:") = "commit\tlog_simple\tGit Commit> "
@test "git commit --squash=" (__fzf_complete_git_parse_cmdline "git commit --squash=") = "commit\tlog_simple\tGit Commit> "
@test "git commit --squash " (__fzf_complete_git_parse_cmdline "git commit --squash ") = "commit\tlog_simple\tGit Commit> "
@test "git commit --reuse-message=" (__fzf_complete_git_parse_cmdline "git commit --reuse-message=") = "commit\tlog_simple\tGit Commit> "
@test "git commit --reedit-message=" (__fzf_complete_git_parse_cmdline "git commit --reedit-message=") = "commit\tlog_simple\tGit Commit> "
@test "git commit -c with options" (__fzf_complete_git_parse_cmdline "git commit -v -c ") = "commit\tlog_simple\tGit Commit> "

# git commit -c/-C/--fixup/--squash with -- falls through to commit files
@test "git commit -c with -- falls to commit files" (__fzf_complete_git_parse_cmdline "git commit -c -- ") = "status_file\tnormal\tGit Commit Files> "

# ============================================================
# 6. git commit files
# ============================================================
@test "git commit with file" (__fzf_complete_git_parse_cmdline "git commit foo.txt ") = "status_file\tnormal\tGit Commit Files> "
@test "git commit with options and space" (__fzf_complete_git_parse_cmdline "git commit -v ") = "status_file\tnormal\tGit Commit Files> "
@test "git commit with --amend" (__fzf_complete_git_parse_cmdline "git commit --amend ") = "status_file\tnormal\tGit Commit Files> "

# git commit files exclusions
@test "git commit -m should not match" (not __fzf_complete_git_parse_cmdline "git commit -m ") $status -eq 0
@test "git commit -F should not match" (not __fzf_complete_git_parse_cmdline "git commit -F ") $status -eq 0
@test "git commit --author should not match" (not __fzf_complete_git_parse_cmdline "git commit --author ") $status -eq 0
@test "git commit --date should not match" (not __fzf_complete_git_parse_cmdline "git commit --date ") $status -eq 0
@test "git commit --template should not match" (not __fzf_complete_git_parse_cmdline "git commit --template ") $status -eq 0
@test "git commit --trailer should not match" (not __fzf_complete_git_parse_cmdline "git commit --trailer ") $status -eq 0

# ============================================================
# 7. git checkout branch files
# ============================================================
@test "git checkout branch files" (__fzf_complete_git_parse_cmdline "git checkout main ") = "ls_file\tnormal\tGit Checkout Branch Files> "
@test "git checkout branch files with --" (__fzf_complete_git_parse_cmdline "git checkout main -- ") = "ls_file\tnormal\tGit Checkout Branch Files> "

# git checkout branch files should not trigger when preceded by these options
@test "git checkout -b branch should not be checkout branch files" (__fzf_complete_git_parse_cmdline "git checkout -b main ") = "branch\tno_header\tGit Checkout> "
@test "git checkout -B branch should not be checkout branch files" (__fzf_complete_git_parse_cmdline "git checkout -B main ") = "branch\tno_header\tGit Checkout> "
@test "git checkout --orphan branch should not be checkout branch files" (__fzf_complete_git_parse_cmdline "git checkout --orphan main ") = "branch\tno_header\tGit Checkout> "
@test "git checkout --track branch should not be checkout branch files" (__fzf_complete_git_parse_cmdline "git checkout --track main ") = "branch\tno_header\tGit Checkout> "

# ============================================================
# 8. git checkout (branch completion)
# ============================================================
@test "git checkout" (__fzf_complete_git_parse_cmdline "git checkout ") = "branch\tno_header\tGit Checkout> "
@test "git checkout with -b" (__fzf_complete_git_parse_cmdline "git checkout -b ") = "branch\tno_header\tGit Checkout> "
@test "git checkout with --track=" (__fzf_complete_git_parse_cmdline "git checkout --track=") = "branch\tno_header\tGit Checkout> "

# git checkout exclusions
@test "git checkout with -- should not match branch" (__fzf_complete_git_parse_cmdline "git checkout -- ") = "status_file\tnormal\tGit Checkout Files> "
@test "git checkout --conflict should not match" (not __fzf_complete_git_parse_cmdline "git checkout --conflict ") $status -eq 0
@test "git checkout --pathspec-from-file should not match" (not __fzf_complete_git_parse_cmdline "git checkout --pathspec-from-file ") $status -eq 0

# ============================================================
# 9. git checkout files
# ============================================================
@test "git checkout files with --" (__fzf_complete_git_parse_cmdline "git checkout -- ") = "status_file\tnormal\tGit Checkout Files> "

# ============================================================
# 10. git branch -d/-D
# ============================================================
@test "git branch -d" (__fzf_complete_git_parse_cmdline "git branch -d ") = "branches\tnormal\tGit Delete Branch> "
@test "git branch -D" (__fzf_complete_git_parse_cmdline "git branch -D ") = "branches\tnormal\tGit Delete Branch> "
@test "git branch -d with branch" (__fzf_complete_git_parse_cmdline "git branch -d feature ") = "branches\tnormal\tGit Delete Branch> "

# ============================================================
# 11. git reset branch files
# ============================================================
@test "git reset with branch" (__fzf_complete_git_parse_cmdline "git reset HEAD ") = "ls_file\tnormal\tGit Reset Branch Files> "
@test "git reset with branch and file" (__fzf_complete_git_parse_cmdline "git reset HEAD file.txt ") = "ls_file\tnormal\tGit Reset Branch Files> "

# ============================================================
# 12. git reset (commit completion)
# ============================================================
@test "git reset" (__fzf_complete_git_parse_cmdline "git reset ") = "commit\tnormal\tGit Reset> "
@test "git reset with --soft" (__fzf_complete_git_parse_cmdline "git reset --soft ") = "commit\tnormal\tGit Reset> "
@test "git reset with --hard" (__fzf_complete_git_parse_cmdline "git reset --hard ") = "commit\tnormal\tGit Reset> "
@test "git reset with --mixed" (__fzf_complete_git_parse_cmdline "git reset --mixed ") = "commit\tnormal\tGit Reset> "

# git reset exclusions
@test "git reset --pathspec-from-file should not match" (not __fzf_complete_git_parse_cmdline "git reset --pathspec-from-file ") $status -eq 0

# ============================================================
# 13. git reset files (fallback with --)
# ============================================================
@test "git reset files with --" (__fzf_complete_git_parse_cmdline "git reset -- ") = "status_file\tnormal\tGit Reset Files> "
@test "git reset files with -- and options" (__fzf_complete_git_parse_cmdline "git reset --soft -- ") = "status_file\tnormal\tGit Reset Files> "

# ============================================================
# 14. git switch
# ============================================================
@test "git switch" (__fzf_complete_git_parse_cmdline "git switch ") = "branch\tno_header\tGit Switch> "
@test "git switch with -c" (__fzf_complete_git_parse_cmdline "git switch -c ") = "branch\tno_header\tGit Switch> "
@test "git switch with --create" (__fzf_complete_git_parse_cmdline "git switch --create ") = "branch\tno_header\tGit Switch> "

# ============================================================
# 15. git restore --source
# ============================================================
@test "git restore -s" (__fzf_complete_git_parse_cmdline "git restore -s ") = "branch\tnormal\tGit Restore Source> "
@test "git restore --source=" (__fzf_complete_git_parse_cmdline "git restore --source=") = "branch\tnormal\tGit Restore Source> "
@test "git restore --source " (__fzf_complete_git_parse_cmdline "git restore --source ") = "branch\tnormal\tGit Restore Source> "

# git restore -s with -- falls through to restore source files
@test "git restore -s with -- falls to restore files" (__fzf_complete_git_parse_cmdline "git restore -s -- ") = "ls_file\tnormal\tGit Restore Files> "

# ============================================================
# 16. git restore source files
# ============================================================
@test "git restore with source and file" (__fzf_complete_git_parse_cmdline "git restore -s HEAD ") = "ls_file\tnormal\tGit Restore Files> "
@test "git restore with --source=ref" (__fzf_complete_git_parse_cmdline "git restore --source=HEAD ") = "ls_file\tnormal\tGit Restore Files> "
@test "git restore with --source ref" (__fzf_complete_git_parse_cmdline "git restore --source HEAD ") = "ls_file\tnormal\tGit Restore Files> "

# ============================================================
# 17. git rebase branch (with branch argument)
# ============================================================
@test "git rebase with branch" (__fzf_complete_git_parse_cmdline "git rebase main ") = "branch\tnormal\tGit Rebase Branch> "
@test "git rebase with --onto and branch" (__fzf_complete_git_parse_cmdline "git rebase --onto main feature ") = "branch\tnormal\tGit Rebase Branch> "

# git rebase branch should not trigger when preceded by these options
@test "git rebase -x arg should not be rebase branch" (__fzf_complete_git_parse_cmdline "git rebase -x cmd ") = "commit\tnormal\tGit Rebase Branch> "
@test "git rebase --exec arg should not be rebase branch" (__fzf_complete_git_parse_cmdline "git rebase --exec cmd ") = "commit\tnormal\tGit Rebase Branch> "

# ============================================================
# 18. git rebase (commit completion)
# ============================================================
@test "git rebase" (__fzf_complete_git_parse_cmdline "git rebase ") = "commit\tnormal\tGit Rebase Branch> "
@test "git rebase with --onto=" (__fzf_complete_git_parse_cmdline "git rebase --onto=") = "commit\tnormal\tGit Rebase Branch> "
@test "git rebase with --onto " (__fzf_complete_git_parse_cmdline "git rebase --onto ") = "commit\tnormal\tGit Rebase Branch> "
@test "git rebase with -i" (__fzf_complete_git_parse_cmdline "git rebase -i ") = "commit\tnormal\tGit Rebase Branch> "

# git rebase exclusions
@test "git rebase -x should not match" (not __fzf_complete_git_parse_cmdline "git rebase -x ") $status -eq 0
@test "git rebase -s should not match" (not __fzf_complete_git_parse_cmdline "git rebase -s ") $status -eq 0
@test "git rebase -X should not match" (not __fzf_complete_git_parse_cmdline "git rebase -X ") $status -eq 0
@test "git rebase --exec should not match" (not __fzf_complete_git_parse_cmdline "git rebase --exec ") $status -eq 0
@test "git rebase --strategy should not match" (not __fzf_complete_git_parse_cmdline "git rebase --strategy ") $status -eq 0
@test "git rebase --strategy-option should not match" (not __fzf_complete_git_parse_cmdline "git rebase --strategy-option ") $status -eq 0

# ============================================================
# 19. git merge --into-name
# ============================================================
@test "git merge --into-name=" (__fzf_complete_git_parse_cmdline "git merge --into-name=") = "branch\tnormal\tGit Merge Branch> "
@test "git merge --into-name " (__fzf_complete_git_parse_cmdline "git merge --into-name ") = "branch\tnormal\tGit Merge Branch> "

# ============================================================
# 20. git merge
# ============================================================
@test "git merge" (__fzf_complete_git_parse_cmdline "git merge ") = "commit\tnormal\tGit Merge> "
@test "git merge with --no-ff" (__fzf_complete_git_parse_cmdline "git merge --no-ff ") = "commit\tnormal\tGit Merge> "

# git merge exclusions
@test "git merge -m should not match" (not __fzf_complete_git_parse_cmdline "git merge -m ") $status -eq 0
@test "git merge -F should not match" (not __fzf_complete_git_parse_cmdline "git merge -F ") $status -eq 0
@test "git merge -s should not match" (not __fzf_complete_git_parse_cmdline "git merge -s ") $status -eq 0
@test "git merge -X should not match" (not __fzf_complete_git_parse_cmdline "git merge -X ") $status -eq 0
@test "git merge --file should not match" (not __fzf_complete_git_parse_cmdline "git merge --file ") $status -eq 0
@test "git merge --strategy should not match" (not __fzf_complete_git_parse_cmdline "git merge --strategy ") $status -eq 0
@test "git merge --strategy-option should not match" (not __fzf_complete_git_parse_cmdline "git merge --strategy-option ") $status -eq 0

# ============================================================
# 21. git stash apply/drop/pop/show
# ============================================================
@test "git stash apply" (__fzf_complete_git_parse_cmdline "git stash apply ") = "stash\tnormal\tGit Stash> "
@test "git stash drop" (__fzf_complete_git_parse_cmdline "git stash drop ") = "stash\tnormal\tGit Stash> "
@test "git stash pop" (__fzf_complete_git_parse_cmdline "git stash pop ") = "stash\tnormal\tGit Stash> "
@test "git stash show" (__fzf_complete_git_parse_cmdline "git stash show ") = "stash\tnormal\tGit Stash> "
@test "git stash apply with options" (__fzf_complete_git_parse_cmdline "git stash apply --index ") = "stash\tnormal\tGit Stash> "

# ============================================================
# 22. git stash branch (with branch name and stash reference)
# ============================================================
@test "git stash branch with name" (__fzf_complete_git_parse_cmdline "git stash branch newbranch ") = "stash\tnormal\tGit Stash> "

# ============================================================
# 23. git stash branch (branch completion)
# ============================================================
@test "git stash branch" (__fzf_complete_git_parse_cmdline "git stash branch ") = "branch\tnormal\tGit Stash Branch> "

# ============================================================
# 24. git stash push files
# ============================================================
@test "git stash push" (__fzf_complete_git_parse_cmdline "git stash push ") = "status_file\tnormal\tGit Stash Push Files> "
@test "git stash push with -m" (__fzf_complete_git_parse_cmdline "git stash push -m msg ") = "status_file\tnormal\tGit Stash Push Files> "

# ============================================================
# 25. git log file (with --)
# ============================================================
@test "git log with --" (__fzf_complete_git_parse_cmdline "git log -- ") = "ls_file\tnormal\tGit Log File> "
@test "git log with branch and --" (__fzf_complete_git_parse_cmdline "git log main -- ") = "ls_file\tnormal\tGit Log File> "

# ============================================================
# 26. git log (branch completion)
# ============================================================
@test "git log" (__fzf_complete_git_parse_cmdline "git log ") = "branch\tnormal\tGit Log> "
@test "git log with --oneline" (__fzf_complete_git_parse_cmdline "git log --oneline ") = "branch\tnormal\tGit Log> "

# git log exclusions
@test "git log --skip should not match" (not __fzf_complete_git_parse_cmdline "git log --skip ") $status -eq 0
@test "git log --since should not match" (not __fzf_complete_git_parse_cmdline "git log --since ") $status -eq 0
@test "git log --after should not match" (not __fzf_complete_git_parse_cmdline "git log --after ") $status -eq 0
@test "git log --until should not match" (not __fzf_complete_git_parse_cmdline "git log --until ") $status -eq 0
@test "git log --before should not match" (not __fzf_complete_git_parse_cmdline "git log --before ") $status -eq 0
@test "git log --author should not match" (not __fzf_complete_git_parse_cmdline "git log --author ") $status -eq 0
@test "git log --committer should not match" (not __fzf_complete_git_parse_cmdline "git log --committer ") $status -eq 0
@test "git log --date should not match" (not __fzf_complete_git_parse_cmdline "git log --date ") $status -eq 0
@test "git log --branches should not match" (not __fzf_complete_git_parse_cmdline "git log --branches ") $status -eq 0
@test "git log --tags should not match" (not __fzf_complete_git_parse_cmdline "git log --tags ") $status -eq 0
@test "git log --remotes should not match" (not __fzf_complete_git_parse_cmdline "git log --remotes ") $status -eq 0
@test "git log --glob should not match" (not __fzf_complete_git_parse_cmdline "git log --glob ") $status -eq 0
@test "git log --exclude should not match" (not __fzf_complete_git_parse_cmdline "git log --exclude ") $status -eq 0
@test "git log --pretty should not match" (not __fzf_complete_git_parse_cmdline "git log --pretty ") $status -eq 0
@test "git log --format should not match" (not __fzf_complete_git_parse_cmdline "git log --format ") $status -eq 0
@test "git log --grep should not match" (not __fzf_complete_git_parse_cmdline "git log --grep ") $status -eq 0
@test "git log --grep-reflog should not match" (not __fzf_complete_git_parse_cmdline "git log --grep-reflog ") $status -eq 0
@test "git log --min-parents should not match" (not __fzf_complete_git_parse_cmdline "git log --min-parents ") $status -eq 0
@test "git log --max-parents should not match" (not __fzf_complete_git_parse_cmdline "git log --max-parents ") $status -eq 0

# ============================================================
# 27. git tag list commit
# ============================================================
@test "git tag -l --contains" (__fzf_complete_git_parse_cmdline "git tag -l --contains ") = "commit\tnormal\tGit Tag List Commit> "
@test "git tag --list --no-contains" (__fzf_complete_git_parse_cmdline "git tag --list --no-contains ") = "commit\tnormal\tGit Tag List Commit> "
@test "git tag -l --merged" (__fzf_complete_git_parse_cmdline "git tag -l --merged ") = "commit\tnormal\tGit Tag List Commit> "
@test "git tag --list --no-merged" (__fzf_complete_git_parse_cmdline "git tag --list --no-merged ") = "commit\tnormal\tGit Tag List Commit> "
@test "git tag -l --points-at" (__fzf_complete_git_parse_cmdline "git tag -l --points-at ") = "commit\tnormal\tGit Tag List Commit> "

# ============================================================
# 28. git tag delete
# ============================================================
@test "git tag -d" (__fzf_complete_git_parse_cmdline "git tag -d ") = "tag\tnormal\tGit Tag Delete> "
@test "git tag --delete" (__fzf_complete_git_parse_cmdline "git tag --delete ") = "tag\tnormal\tGit Tag Delete> "
@test "git tag -d with tag" (__fzf_complete_git_parse_cmdline "git tag -d v1.0 ") = "tag\tnormal\tGit Tag Delete> "

# ============================================================
# 29. git tag (basic)
# ============================================================
@test "git tag" (__fzf_complete_git_parse_cmdline "git tag ") = "tag\tnormal\tGit Tag> "
@test "git tag with -a" (__fzf_complete_git_parse_cmdline "git tag -a ") = "tag\tnormal\tGit Tag> "

# git tag exclusions
@test "git tag -u should not match" (not __fzf_complete_git_parse_cmdline "git tag -u ") $status -eq 0
@test "git tag -m should not match" (not __fzf_complete_git_parse_cmdline "git tag -m ") $status -eq 0
@test "git tag -F should not match" (not __fzf_complete_git_parse_cmdline "git tag -F ") $status -eq 0
@test "git tag --local-user should not match" (not __fzf_complete_git_parse_cmdline "git tag --local-user ") $status -eq 0
@test "git tag --format should not match" (not __fzf_complete_git_parse_cmdline "git tag --format ") $status -eq 0

# ============================================================
# 30. git mv files
# ============================================================
@test "git mv" (__fzf_complete_git_parse_cmdline "git mv ") = "ls_file\tnormal\tGit Mv Files> "
@test "git mv with file" (__fzf_complete_git_parse_cmdline "git mv file.txt ") = "ls_file\tnormal\tGit Mv Files> "

# ============================================================
# 31. git rm files
# ============================================================
@test "git rm" (__fzf_complete_git_parse_cmdline "git rm ") = "ls_file\tnormal\tGit Rm Files> "
@test "git rm with --cached" (__fzf_complete_git_parse_cmdline "git rm --cached ") = "ls_file\tnormal\tGit Rm Files> "

# ============================================================
# 32. git show
# ============================================================
@test "git show" (__fzf_complete_git_parse_cmdline "git show ") = "commit\tnormal\tGit Show> "
@test "git show with --stat" (__fzf_complete_git_parse_cmdline "git show --stat ") = "commit\tnormal\tGit Show> "

# git show exclusions
@test "git show --pretty should not match" (not __fzf_complete_git_parse_cmdline "git show --pretty ") $status -eq 0
@test "git show --format should not match" (not __fzf_complete_git_parse_cmdline "git show --format ") $status -eq 0

# ============================================================
# 33. git revert
# ============================================================
@test "git revert" (__fzf_complete_git_parse_cmdline "git revert ") = "commit\tlog_simple\tGit Revert> "
@test "git revert with -n" (__fzf_complete_git_parse_cmdline "git revert -n ") = "commit\tlog_simple\tGit Revert> "
@test "git revert with --no-commit" (__fzf_complete_git_parse_cmdline "git revert --no-commit ") = "commit\tlog_simple\tGit Revert> "

# ============================================================
# No match cases
# ============================================================
@test "unknown command returns 1" (not __fzf_complete_git_parse_cmdline "ls ") $status -eq 0
@test "git without space returns 1" (not __fzf_complete_git_parse_cmdline "git") $status -eq 0
@test "git status returns 1" (not __fzf_complete_git_parse_cmdline "git status ") $status -eq 0
@test "git push returns 1" (not __fzf_complete_git_parse_cmdline "git push ") $status -eq 0
@test "git pull returns 1" (not __fzf_complete_git_parse_cmdline "git pull ") $status -eq 0
@test "git fetch returns 1" (not __fzf_complete_git_parse_cmdline "git fetch ") $status -eq 0
@test "git clone returns 1" (not __fzf_complete_git_parse_cmdline "git clone ") $status -eq 0
