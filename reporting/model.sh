#!/bin/bash
python ./model_v2.py
sqlite3 loancwm.db << EOF
drop table if exists erf;
.mode csv
.import erf.csv erf
EOF
