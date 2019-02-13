#!/bin/bash
jq -r '(.[0] | keys_unsorted) as $keys | $keys, map([.[ $keys[] ]])[] | @csv' \
  ../dat/histx3op.dat > operation.csv
python ./export_tdr.py
jq -r '.ztenders | . | (.[0] | keys_unsorted) as $keys | $keys, map([.[ $keys[] ]])[] | @csv' \
  ../portfolio/dat/port000000.dat > portfolio.csv

sqlite3 loancwm.db << EOF
.mode csv
drop table if exists operation;
drop table if exists portfolio;
drop table if exists rating;
.import operation.csv operation
.import portfolio.csv portfolio
.import rating.csv rating
EOF

rm operation.csv portfolio.csv rating.csv