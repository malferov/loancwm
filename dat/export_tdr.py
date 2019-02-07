#!/bin/env python
import sys
import csv
import numpy as np
import pandas as pd
import os
from pdb import set_trace as bp

with open('../outlogTDR.txt') as fs:
    df = pd.read_csv(fs, header=None, names=range(17), skipinitialspace=True, engine='python')
    fs.close
    df['date']          = df[0].str[0:19]
    df['tdrnum']        = df[0].str.split(' ').str[2]
    df['bl']            = df[1].str.split(' ').str[1]
    df['zamount']       = df[2].str.split(' ').str[1]
    df['zamount_ready'] = df[3].str.split(' ').str[1]
    df['period']        = df[4].str.split(' ').str[1]
    df['rate']          = df[5].str.split(' ').str[1]
    df['backamount']    = df[6].str.split(' ').str[1]
    df['backcnt']       = df[7].str.split(' ').str[1]
    df['debt']          = df[8].str.split(' ').str[1]
    df['rating']        = df[9].str.split(' ').str[1]
    df['r1']            = df[9].str.split(' ').str[2]
    df['r2']            = df[9].str.split(' ').str[3]
    df['r3']            = df[9].str.split(' ').str[4]
    df['camount']       = df[10].str.split(' ').str[1]
    df['creditamount']  = df[11].str.split(' ').str[1]
    df['debtper']       = df[12].str.split(' ').str[1]
    df['ramt']          = df[13].str.split(' ').str[1]
    df['paid']          = df[14].str.split(' ').str[1]
with open('rating.csv', 'w') as fp:
    fp.write(df.to_csv(index = False, columns = [
        'date', 'tdrnum', 'bl', 'zamount', 'zamount_ready', 'period', 'rate', 
        'backamount', 'backcnt', 'debt', 'rating', 'r1', 'r2', 'r3', 'camount', 
        'creditamount', 'debtper', 'ramt', 'paid']))
    fp.close
