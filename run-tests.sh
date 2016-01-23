#!/bin/bash

# make sure we're in the project directory
cd $(dirname "$0")

# just to include the functions defined in ./bd
. ./bd /dev/null > /dev/null

red='\e[0;31m'
green='\e[0;32m'
nocolor='\e[0m'

success=0
failure=0
total=0

assertEquals() {
    ((total++))
    expected=$1
    actual=$2
    if [[ $expected = $actual ]]; then
        ((success++))
    else
        ((failure++))
        {
            echo Assertion failed on line $(caller 0)
            echo "  Expected: $expected"
            echo "  Actual  : $actual"
        } >&2
        echo
    fi
}

oldpwd=/home/user/project/src/org/main/site/utils/file/reader/whatever

# should do nothing if run with no args
newpwd $oldpwd
assertEquals $oldpwd $NEWPWD

# should jump for exact match
newpwd $oldpwd src
assertEquals /home/user/project/src/ $NEWPWD

# should do nothing for prefix match without -s
newpwd $oldpwd sr
assertEquals $oldpwd $NEWPWD

# should jump for prefix match with -s
newpwd $oldpwd -s sr
assertEquals /home/user/project/src/ $NEWPWD

# should do nothing for mismatched case prefix match without -si
newpwd $oldpwd -s Sr
assertEquals $oldpwd $NEWPWD

# should jump for mismatched case prefix match with -si
newpwd $oldpwd -si Sr
assertEquals /home/user/project/src/ $NEWPWD

# handling spaces: should jump for exact match
newpwd '/home/user/my project/src' -s my
assertEquals '/home/user/my project/' "$NEWPWD"

# should jump to closest match
newpwd /tmp/a/b/c/d/a/b a
assertEquals /tmp/a/b/c/d/a/ "$NEWPWD"

echo
[[ $failure = 0 ]] && printf $green || printf $red
echo "Tests run: $total ($success success, $failure failed)"
printf $nocolor
echo
