#!/usr/bin/bash

for file in .*; do
	mv $file dot-${file#.}
done
