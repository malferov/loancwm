#!/bin/env python
import sys
import numpy as np
import pandas as pd
import math
from pdb import set_trace as bp
"""
rating.csv
rating, r1, r2, r3 -> type INTEGER

model version
starting 2016-06-03 00:00 -> v1
"""

R3NORM = [200.0, 50.0]
r3 = lambda x: 0.5 * (1 + x)
arg = lambda x: (x - R3NORM[0]) * 2 / R3NORM[1]
R3W = 0.9
bl = range(100, 300, 1)
data = map(lambda x: r3(math.erf(arg(x))), bl)

df = pd.DataFrame(data=data, index=bl, columns=['r3'])

with open('erf.csv', 'w') as fp:
    fp.write(df.to_csv(index_label='bl'))
    fp.close
