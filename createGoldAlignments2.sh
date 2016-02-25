#!/bin/bash

LANGs=$2
IN_FILE=$1
OUT_FILE=$1_$(echo "${LANGs}" | tr -d ' ').parallel2

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

#grep "[<>|]" ${OUT_FILE}.diff

TRUE_POSITIVES=$(cat ${OUT_FILE}.diff | grep -v "SPEAKER" | grep -v "[<>|]" | wc -l)

#FALSE_POSITIVES=$(grep "[>|]" ${OUT_FILE}.diff | wc -l)
#FALSE_NEGATIVES=$(grep "[<|]" ${OUT_FILE}.diff | wc -l)

ALL_POSITIVES=$(grep -c -v "^<" ${OUT_FILE}.actual)
ALL_RELEVANT=$(grep -c -v "<" ${OUT_FILE}.gold)

PRECISION=$(ruby -e "puts sprintf( \"%0.04f\", ((${TRUE_POSITIVES}).to_f / ${ALL_POSITIVES}))")
RECALL=$(ruby -e "puts sprintf( \"%0.04f\", ((${TRUE_POSITIVES}).to_f / ${ALL_RELEVANT}))")

F_MEASURE=$(ruby -e "puts sprintf( \"%0.04f\", (2 * (${PRECISION} * ${RECALL}) / (${PRECISION} + ${RECALL})))")

echo -e "${LANGs}\tprecision=${PRECISION}\t${TRUE_POSITIVES}/${ALL_POSITIVES}"                           > ${OUT_FILE}.stats
echo -e "${LANGs}\t   recall=${RECALL}\t${TRUE_POSITIVES}/${ALL_RELEVANT}"                              >> ${OUT_FILE}.stats
echo -e "${LANGs}\tf-measure=${F_MEASURE}\t2 * (${PRECISION} * ${RECALL}) / (${PRECISION} + ${RECALL})" >> ${OUT_FILE}.stats

