#!/bin/bash

IN_FILE=$1
OUT_FILE=$1.parallel
LANGs=$2

./getIDs.rb ${IN_FILE} > ${OUT_FILE}

cat ${OUT_FILE} | grep -v "^<s " | sed 's,<p id,<SPEAKER ID,' | sed 's,.*alignment="\([^"]*\)".*,\1,' > ${OUT_FILE}.gold

rm -rf multextEast multextEastAligned
mkdir  multextEast multextEastAligned

for lang in ${LANGs}; do
	mkdir multextEast/${lang}
	./multextEast2Europarl.sh ${OUT_FILE} ${lang} > multextEast/${lang}/1984
done

../multialign/bin3/align ./dummySplit.sh multextEast multextEastAligned > ${OUT_FILE}.actual

