#!/bin/bash
# Add autocomplete support for bd for bash.
_bd()
{
    # Handle spaces in filenames by setting the delimeter to be a newline.
    local IFS=$'\n'
    # Current argument on the command line.
    local cur=${COMP_WORDS[COMP_CWORD]}
    # Available directories to autcomplete to.
    local completions=$( pwd | sed 's|/|\n|g' )

    COMPREPLY=( $(compgen -W "$completions" -- $cur) )
}
complete -F _bd bd
