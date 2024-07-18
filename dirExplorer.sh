#/bin/bash

echo "Hello the files and directory in current working directory is :"
ls ls -ltr

echo "Please enter a statement for which you need the character count or hit enter to exit"
read input

if [ -z "$input" ]; then
	echo "Ba-bye"
	exit 1
fi

char_count=$(echo -n "$input" | wc -m) 

echo "Character count is : $char_count"


