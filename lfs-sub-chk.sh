#!/bin/bash
set -e
repo="https://github.molgen.mpg.de/MPIBR/NeuroBits"
name="NeuroBits"

if [ ! -e $repo ]; then
    git clone --recurse-submodules $repo
fi


gsr="git-submodule-rewrite.sh"
wget https://raw.githubusercontent.com/jeremysears/scripts/master/bin/git-submodule-rewrite -O $gsr
chmod +x $gsr
mv $gsr $name

# cat .gitmodules
# ./gsr each modules
# git rm .gitmodules



# lfs

find . -type f -size +100M

# update 
# sudo apt-get update

# install java
# sudo apt-get install openjdk-9-jre-headless

# install git lfs
# curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
# sudo apt-get install git-lfs
# see docs

# install git bfg
# wget http://repo1.maven.org/maven2/com/madgag/bfg/1.13.0/bfg-1.13.0.jar
