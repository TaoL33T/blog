#!/bin/sh
# This shell script creates a new post with the current date 
# and the title that is given via the first argument
# regex for filename is stolen from:
# https://serverfault.com/questions/348482/how-to-remove-invalid-characters-from-filenames

date=$(date --rfc-email)
title=$@
filename=$(date --iso-8601=date --date="$date")-$(echo $title | sed -e 's/[^A-Za-z0-9_-]/-/g').md
echo "---
layout: post
title: $title
date: $date
description: $title
..." >> _posts/$filename

# after creating the file, open it in $EDITOR
$EDITOR _posts/$filename
