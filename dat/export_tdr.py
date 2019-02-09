#!/bin/env python
import sys
import csv
import numpy as np
import pandas as pd
import os
from pdb import set_trace as bp

size = 17

with open('../outlogTDR.txt') as fs:
    df = pd.read_csv(fs, header=None, names=range(size), skipinitialspace=True, engine='python')
    fs.close
    a = lambda col, pos : df[col].str.split(' ').str[pos]
    df['date']          = df[0].str[0:19]
    df['tdrnum']        = a(0, 2)
    df['bl']            = a(1, 1)
    df['zamount']       = a(2, 1)
    df['zamount_ready'] = a(3, 1)
    df['period']        = a(4, 1)
    df['rate']          = a(5, 1)
    df['backamount']    = a(6, 1)
    df['backcnt']       = a(7, 1)
    df['debt']          = a(8, 1)
    df['rating']        = a(9, 1)
    df['r1']            = a(9, 2)
    df['r2']            = a(9, 3)
    df['r3']            = a(9, 4)
    df['camount']       = a(10, 1)
    df['creditamount']  = a(11, 1)
    df['debtper']       = a(12, 1)
    df['ramt']          = a(13, 1)
    df['paid']          = a(14, 1)
with open('rating.csv', 'w') as fp:
    fp.write(df.to_csv(index = False, columns = [
        'date', 'tdrnum', 'bl', 'zamount', 'zamount_ready', 'period', 'rate', 
        'backamount', 'backcnt', 'debt', 'rating', 'r1', 'r2', 'r3', 'camount', 
        'creditamount', 'debtper', 'ramt', 'paid']))
    fp.close
