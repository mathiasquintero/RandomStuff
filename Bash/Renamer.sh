#!/bin/bash
# Will rename all files in a folder by replacing A with B

replace=$1
with=$2
for i in $( ls ); do
  echo item: $i
  foo=${i//$replace/$with}
  echo replaced with: $foo
  mv $i $foo
done
