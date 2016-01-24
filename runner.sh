#!/bin/bash

for arg in $*; do
  echo "Compiling $arg ..."

  Q=`head -n 1 "$arg" | cut -d " " -f 2`
  compgen -G "${Q}/*in" > /dev/null
  if [ $? -ne 0 ]; then
    echo "The first line of your code should be something like:"
    echo "// 2015/s1" 
    exit 1
  fi

  g++ "$arg" -o tmp.exe
  if [ $? -ne 0 ]; then
    echo "Couldn't compile $arg"
    exit 1
  fi

  for file in "${Q}"/*.in; do
    echo "Running program with input data: $file"
    ./tmp.exe < "$file" > tmp.out
    diff tmp.out "${file%%in}out"
    if [ $? -ne 0 ]; then
      echo "Incorrect output see diff above."
      exit 1
    fi
  done
done
