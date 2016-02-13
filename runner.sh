#!/bin/bash

for arg in $*; do
  echo "Compiling $arg ..."

  g++ -Wall -Werror -O1 -std=c++11 "$arg" -o tmp.exe
  if [ $? -ne 0 ]; then
    echo "Couldn't compile $arg"
    exit 1
  fi

  Q=`head -n 1 "$arg" | cut -d " " -f 2`
  compgen -G "${Q}/*in" > /dev/null
  if [ $? -ne 0 ]; then
    echo "The first line of your code should be something like:"
    echo "// 2015/s1" 
    exit 1
  fi

  for file in "${Q}"/*.in; do
    echo "Running program with input data: $file"
    /usr/bin/time -f "Run time: %U" ./tmp.exe < "$file" > tmp.out
    diff tmp.out "${file%%in}out"
    if [ $? -ne 0 ]; then
      echo "Incorrect output see diff above."
    fi
  done
done
