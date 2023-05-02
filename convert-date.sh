#!/bin/bash

for file in *.md
do 
    old_date="$(grep 'date: ' $file | sed 's/date: //')"
    new_date="$(date '+date: %F %T %z' --date="$old_date")"
    sed -i -e '2ilayout: post' -e 's/date: '"$old_date"'/'"$new_date"'/' -e '0,/\.\.\.$/s//---\n/' $file
done
