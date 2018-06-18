#!/bin/bash
set -eu
#set -x
source=$1
basename=${source##*/}
dest=${2:-$basename}
thisdir=$(dirname $(readlink -f "$0"))

mkdir -p cloned
clonedir=./cloned/$basename

if [ ! -e $clonedir ]; then
    git clone $source $clonedir
fi

{
    cd $clonedir

    # submodule handling
    submodule_count=$(git submodule | wc -l)
    if [[ $submodule_count > 0 ]]; then

        git submodule update --init

        git submodule | while read line; do # ll: "8c67bc69c9bab60e7bdb04e2ccc71f3b8b20fbac Scoary (v1.3.5-10-g8c67bc6)"
            echo "$line"
            read -r rev path branch <<< $(echo $line)
            echo "$rev|$path|$branch"
            url=$(git config --file .gitmodules --path submodule."$path".url)
            echo $url
            
            rm -rf /tmp/"$path"
            mv "$path" /tmp/"$path"
            git submodule deinit "$path"
            git rm "$path"
            # unnecessary it seems
            #git config --file .gitmodules --remove-section "submodule.${path}"
            
            mv /tmp/"$path" "$path"
            rm "$path/.git"
            git add "$path"
            
            git ci -am "integrates submodule '$path' ($url) at revision $rev"

        done
    fi # ends submodule handling

    # lfs handling
    # if find . -type f -size +100M
    # . lfs.sh

    # 4. add an origin, preserves the original
    #git remote add elife-origin git@github.com:elifesciences-publications/$dest.git

    # 5. push to github
    # WARN: assumes project is using branch 'master'
    #git push elife-origin master
}
