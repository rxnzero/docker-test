#!/bin/csh
if ($#argv == 2) then
  cat $1 | grep $2
else if ($#argv == 1) then
  cat $1
endif