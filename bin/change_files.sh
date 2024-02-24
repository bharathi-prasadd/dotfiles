#!/usr/bin/zsh 


#Empty dirs dont match the literal *
setopt NULL_GLOB

IN_FILE="/tmp/to-do.md"
OUT_FILE="/tmp/temp.md"

#If the file already exists it empty it
if [[ -f "$OUT_FILE" ]]; then
    echo -n "" > $OUT_FILE
fi

PATH_="/home/rumi/Public/to_do"

# Regex to match directories and files
DIR_STR="^#\ .*" 
FILE_STR="^##\ .*"


if [[ ! -f "$IN_FILE" ]]; then
    echo "File not found"
    exit -1
fi

# Extract the string in # str #
# and return it
# Read strips away leading and trailing spaces
function get_dirname() {
        str="$(echo $1 | /usr/bin/cut -d "#" -f2)"
        read -r dir <<< $str
        echo "$dir"
}

# Same as above but for filenames( structure ## str ##)
function get_filename() {
        str="$(echo $1 | /usr/bin/cut -d "#" -f3)"
        read -r temp <<< $str
        echo "${temp/\ /_}"
}

# Variable to check if its the first time through the loop or not
empty=1
while IFS= read -r line; do
    if [[ $line =~ $DIR_STR ]]; then
        tmp=$(get_dirname $line)
        # If its not the first iteration (out file isnt empty)
        if [[ $empty -eq 0 ]]; then
           og_file="$PATH_/$dir/$file_name.md"
           # Check if any changes have been made
           if diff -q "$og_file" "$OUT_FILE" > /dev/null; then
               echo "No changes to $og_file"
               echo -n "" > "$OUT_FILE"
           else
               diff -e  "$og_file" "$OUT_FILE" > patch_file
               patch "$og_file" < patch_file
               echo -n "" > "$OUT_FILE"
            fi
            # If we're encountering a new directory there'll be a filename
            # before any other content. So set empty back to 1
            empty=1
        fi
        dir="$tmp"

    elif [[ $line =~ $FILE_STR ]]; then
        tmp=$(get_filename $line)
        if [[ -f "$PATH_/$dir/$tmp.md" ]]; then
            if [[ "$empty" -eq 0 ]]; then
               og_file="$PATH_/$dir/$file_name.md"
               if diff  -q "$og_file" "$OUT_FILE" > /dev/null; then
                   echo "No changes to $og_file"
                   echo -n "" > "$OUT_FILE"
               else
                   diff -e "$og_file" "$OUT_FILE" > patch_file 
                   patch "$og_file" < patch_file
                   echo "Patching $og_file"
                   echo -n "" > "$OUT_FILE"
                fi
            fi
            file_name=$tmp
        else 
            # If the above if condition fails - its just a normal line
            # Include it in the .md file
            echo "$line" >> "$OUT_FILE"
            if [[ "$empty" -eq 1 ]];then
                empty=0
            fi
        fi
    elif [[ -z "$line" ]]; then
        # Skip empty lines
        continue
    else
        echo "$line" >> "$OUT_FILE"
        if [[ $empty -eq 1 ]];then
            empty=0
        fi
    fi
done < "$IN_FILE"

# Last directory doesnt get caught by the above while loop
og_file="$PATH_/$dir/$file_name.md"
if [[ -f "$og_file" ]]; then
    if diff -q "$og_file" "$OUT_FILE" > /dev/null; then
        echo "No change to $og_file"
    else 
        diff  "$og_file" "$OUT_FILE" > patch_file
        patch "$og_file" < patch_file
    fi
fi

# Remove patch_file if it exists
if [[ -f patch_file ]]; then
    rm patch_file
fi
