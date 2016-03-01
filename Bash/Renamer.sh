#!/bin/bash
# Will rename all files in a folder by replacing A with B

for i in $( ls ); do
  echo item: $i
  foo=${i//file_assignsubmission_/}
  echo $foo
  mv $i $foo
done
