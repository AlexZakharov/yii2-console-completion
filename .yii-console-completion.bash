#!/usr/bin/env bash
#
#  +------------------------------------------------------------------------+
#  | Yii console completion                                                 |
#  +------------------------------------------------------------------------+
#  | Copyright (c) 2015-2015 KFOSoftware Team (http://www.kfosoftware.net)  |
#  +------------------------------------------------------------------------+
#  | Authors: Cyril Turkevich <cyril.turkevich@gmail.com>                   |
#  +------------------------------------------------------------------------+
#
_yii()
{
    local cur prev script
    COMPREPLY=()
    _get_comp_words_by_ref -n : cur prev

    script="${COMP_WORDS[0]}"

    if [[ ${cur} == -* ]] ; then
        if [[ $prev != $script ]] ; then
            comm="${prev}"
        else
            comm=""
        fi
        options=$(${script} help ${comm} | grep -oh '^--[A-Za-z]*' | sort | uniq)
        COMPREPLY=($(compgen -W "${options}" -- ${cur}))
        return 0
    fi

    commands=$(${script} 2>/dev/null | grep -oh '[A-Za-z-]\{1,\}\/[A-Za-z-]\{1,\}' | sort | uniq)
    if [[ $script != $prev && 'help' != $prev ]]; then
        commands=$(ls)
        COMPREPLY=($(compgen -W "${commands}" -- ${cur}))
        return 0
    fi

    if [[ "$cur" == '\' ]]; then 
        prefix="$prev"
        commands=$(echo "${commands}" | sed s/"${prefix}"\//g)
        COMPREPLY=( $( compgen -W "${commands}") )
        return 0
    fi
    
    COMPREPLY=($(compgen -W "${commands}" -- ${cur}))
    __ltrim_colon_completions "$cur"
    return 0;
}

complete -F _yii yii
complete -F _yii ./yii
