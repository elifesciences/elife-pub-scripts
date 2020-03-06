# GIT LFS + Github

## case: finding large files

Within your large cloned repository:

    find . -type f -size +100M

If that reveals nothing, inspect repository history for large files.

## case: finding large files that have been deleted but are still present in git history

Within your large cloned repository:

    git-largest-files

## case: moving a large file to git-lfs

    cp <large file> ../
    git rm <large file>
    git ci -m "elife: removed <large file>"

    bfg --delete-files <large file>
    git reflog expire --expire=now --all && git gc --prune=now --aggressive

your repo should now be small again

    du -sh 

now

    git lfs install
    mv ../<large file> .
    git lfs track <large file>
    git add <large file>
    git add .gitattributes

    git lfs status # file should be present in objects to be commited

    git ci -m "elife: added <large file> to LFS tracker"
    git lfs status # file should be present in objects to be pushed
    git remote add elife-origin git@github.com:elifesciences-publications/<repo>.git
    git push -u elife-origin master
    
# case: moving git-lfs files back into git

When working with a large repository that someone has already attempting to use git-lfs with, there may be large files
that were not downloaded that need to be in order to push them to their new home.

    GIT_LFS_SKIP_SMUDGE=1 git clone https://repo # 'smudge' prevents lfs pointers or something
    git lfs pull # pull down the large files that weren't cloned

make a list of files already tracked by git-lfs

    git lfs ls-files | grep -vE "\.gz|\.rpm$" | cut -d ' ' -f 3 > /tmp/lfs-files.txt

untrack files

```bash
#!/bin/bash
set -e
for file in $(cat /ext/tmp/lfs-files.txt); do
  git lfs untrack "$file";
  git rm --cached "$file";
  git add --force "$file";
done
```

(files will still be present in `git lfs ls-files` until committed)

    git commit
    
check files are no longer tracked:
    
    git lfs ls-files # gone!
