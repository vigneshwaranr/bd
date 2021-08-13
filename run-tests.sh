#!/usr/bin/env bash

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
            echo
        } >&2
    fi
}

# should do nothing if run with no args
oldpwd=/usr/share/info
newpwd $oldpwd
assertEquals $oldpwd $NEWPWD

# should jump for exact match
newpwd /usr/share/info share
assertEquals /usr/share/ $NEWPWD

# should jump for closest exact match
newpwd /usr/share/info/share/bin share
assertEquals /usr/share/info/share/ $NEWPWD

# should do nothing for prefix match without -s
oldpwd=/usr/share/info
newpwd $oldpwd sh
assertEquals $oldpwd $NEWPWD

# should jump for prefix match with -s
newpwd /usr/share/info -s sh
assertEquals /usr/share/ $NEWPWD

# should jump for closest prefix match with -s
newpwd /usr/share/info/share/bin -s sh
assertEquals /usr/share/info/share/ $NEWPWD

# should do nothing for mismatched case prefix match without -si
oldpwd=/usr/share/info
newpwd $oldpwd -s Sh
assertEquals $oldpwd $NEWPWD

# should jump for mismatched case prefix match with -si
newpwd /usr/share/info -si Sh
assertEquals /usr/share/ $NEWPWD

# should jump for mismatched case prefix match with -si
newpwd /usr/sHAre/info -si Sh
assertEquals /usr/sHAre/ $NEWPWD

# should jump for closest mismatched case prefix match with -si
newpwd /usr/share/info/share/bin -si Sh
assertEquals /usr/share/info/share/ $NEWPWD

# handling spaces: should do nothing for prefix match without -s
newpwd '/home/user/my project/src' my
assertEquals '/home/user/my project/src' "$NEWPWD"

# handling spaces: should jump for exact match
newpwd '/home/user/my project/src' -s my
assertEquals '/home/user/my project/' "$NEWPWD"

echo
[[ $failure = 0 ]] && printf $green || printf $red
echo "Tests run: $total ($success success, $failure failed)"
printf $nocolor
echo
