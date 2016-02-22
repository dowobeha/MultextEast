#!/bin/bash

FILE=$1
LANG=$2

grep "<p\|<aligned\|language=\"$2" $1 | sed 's,>,>\n,' | grep -v "<s " | sed 's,<p id,<SPEAKER ID,' | sed  's,<aligned_block id=\"\([^"]*\)"[^>]*>,<P>,' | grep -v "^$"

#s,<aligned_block id=\"\([^"]*\)"[^>]*>,<SPEAKER ID=\"\1\">,
#s,<s [^>]*>,<P>,
