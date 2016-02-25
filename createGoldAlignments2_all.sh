#!/bin/bash

for lang in bg cs             ; do ./createGoldAlignments2.sh oalg-${lang}en.xml "${lang} en"; done
for lang in et hu lt ro sl sr ; do ./createGoldAlignments2.sh oalg-en${lang}.xml "en ${lang}"; done

for i in *.stats ; do echo $i ; cat $i; echo; done
