# Test __fzf_complete_git_parse_cmdline

source (status dirname)/../functions/__fzf_complete_rule_git.fish

# ============================================================
# 1. git add
# ============================================================
@test "git add" (__fzf_complete_git_parse_cmdline "git add ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Add Files> ')
@test "git add with options" (__fzf_complete_git_parse_cmdline "git add -v ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Add Files> ')
@test "git add with file" (__fzf_complete_git_parse_cmdline "git add foo.txt ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Add Files> ')

# ============================================================
# 2. git diff files (with --)
# ============================================================
@test "git diff with -- only" (__fzf_complete_git_parse_cmdline "git diff -- ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Diff Files> ')
@test "git diff with options and --" (__fzf_complete_git_parse_cmdline "git diff --staged -- ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Diff Files> ')

# ============================================================
# 3. git diff branch files (with -- and non-option arg before, or --no-index)
# ============================================================
@test "git diff with branch and --" (__fzf_complete_git_parse_cmdline "git diff main -- ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Diff Branch Files> ')
@test "git diff with --no-index" (__fzf_complete_git_parse_cmdline "git diff --no-index ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Diff Branch Files> ')
@test "git diff -- with --no-index" (__fzf_complete_git_parse_cmdline "git diff --no-index -- ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Diff Branch Files> ')
@test "git diff -- with --no-index and file" (__fzf_complete_git_parse_cmdline "git diff --no-index file1 ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Diff Branch Files> ')

# ============================================================
# 4. git diff (basic - branches completion)
# ============================================================
@test "git diff" (__fzf_complete_git_parse_cmdline "git diff ") = (printf '%s\t%s\t%s\t%s\n' branch true ref_full 'Git Diff> ')
@test "git diff with options" (__fzf_complete_git_parse_cmdline "git diff --staged ") = (printf '%s\t%s\t%s\t%s\n' branch true ref_full 'Git Diff> ')

# ============================================================
# 5. git commit -c/-C/--fixup/--squash
# ============================================================
@test "git commit -c" (__fzf_complete_git_parse_cmdline "git commit -c ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_simple 'Git Commit> ')
@test "git commit -C" (__fzf_complete_git_parse_cmdline "git commit -C ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_simple 'Git Commit> ')
@test "git commit --fixup=" (__fzf_complete_git_parse_cmdline "git commit --fixup=") = (printf '%s\t%s\t%s\t%s\n' commit false ref_simple 'Git Commit> ')
@test "git commit --fixup " (__fzf_complete_git_parse_cmdline "git commit --fixup ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_simple 'Git Commit> ')
@test "git commit --fixup=amend:" (__fzf_complete_git_parse_cmdline "git commit --fixup=amend:") = (printf '%s\t%s\t%s\t%s\n' commit false ref_simple 'Git Commit> ')
@test "git commit --fixup=reword:" (__fzf_complete_git_parse_cmdline "git commit --fixup=reword:") = (printf '%s\t%s\t%s\t%s\n' commit false ref_simple 'Git Commit> ')
@test "git commit --squash=" (__fzf_complete_git_parse_cmdline "git commit --squash=") = (printf '%s\t%s\t%s\t%s\n' commit false ref_simple 'Git Commit> ')
@test "git commit --squash " (__fzf_complete_git_parse_cmdline "git commit --squash ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_simple 'Git Commit> ')
@test "git commit --reuse-message=" (__fzf_complete_git_parse_cmdline "git commit --reuse-message=") = (printf '%s\t%s\t%s\t%s\n' commit false ref_simple 'Git Commit> ')
@test "git commit --reedit-message=" (__fzf_complete_git_parse_cmdline "git commit --reedit-message=") = (printf '%s\t%s\t%s\t%s\n' commit false ref_simple 'Git Commit> ')
@test "git commit -c with options" (__fzf_complete_git_parse_cmdline "git commit -v -c ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_simple 'Git Commit> ')

# git commit -c/-C/--fixup/--squash with -- falls through to commit files
@test "git commit -c with -- falls to commit files" (__fzf_complete_git_parse_cmdline "git commit -c -- ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Commit Files> ')

# ============================================================
# 6. git commit files
# ============================================================
@test "git commit with file" (__fzf_complete_git_parse_cmdline "git commit foo.txt ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Commit Files> ')
@test "git commit with options and space" (__fzf_complete_git_parse_cmdline "git commit -v ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Commit Files> ')
@test "git commit with --amend" (__fzf_complete_git_parse_cmdline "git commit --amend ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Commit Files> ')

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
@test "git checkout branch files" (__fzf_complete_git_parse_cmdline "git checkout main ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Checkout Branch Files> ')
@test "git checkout branch files with --" (__fzf_complete_git_parse_cmdline "git checkout main -- ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Checkout Branch Files> ')

# git checkout branch files should not trigger when preceded by these options
@test "git checkout -b branch should not be checkout branch files" (__fzf_complete_git_parse_cmdline "git checkout -b main ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_simple 'Git Checkout> ')
@test "git checkout -B branch should not be checkout branch files" (__fzf_complete_git_parse_cmdline "git checkout -B main ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_simple 'Git Checkout> ')
@test "git checkout --orphan branch should not be checkout branch files" (__fzf_complete_git_parse_cmdline "git checkout --orphan main ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_simple 'Git Checkout> ')
@test "git checkout --track branch should not be checkout branch files" (__fzf_complete_git_parse_cmdline "git checkout --track main ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_simple 'Git Checkout> ')

# ============================================================
# 8. git checkout (branch completion)
# ============================================================
@test "git checkout" (__fzf_complete_git_parse_cmdline "git checkout ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_simple 'Git Checkout> ')
@test "git checkout with -b" (__fzf_complete_git_parse_cmdline "git checkout -b ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_simple 'Git Checkout> ')
@test "git checkout with --track=" (__fzf_complete_git_parse_cmdline "git checkout --track=") = (printf '%s\t%s\t%s\t%s\n' branch false ref_simple 'Git Checkout> ')

# git checkout exclusions
@test "git checkout with -- should not match branch" (__fzf_complete_git_parse_cmdline "git checkout -- ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Checkout Files> ')
@test "git checkout --conflict should not match" (not __fzf_complete_git_parse_cmdline "git checkout --conflict ") $status -eq 0
@test "git checkout --pathspec-from-file should not match" (not __fzf_complete_git_parse_cmdline "git checkout --pathspec-from-file ") $status -eq 0

# ============================================================
# 9. git checkout files
# ============================================================
@test "git checkout files with --" (__fzf_complete_git_parse_cmdline "git checkout -- ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Checkout Files> ')

# ============================================================
# 10. git branch -d/-D
# ============================================================
@test "git branch -d" (__fzf_complete_git_parse_cmdline "git branch -d ") = (printf '%s\t%s\t%s\t%s\n' branch true ref_simple 'Git Delete Branch> ')
@test "git branch -D" (__fzf_complete_git_parse_cmdline "git branch -D ") = (printf '%s\t%s\t%s\t%s\n' branch true ref_simple 'Git Delete Branch> ')
@test "git branch -d with branch" (__fzf_complete_git_parse_cmdline "git branch -d feature ") = (printf '%s\t%s\t%s\t%s\n' branch true ref_simple 'Git Delete Branch> ')

# ============================================================
# 11. git reset branch files
# ============================================================
@test "git reset with branch" (__fzf_complete_git_parse_cmdline "git reset HEAD ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Reset Branch Files> ')
@test "git reset with branch and file" (__fzf_complete_git_parse_cmdline "git reset HEAD file.txt ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Reset Branch Files> ')

# ============================================================
# 12. git reset (commit completion)
# ============================================================
@test "git reset" (__fzf_complete_git_parse_cmdline "git reset ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Reset> ')
@test "git reset with --soft" (__fzf_complete_git_parse_cmdline "git reset --soft ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Reset> ')
@test "git reset with --hard" (__fzf_complete_git_parse_cmdline "git reset --hard ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Reset> ')
@test "git reset with --mixed" (__fzf_complete_git_parse_cmdline "git reset --mixed ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Reset> ')

# git reset exclusions
@test "git reset --pathspec-from-file should not match" (not __fzf_complete_git_parse_cmdline "git reset --pathspec-from-file ") $status -eq 0

# ============================================================
# 13. git reset files (fallback with --)
# ============================================================
@test "git reset files with --" (__fzf_complete_git_parse_cmdline "git reset -- ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Reset Files> ')
@test "git reset files with -- and options" (__fzf_complete_git_parse_cmdline "git reset --soft -- ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Reset Files> ')

# ============================================================
# 14. git switch
# ============================================================
@test "git switch" (__fzf_complete_git_parse_cmdline "git switch ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_simple 'Git Switch> ')
@test "git switch with -c" (__fzf_complete_git_parse_cmdline "git switch -c ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_simple 'Git Switch> ')
@test "git switch with --create" (__fzf_complete_git_parse_cmdline "git switch --create ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_simple 'Git Switch> ')

# ============================================================
# 15. git restore --source
# ============================================================
@test "git restore -s" (__fzf_complete_git_parse_cmdline "git restore -s ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_full 'Git Restore Source> ')
@test "git restore --source=" (__fzf_complete_git_parse_cmdline "git restore --source=") = (printf '%s\t%s\t%s\t%s\n' branch false ref_full 'Git Restore Source> ')
@test "git restore --source " (__fzf_complete_git_parse_cmdline "git restore --source ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_full 'Git Restore Source> ')

# git restore -s with -- falls through to restore source files
@test "git restore -s with -- falls to restore files" (__fzf_complete_git_parse_cmdline "git restore -s -- ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Restore Files> ')

# ============================================================
# 16. git restore source files
# ============================================================
@test "git restore with source and file" (__fzf_complete_git_parse_cmdline "git restore -s HEAD ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Restore Files> ')
@test "git restore with --source=ref" (__fzf_complete_git_parse_cmdline "git restore --source=HEAD ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Restore Files> ')
@test "git restore with --source ref" (__fzf_complete_git_parse_cmdline "git restore --source HEAD ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Restore Files> ')

# ============================================================
# 16.5 git restore --staged (no source) - staged file completion
# ============================================================
@test "git restore --staged" (__fzf_complete_git_parse_cmdline "git restore --staged ") = (printf '%s\t%s\t%s\t%s\n' staged_file true file 'Git Restore Staged> ')
@test "git restore -S" (__fzf_complete_git_parse_cmdline "git restore -S ") = (printf '%s\t%s\t%s\t%s\n' staged_file true file 'Git Restore Staged> ')
@test "git restore --staged with options" (__fzf_complete_git_parse_cmdline "git restore --staged --quiet ") = (printf '%s\t%s\t%s\t%s\n' staged_file true file 'Git Restore Staged> ')
@test "git restore -S with file" (__fzf_complete_git_parse_cmdline "git restore -S file.txt ") = (printf '%s\t%s\t%s\t%s\n' staged_file true file 'Git Restore Staged> ')

# ============================================================
# 16.6 git restore (no source) - worktree file completion
# ============================================================
@test "git restore" (__fzf_complete_git_parse_cmdline "git restore ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Restore> ')
@test "git restore --worktree" (__fzf_complete_git_parse_cmdline "git restore --worktree ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Restore> ')
@test "git restore -W" (__fzf_complete_git_parse_cmdline "git restore -W ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Restore> ')
@test "git restore --staged --worktree" (__fzf_complete_git_parse_cmdline "git restore --staged --worktree ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Restore> ')
@test "git restore -S -W" (__fzf_complete_git_parse_cmdline "git restore -S -W ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Restore> ')
@test "git restore -SW" (__fzf_complete_git_parse_cmdline "git restore -SW ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Restore> ')
@test "git restore -WS" (__fzf_complete_git_parse_cmdline "git restore -WS ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Restore> ')
@test "git restore with file" (__fzf_complete_git_parse_cmdline "git restore file.txt ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Restore> ')

# git restore exclusions
@test "git restore --pathspec-from-file should not match" (not __fzf_complete_git_parse_cmdline "git restore --pathspec-from-file ") $status -eq 0

# ============================================================
# 17. git rebase branch (with branch argument)
# ============================================================
@test "git rebase with branch" (__fzf_complete_git_parse_cmdline "git rebase main ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_full 'Git Rebase Branch> ')
@test "git rebase with --onto and branch" (__fzf_complete_git_parse_cmdline "git rebase --onto main feature ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_full 'Git Rebase Branch> ')

# git rebase branch should not trigger when preceded by these options
@test "git rebase -x arg should not be rebase branch" (__fzf_complete_git_parse_cmdline "git rebase -x cmd ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Rebase> ')
@test "git rebase --exec arg should not be rebase branch" (__fzf_complete_git_parse_cmdline "git rebase --exec cmd ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Rebase> ')

# ============================================================
# 18. git rebase (commit completion)
# ============================================================
@test "git rebase" (__fzf_complete_git_parse_cmdline "git rebase ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Rebase> ')
@test "git rebase with --onto=" (__fzf_complete_git_parse_cmdline "git rebase --onto=") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Rebase> ')
@test "git rebase with --onto " (__fzf_complete_git_parse_cmdline "git rebase --onto ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Rebase> ')
@test "git rebase with -i" (__fzf_complete_git_parse_cmdline "git rebase -i ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Rebase> ')

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
@test "git merge --into-name=" (__fzf_complete_git_parse_cmdline "git merge --into-name=") = (printf '%s\t%s\t%s\t%s\n' branch false ref_full 'Git Merge Branch> ')
@test "git merge --into-name " (__fzf_complete_git_parse_cmdline "git merge --into-name ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_full 'Git Merge Branch> ')

# ============================================================
# 20. git merge
# ============================================================
@test "git merge" (__fzf_complete_git_parse_cmdline "git merge ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Merge> ')
@test "git merge with --no-ff" (__fzf_complete_git_parse_cmdline "git merge --no-ff ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Merge> ')

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
@test "git stash apply" (__fzf_complete_git_parse_cmdline "git stash apply ") = (printf '%s\t%s\t%s\t%s\n' stash false stash 'Git Stash> ')
@test "git stash drop" (__fzf_complete_git_parse_cmdline "git stash drop ") = (printf '%s\t%s\t%s\t%s\n' stash false stash 'Git Stash> ')
@test "git stash pop" (__fzf_complete_git_parse_cmdline "git stash pop ") = (printf '%s\t%s\t%s\t%s\n' stash false stash 'Git Stash> ')
@test "git stash show" (__fzf_complete_git_parse_cmdline "git stash show ") = (printf '%s\t%s\t%s\t%s\n' stash false stash 'Git Stash> ')
@test "git stash apply with options" (__fzf_complete_git_parse_cmdline "git stash apply --index ") = (printf '%s\t%s\t%s\t%s\n' stash false stash 'Git Stash> ')

# ============================================================
# 22. git stash branch (with branch name and stash reference)
# ============================================================
@test "git stash branch with name" (__fzf_complete_git_parse_cmdline "git stash branch newbranch ") = (printf '%s\t%s\t%s\t%s\n' stash false stash 'Git Stash> ')

# ============================================================
# 23. git stash branch (branch completion)
# ============================================================
@test "git stash branch" (__fzf_complete_git_parse_cmdline "git stash branch ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_full 'Git Stash Branch> ')

# ============================================================
# 24. git stash push files
# ============================================================
@test "git stash push" (__fzf_complete_git_parse_cmdline "git stash push ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Stash Push Files> ')
@test "git stash push with -m" (__fzf_complete_git_parse_cmdline "git stash push -m msg ") = (printf '%s\t%s\t%s\t%s\n' status_file true file 'Git Stash Push Files> ')

# ============================================================
# 25. git log file (with --)
# ============================================================
@test "git log with --" (__fzf_complete_git_parse_cmdline "git log -- ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Log File> ')
@test "git log with branch and --" (__fzf_complete_git_parse_cmdline "git log main -- ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Log File> ')

# ============================================================
# 26. git log (branch completion)
# ============================================================
@test "git log" (__fzf_complete_git_parse_cmdline "git log ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_full 'Git Log> ')
@test "git log with --oneline" (__fzf_complete_git_parse_cmdline "git log --oneline ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_full 'Git Log> ')

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
@test "git tag -l --contains" (__fzf_complete_git_parse_cmdline "git tag -l --contains ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Tag List Commit> ')
@test "git tag --list --no-contains" (__fzf_complete_git_parse_cmdline "git tag --list --no-contains ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Tag List Commit> ')
@test "git tag -l --merged" (__fzf_complete_git_parse_cmdline "git tag -l --merged ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Tag List Commit> ')
@test "git tag --list --no-merged" (__fzf_complete_git_parse_cmdline "git tag --list --no-merged ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Tag List Commit> ')
@test "git tag -l --points-at" (__fzf_complete_git_parse_cmdline "git tag -l --points-at ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Tag List Commit> ')

# ============================================================
# 28. git tag delete
# ============================================================
@test "git tag -d" (__fzf_complete_git_parse_cmdline "git tag -d ") = (printf '%s\t%s\t%s\t%s\n' tag false ref_simple 'Git Tag Delete> ')
@test "git tag --delete" (__fzf_complete_git_parse_cmdline "git tag --delete ") = (printf '%s\t%s\t%s\t%s\n' tag false ref_simple 'Git Tag Delete> ')
@test "git tag -d with tag" (__fzf_complete_git_parse_cmdline "git tag -d v1.0 ") = (printf '%s\t%s\t%s\t%s\n' tag false ref_simple 'Git Tag Delete> ')

# ============================================================
# 29. git tag (basic)
# ============================================================
@test "git tag" (__fzf_complete_git_parse_cmdline "git tag ") = (printf '%s\t%s\t%s\t%s\n' tag false ref_simple 'Git Tag> ')
@test "git tag with -a" (__fzf_complete_git_parse_cmdline "git tag -a ") = (printf '%s\t%s\t%s\t%s\n' tag false ref_simple 'Git Tag> ')

# git tag exclusions
@test "git tag -u should not match" (not __fzf_complete_git_parse_cmdline "git tag -u ") $status -eq 0
@test "git tag -m should not match" (not __fzf_complete_git_parse_cmdline "git tag -m ") $status -eq 0
@test "git tag -F should not match" (not __fzf_complete_git_parse_cmdline "git tag -F ") $status -eq 0
@test "git tag --local-user should not match" (not __fzf_complete_git_parse_cmdline "git tag --local-user ") $status -eq 0
@test "git tag --format should not match" (not __fzf_complete_git_parse_cmdline "git tag --format ") $status -eq 0

# ============================================================
# 30. git mv files
# ============================================================
@test "git mv" (__fzf_complete_git_parse_cmdline "git mv ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Mv Files> ')
@test "git mv with file" (__fzf_complete_git_parse_cmdline "git mv file.txt ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Mv Files> ')

# ============================================================
# 31. git rm files
# ============================================================
@test "git rm" (__fzf_complete_git_parse_cmdline "git rm ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Rm Files> ')
@test "git rm with --cached" (__fzf_complete_git_parse_cmdline "git rm --cached ") = (printf '%s\t%s\t%s\t%s\n' ls_file true file 'Git Rm Files> ')

# ============================================================
# 32. git show
# ============================================================
@test "git show" (__fzf_complete_git_parse_cmdline "git show ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Show> ')
@test "git show with --stat" (__fzf_complete_git_parse_cmdline "git show --stat ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Show> ')

# git show exclusions
@test "git show --pretty should not match" (not __fzf_complete_git_parse_cmdline "git show --pretty ") $status -eq 0
@test "git show --format should not match" (not __fzf_complete_git_parse_cmdline "git show --format ") $status -eq 0

# ============================================================
# 33. git revert
# ============================================================
@test "git revert" (__fzf_complete_git_parse_cmdline "git revert ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_simple 'Git Revert> ')
@test "git revert with -n" (__fzf_complete_git_parse_cmdline "git revert -n ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_simple 'Git Revert> ')
@test "git revert with --no-commit" (__fzf_complete_git_parse_cmdline "git revert --no-commit ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_simple 'Git Revert> ')

# ============================================================
# 34. git cherry-pick
# ============================================================
@test "git cherry-pick" (__fzf_complete_git_parse_cmdline "git cherry-pick ") = (printf '%s\t%s\t%s\t%s\n' commit true ref_full 'Git Cherry-pick> ')
@test "git cherry-pick with -n" (__fzf_complete_git_parse_cmdline "git cherry-pick -n ") = (printf '%s\t%s\t%s\t%s\n' commit true ref_full 'Git Cherry-pick> ')
@test "git cherry-pick with commit" (__fzf_complete_git_parse_cmdline "git cherry-pick abc123 ") = (printf '%s\t%s\t%s\t%s\n' commit true ref_full 'Git Cherry-pick> ')

# git cherry-pick exclusions (control flow options)
@test "git cherry-pick --continue should not match" (not __fzf_complete_git_parse_cmdline "git cherry-pick --continue ") $status -eq 0
@test "git cherry-pick --abort should not match" (not __fzf_complete_git_parse_cmdline "git cherry-pick --abort ") $status -eq 0
@test "git cherry-pick --skip should not match" (not __fzf_complete_git_parse_cmdline "git cherry-pick --skip ") $status -eq 0
@test "git cherry-pick --quit should not match" (not __fzf_complete_git_parse_cmdline "git cherry-pick --quit ") $status -eq 0

# ============================================================
# 35. git blame
# ============================================================
@test "git blame" (__fzf_complete_git_parse_cmdline "git blame ") = (printf '%s\t%s\t%s\t%s\n' ls_file false file 'Git Blame> ')
@test "git blame with -L" (__fzf_complete_git_parse_cmdline "git blame -L 1,10 ") = (printf '%s\t%s\t%s\t%s\n' ls_file false file 'Git Blame> ')
@test "git blame with rev" (__fzf_complete_git_parse_cmdline "git blame HEAD ") = (printf '%s\t%s\t%s\t%s\n' ls_file false file 'Git Blame> ')
@test "git blame with --" (__fzf_complete_git_parse_cmdline "git blame -- ") = (printf '%s\t%s\t%s\t%s\n' ls_file false file 'Git Blame> ')

# ============================================================
# 36. git worktree
# ============================================================
@test "git worktree add with path" (__fzf_complete_git_parse_cmdline "git worktree add ../hotfix ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_simple 'Git Worktree> ')
@test "git worktree add -b with path" (__fzf_complete_git_parse_cmdline "git worktree add -b feature ../feature ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_simple 'Git Worktree> ')

# git worktree subcommands without completion
@test "git worktree list should not match" (not __fzf_complete_git_parse_cmdline "git worktree list ") $status -eq 0
@test "git worktree prune should not match" (not __fzf_complete_git_parse_cmdline "git worktree prune ") $status -eq 0

# ============================================================
# 37. git format-patch
# ============================================================
@test "git format-patch" (__fzf_complete_git_parse_cmdline "git format-patch ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Format-patch> ')
@test "git format-patch with -o" (__fzf_complete_git_parse_cmdline "git format-patch -o patches ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Format-patch> ')

# git format-patch exclusions
@test "git format-patch --in-reply-to should not match" (not __fzf_complete_git_parse_cmdline "git format-patch --in-reply-to ") $status -eq 0
@test "git format-patch --to should not match" (not __fzf_complete_git_parse_cmdline "git format-patch --to ") $status -eq 0
@test "git format-patch --cc should not match" (not __fzf_complete_git_parse_cmdline "git format-patch --cc ") $status -eq 0

# ============================================================
# 38. git describe
# ============================================================
@test "git describe" (__fzf_complete_git_parse_cmdline "git describe ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Describe> ')
@test "git describe with --tags" (__fzf_complete_git_parse_cmdline "git describe --tags ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Describe> ')
@test "git describe with --all" (__fzf_complete_git_parse_cmdline "git describe --all ") = (printf '%s\t%s\t%s\t%s\n' commit false ref_full 'Git Describe> ')

# ============================================================
# 39. git push
# ============================================================
@test "git push" (__fzf_complete_git_parse_cmdline "git push ") = (printf '%s\t%s\t%s\t%s\n' remote false file 'Git Push Remote> ')
@test "git push with options" (__fzf_complete_git_parse_cmdline "git push -f ") = (printf '%s\t%s\t%s\t%s\n' remote false file 'Git Push Remote> ')
@test "git push origin" (__fzf_complete_git_parse_cmdline "git push origin ") = (printf '%s\t%s\t%s\t%s\n' branch true ref_simple 'Git Push Branch> ')
@test "git push origin main" (__fzf_complete_git_parse_cmdline "git push origin main ") = (printf '%s\t%s\t%s\t%s\n' branch true ref_simple 'Git Push Branch> ')

# git push exclusions
@test "git push --repo should not match" (not __fzf_complete_git_parse_cmdline "git push --repo ") $status -eq 0
@test "git push -o should not match" (not __fzf_complete_git_parse_cmdline "git push -o ") $status -eq 0

# ============================================================
# 40. git pull
# ============================================================
@test "git pull" (__fzf_complete_git_parse_cmdline "git pull ") = (printf '%s\t%s\t%s\t%s\n' remote false file 'Git Pull Remote> ')
@test "git pull with options" (__fzf_complete_git_parse_cmdline "git pull --rebase ") = (printf '%s\t%s\t%s\t%s\n' remote false file 'Git Pull Remote> ')
@test "git pull origin" (__fzf_complete_git_parse_cmdline "git pull origin ") = (printf '%s\t%s\t%s\t%s\n' branch false ref_simple 'Git Pull Branch> ')

# ============================================================
# 41. git fetch
# ============================================================
@test "git fetch" (__fzf_complete_git_parse_cmdline "git fetch ") = (printf '%s\t%s\t%s\t%s\n' remote false file 'Git Fetch Remote> ')
@test "git fetch with options" (__fzf_complete_git_parse_cmdline "git fetch --all ") = (printf '%s\t%s\t%s\t%s\n' remote false file 'Git Fetch Remote> ')
@test "git fetch origin" (__fzf_complete_git_parse_cmdline "git fetch origin ") = (printf '%s\t%s\t%s\t%s\n' branch true ref_simple 'Git Fetch Branch> ')
@test "git fetch origin main" (__fzf_complete_git_parse_cmdline "git fetch origin main ") = (printf '%s\t%s\t%s\t%s\n' branch true ref_simple 'Git Fetch Branch> ')

# git fetch exclusions
@test "git fetch --upload-pack should not match" (not __fzf_complete_git_parse_cmdline "git fetch --upload-pack ") $status -eq 0

# ============================================================
# 42. git bisect
# ============================================================
@test "git bisect start" (__fzf_complete_git_parse_cmdline "git bisect start ") = (printf '%s\t%s\t%s\t%s\n' commit true ref_full 'Git Bisect> ')
@test "git bisect start with bad" (__fzf_complete_git_parse_cmdline "git bisect start HEAD ") = (printf '%s\t%s\t%s\t%s\n' commit true ref_full 'Git Bisect> ')
@test "git bisect bad" (__fzf_complete_git_parse_cmdline "git bisect bad ") = (printf '%s\t%s\t%s\t%s\n' commit true ref_full 'Git Bisect> ')
@test "git bisect good" (__fzf_complete_git_parse_cmdline "git bisect good ") = (printf '%s\t%s\t%s\t%s\n' commit true ref_full 'Git Bisect> ')
@test "git bisect good with commit" (__fzf_complete_git_parse_cmdline "git bisect good v1.0 ") = (printf '%s\t%s\t%s\t%s\n' commit true ref_full 'Git Bisect> ')
@test "git bisect new" (__fzf_complete_git_parse_cmdline "git bisect new ") = (printf '%s\t%s\t%s\t%s\n' commit true ref_full 'Git Bisect> ')
@test "git bisect old" (__fzf_complete_git_parse_cmdline "git bisect old ") = (printf '%s\t%s\t%s\t%s\n' commit true ref_full 'Git Bisect> ')
@test "git bisect skip" (__fzf_complete_git_parse_cmdline "git bisect skip ") = (printf '%s\t%s\t%s\t%s\n' commit true ref_full 'Git Bisect> ')
@test "git bisect reset" (__fzf_complete_git_parse_cmdline "git bisect reset ") = (printf '%s\t%s\t%s\t%s\n' commit true ref_full 'Git Bisect> ')

# git bisect subcommands without completion
@test "git bisect next should not match" (not __fzf_complete_git_parse_cmdline "git bisect next ") $status -eq 0
@test "git bisect log should not match" (not __fzf_complete_git_parse_cmdline "git bisect log ") $status -eq 0
@test "git bisect run should not match" (not __fzf_complete_git_parse_cmdline "git bisect run ") $status -eq 0
@test "git bisect replay should not match" (not __fzf_complete_git_parse_cmdline "git bisect replay ") $status -eq 0

# ============================================================
# No match cases
# ============================================================
@test "unknown command returns 1" (not __fzf_complete_git_parse_cmdline "ls ") $status -eq 0
@test "git without space returns 1" (not __fzf_complete_git_parse_cmdline "git") $status -eq 0
@test "git status returns 1" (not __fzf_complete_git_parse_cmdline "git status ") $status -eq 0
@test "git clone returns 1" (not __fzf_complete_git_parse_cmdline "git clone ") $status -eq 0
