#!/bin/env python
import sys
import numpy as np
import pandas as pd
import math
from pdb import set_trace as bp
import sqlite3

date_columns = ['deal_date', 'return_date', 'expiration_date']
conn = sqlite3.connect('./loancwm.db')
deals = pd.read_sql_query('select * from deals where model = "v1"', conn, parse_dates=date_columns)

#R3NORM = [200.0, 50.0]
R3NORM = [500.0, 500.0] # [x_offset, 0.5 range]
r3 = lambda x: 0.5 * (1 + x)
arg = lambda x: (x - R3NORM[0]) * 2 / R3NORM[1]
R3W = 0.9
#test = range(100, 300, 1)
bl = deals['business_level']
data = map(lambda x: r3(math.erf(arg(x))), bl) # , test)

#df = pd.DataFrame(data=data, index=bl, columns=['r3'])
deals['r31'] = data
deals.to_sql('deals31', conn, if_exists='replace')
conn.close()

#with open('erf.csv', 'w') as fp:
#    fp.write(df.to_csv(index_label='bl'))
#    fp.close

#bp()
