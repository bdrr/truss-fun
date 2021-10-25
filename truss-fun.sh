#!/bin/bash

# *** need to brew install coreutils for gdate ***
# *** Mac's date command is a PITA ***
cmd_list=( awk gdate echo iconv sed tr wc )

input_file="$(</dev/stdin)"


function verify_cmds {
    for cmd_check in ${cmd_list[@]}; do
        # echo "cmd_check: ${cmd_check}"
        if [[ ! $(command -v $cmd_check) ]]; then
            # should add a condition for gdate and MacOS/OSX
            echo "$cmd_check not found!"
            break
        fi
    done
}

function utf8_check {
    # does nothing for now
    # https://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-demo.txt
    # https://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-test.txt
    # cmd below should capture any non-printable characters.
    # grep -axv '.*' 
    # will need to exclude rows and rebuild table/csv
    # currently doesn't appear to have any so skipping for now
}

header_row=$(echo "$input_file" | sed -n '1p')
time_column=$(echo "$input_file" | awk -F, '{ print $1 }' | sed '1d')

function time_to_epoch_la {
    while read time; do
        TZ="America/Los_Angeles" gdate -d "${time}" "+%s"
    done < <(echo "$time_column")
}

function time_to_rfc3339_ny {
    while read new_time; do
        TZ="America/New_York" gdate -d @"${new_time}" --rfc-3339=seconds
done < <(time_to_epoch_la)
}



# making bacon pancakes
#verify_cmds
#time_to_rfc3339_ny
