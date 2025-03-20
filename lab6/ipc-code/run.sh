#!/bin/bash

# Compile program1.c with debugging (-g)
gcc -g client.c -o client
if [ $? -eq 0 ]; then
    echo "Compiled client successfully!"
else
    echo "Compilation failed for client."
    exit 1
fi

# Compile program2.c with debugging (-g)
gcc -g server.c -o server
if [ $? -eq 0 ]; then
    echo "Compiled server successfully!"
else
    echo "Compilation failed for server."
    exit 1
fi

echo "Both programs compiled successfully."