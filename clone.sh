#!/bin/bash
set -eu
set -xv
source=$1
basename=${source##*/}
dest=${2:-$basename}

mkdir -p cloned
clonedir=./cloned/$basename

git clone $source $clonedir

{
    cd $clonedir

    # 4. change the origin, preserve the original
    git remote rename origin upstream
    git remote add origin git@github.com:elifesciences-publications/$dest.git

    # 5. push to github
    # WARN: assumes project is using branch 'master'
    git push origin master
}
