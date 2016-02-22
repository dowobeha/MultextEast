#!/bin/bash

for lang in bg cs en et hu lt ro ru sl sr; do

echo ${lang}

cat orwl-${lang}.xml | tail -n +$(grep -n "<body" orwl-${lang}.xml | sed 's,:.*,,') | tr '\n' ' ' | sed 's,\s\+, ,g' | sed 's,> <,><,g' | sed 's,<,\n<,g' | 
grep -v "<\/\?note" | \
grep -v "<\/\?head" | \
grep -v "<\/\?expan" | \
sed 's,>,>\n,g' | grep -v "^$" | \
grep -v "<\/\?abbr" | \
grep -v "<\/\?body" | \
grep -v "<\/\?choice" | \
grep -v "<\/\?date" | \
grep -v "<\/\?div" | \
grep -v "<\/\?expan" | \
grep -v "<\/\?foreign" | \
grep -v "<\/\?hi" | \
grep -v "<\/\?mentioned" | \
grep -v "<\/\?name" | \
grep -v "<\/\?num" | \
grep -v "<\/\?ptr" | \
grep -v "<\/\?term" | \
grep -v "<\/\?title" | \
grep -v "<\/" | \
tr '\n' ' ' | sed 's,\s\+, ,g' | sed 's,> <,><,g' | sed 's,\(<[^\/]\),\n\1,g' | grep -v "^$" | sed 's,^\s\+,,' | sed 's,\(.* xml:id="\)[A-Za-z][A-Za-z][A-Za-z].\([^"]*"\)[^>]*\(>\),\1\2\3,' | grep "<" | sed 's,<q [^>]*>\(.*\),\1,' | tr '\n' ' ' | sed 's,\s\+, ,g' | sed 's,> <,><,g' | sed 's,\(<[^\/]\),\n\1,g' | grep -v "^$" | sed 's,^\s\+,,' | sed 's,<quote ,<p ,; s,<lg ,<p ,; s,<l ,<s ,; s,<list ,<p ,; s,<item ,<s ,' | sed 's,>,>\n,' | grep -v "^$" > simplified-${lang}.xml


#sed 's,\(.* xml:id="\)[A-Za-z][A-Za-z][A-Za-z].\([^"]*"\)[^>]*\(>\),\1\2\3,' | sed 's,>.*,,; s,<,,'
#sed 's,>,>\n,g' | sed 's,<,\n<,g' | grep "<" | sed 's, .*,,g' | sort | uniq -c

#| sed 's,>,>\n,g' | sed 's,<,\n<,g' | grep -v "^$" | sed 's,^\s\+,,' > simplified-${lang}.xml

done
