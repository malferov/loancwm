#!/bin/bash
jq -r '(.[0] | keys_unsorted) as $keys | $keys, map([.[ $keys[] ]])[] | @csv' \
  ../dat/histx3op.dat > operation.csv

jq -r '.ztenders | (.[0] | keys_unsorted) as $keys | $keys, map([.[ $keys[] ]])[] | @csv' \
  ../portfolio/dat/port000000.dat > portfolio.csv

jq '.ctenders[] | .ctenderData + .CreditStatus + .AttData |
  del(.FirstName, .LastName, .MidName, .PassportN)' \
  ../portfolio/dat/port[!0]*.dat \
  | jq -sr '(.[0] | keys_unsorted) as $keys | $keys, map([.[ $keys[] ]])[] | @csv' \
  > tenders.csv

python ./export_rating.py

sqlite3 loancwm.db << EOF
.mode csv
drop table if exists operation;
drop table if exists portfolio;
drop table if exists tenders;
drop table if exists rating;
.import operation.csv operation
.import portfolio.csv portfolio
.import tenders.csv tenders
.import rating.csv rating
EOF

rm operation.csv portfolio.csv tenders.csv rating.csv
