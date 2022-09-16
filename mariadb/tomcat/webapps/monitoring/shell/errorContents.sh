#!/bin/csh
if ($#argv == 4) then
  cat $1 | grep -nE "$2|$3" | grep $4
else if ($#argv == 3) then
  cat $1 | grep -nE "$2|$3"
endif

