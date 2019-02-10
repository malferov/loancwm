#!/bin/bash
jq -r '(.[0] | keys_unsorted) as $keys | $keys, map([.[ $keys[] ]])[] | @csv' \
  ../dat/histx3op.dat > operation.csv
python ./export_tdr.py
jq -r '.ztenders | . | (.[0] | keys_unsorted) as $keys | $keys, map([.[ $keys[] ]])[] | @csv' \
  ../portfolio/dat/port000000.dat > portfolio.csv
