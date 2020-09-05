# git

`git branch`
Remote
`git branch -r`
Verbose
`git branch -vv`
`git branch branch-name`
`git checkout branch-name`

Feature branch... pushed... Rebase on master... Resolve conflict... Force push to keep clean tree.

```
git checkout -b user/feature123 origin/feature123`
git checkout -b user/feature456

git add file.txt
git commit -m "first commit"

git push
git push -u origin user/feature456

git checkout master
git pull
git checkout user/feature456

git rebase master
git rebase --continue
git push origin user/feature456 -f

```

Add file to last commit (Removes last commit and creates a new commit with the added file)

```
git add file2.txt
git commit --amend --no-edit
git push --force
```


`git status`
`git status -v`

Diff between the working copy and the index.
`git diff`
`git diff file.txt`

Diff between the index and the HEAD.
`git diff --cached`

Diff between the working directory and HEAD.
`git diff HEAD`

More branch diffs
`git diff branch1..branch2`
`git diff branch1...branch2`
`git diff master..feature -- <file>`
Diff branch commits
`git log branch1..branch2`
`git log --oneline --graph --decorate --abbrev-commit branch1..branch2`

`git add file.txt`
`git commit -m "commit message"`

Remove file from index
`git rm file.txt --cached`

`git push -u origin <upstream-branch-name>`
`git push`


Stash

Stash all the unstaged changes
`git stash --keep-index`

Stash specific files
`git stash push -m "work later" file1.txt file2.txt`

Reset
```
git reset --soft HEAD~1
git reset --hard HEAD~1
git reset --hard 0ad5a7a6
```
`--soft` the changes that are reset will be kept in local

