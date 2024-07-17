#!/bin/bash

function create {
    read -p "Enter your name: " username
    if id "$username" &>/dev/null; then
        echo "User already exists, thanks for running this script. Bye for now."
        exit 1
    else
        useradd "$username"
        echo "Please enter your password"
        passwd "$username"
    fi
}

function delete {
    read -p "Enter your name: " username
    if id "$username" &>/dev/null; then
        userdel "$username"
        echo "User $username has been deleted."
    else
        echo "User does not exist."
    fi
    exit 1
}

function reset_password {
    read -p "Enter your username: " username
    if id "$username" &>/dev/null; then
        read -s -p "Enter new password: " newpassword
        echo
        read -s -p "Confirm password: " confirmpassword
        echo
        if [ "$newpassword" == "$confirmpassword" ]; then
            echo "$username:$newpassword" | chpasswd
            if [ $? -eq 0 ]; then
                echo "Password for $username has been reset."
            else
                echo "Error: Password was not set."
            fi
        else
            echo "Passwords did not match."
        fi
    else
        echo "Username does not exist."
    fi
}

function list_user {
    cat /etc/passwd | awk -F: '{ print $1 }'
}

echo "Hello! Welcome to the user maintenance page."
echo "Press c to Create a user."
echo "Press d to Delete a user."
echo "Press p to Reset a user's password."
echo "Press l to List users."
read -p "Your choice: " input

case "$input" in
    c)
        create
        ;;
    d)
        delete
        ;;
    p)
        reset_password
        ;;
    l)
        list_user
        ;;
    *)
        echo "Invalid option. Exiting."
        ;;
esac

