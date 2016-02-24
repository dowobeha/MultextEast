#!/bin/bash

IN_FILE=$1
OUT_FILE=$1.parallel2
LANGs=$2

IN_DIR=multextEast
OUT_DIR=multextEastAligned

./getIDs.rb ${IN_FILE} > ${OUT_FILE}

cat ${OUT_FILE} | grep -v "^<s " | sed 's,<p id,<SPEAKER ID,' | sed 's,.*alignment="\([^"]*\)".*,\1,' > ${OUT_FILE}.gold

rm -rf ${IN_DIR} ${OUT_DIR}
mkdir  ${IN_DIR} ${OUT_DIR}

for lang in ${LANGs}; do
	mkdir ${IN_DIR}/${lang}
	./multextEast2Europarl2.sh ${OUT_FILE} ${lang} > ${IN_DIR}/${lang}/1984
done

../multialign/bin3/align ./dummySplit.sh ${IN_DIR} ${OUT_DIR} > ${OUT_FILE}.actual 2> ${OUT_FILE}.actual.log

diff -y <(cat ${OUT_FILE}.gold | tr -d "<" | tr -d ">") <(cat ${OUT_FILE}.actual | tr -d "<" | tr -d ">") > ${OUT_FILE}.diff

clear

grep "[<>|]" ${OUT_FILE}.diff
