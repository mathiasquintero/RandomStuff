#!/bin/bash
find "$PWD" -type d | while read -r line; do cd "$line" && rm *.pyc; done;
