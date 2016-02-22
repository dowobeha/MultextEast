#!/bin/bash

for lang in bg cs en et hu lt ro ru sl sr; do

echo ${lang}

cat orwl-${lang}.xml | tail -n +$(grep -n "<body" orwl-${lang}.xml | sed 's,:.*,,') | tr '\n' ' ' | sed 's,\s\+, ,g' | sed 's,> <,><,g' | sed 's,>,>\n,g' | sed 's,<,\n<,g' | grep -v "^$" | \
grep -v "<\/\??oxygen" | \
grep -v "<\/\??xml" | \
grep -v "<\/\?TEI" | \
grep -v "<\/\?abbr" | \
grep -v "<\/\?addrLine" | \
grep -v "<\/\?address" | \
grep -v "<\/\?availability" | \
grep -v "<\/\?biblFull" | \
grep -v "<\/\?biblStruct" | \
grep -v "<\/\?catRef" | \
grep -v "<\/\?change" | \
grep -v "<\/\?choice" | \
grep -v "<\/\?date" | \
grep -v "<\/\?distributor" | \
grep -v "<\/\?edition" | \
grep -v "<\/\?editionStmt" | \
grep -v "<\/\?editorialDecl" | \
grep -v "<\/\?encodingDesc" | \
grep -v "<\/\?expan" | \
grep -v "<\/\?extent" | \
grep -v "<\/\?fileDesc" | \
grep -v "<\/\?foreign" | \
grep -v "<\/\?hi" | \
grep -v "<\/\?hyphenation" | \
grep -v "<\/\?imprint" | \
grep -v "<\/\?item" | \
grep -v "<\/\?l" | \
grep -v "<\/\?langUsage" | \
grep -v "<\/\?language" | \
grep -v "<\/\?lg" | \
grep -v "<\/\?list" | \
grep -v "<\/\?measure" | \
grep -v "<\/\?mentioned" | \
grep -v "<\/\?monogr" | \
grep -v "<\/\?name" | \
grep -v "<\/\?namespace" | \
grep -v "<\/\?normalization" | \
grep -v "<\/\?note" | \
grep -v "<\/\?num" | \
grep -v "<\/\?profileDesc" | \
grep -v "<\/\?projectDesc" | \
grep -v "<\/\?ptr" | \
grep -v "<\/\?pubPlace" | \
grep -v "<\/\?publicationStmt" | \
grep -v "<\/\?publisher" | \
grep -v "<\/\?q" | \
grep -v "<\/\?quotation" | \
grep -v "<\/\?quote" | \
grep -v "<\/\?ref" | \
grep -v "<\/\?resp" | \
grep -v "<\/\?respStmt" | \
grep -v "<\/\?revisionDesc" | \
grep -v "<\/\?segmentation" | \
grep -v "<\/\?sourceDesc" | \
grep -v "<\/\?tagUsage" | \
grep -v "<\/\?tagsDecl" | \
grep -v "<\/\?teiHeader" | \
grep -v "<\/\?text" | \
grep -v "<\/\?textClass" | \
grep -v "<\/\?title" | \
grep -v "<\/\?titleStmt" | \
tr '\n' ' ' | sed 's,\s\+, ,g' | sed 's,> <,><,g' | sed 's,>,>\n,g' | sed 's,<,\n<,g' | grep -v "^$" | sed 's,^\s\+,,' > simplified-${lang}.xml

done
