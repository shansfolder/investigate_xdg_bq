import numpy as np
import pandas as pd
from expan.core.experiment import Experiment

###################################################

df_before = pd.read_csv('nextgen_header.csv')
print("BEFORE")
print("data size:", len(df_before))
print("number of variants:", len(df_before['variant'].unique()))
print("number of client ids:", len(df_before['entity'].unique()))

exp = Experiment(control_variant_name='control', 
				 data=df_before, metadata={}, 
				 report_kpi_names=['revenue_per_user'],
				 derived_kpis=[{'name':'revenue_per_user','formula':'revenue/users'}])
print(exp.delta())

###################################################

df_after = pd.read_csv('nextgen_header_after_removal.csv')
print("AFTER")
print("data size:", len(df_after))
print("number of variants:", len(df_after['variant'].unique()))
print("number of client ids:", len(df_after['entity'].unique()))

exp = Experiment(control_variant_name='control', 
				 data=df_after, metadata={}, 
				 report_kpi_names=['revenue_per_user'],
				 derived_kpis=[{'name':'revenue_per_user','formula':'revenue/users'}])
print(exp.delta())

###################################################

'''
properties of dataset

min date: 20170824
max date: 20171009
number of variants: 2
number of tests: 1
'''


'''
Before removal:
------------------

#entity: 12198395
#control: 5723156
#treatment: 6490518

mean_control: 20.8854
mean_treatment: 23.1092
delta: 2.2238

interval: {2.5: 2.0568, 97.5: 2.3907}


Before removal:
------------

#entity: 10230075
#control: 4760084 
#treatment: 5481599

mean_control: 14.3363
mean_treatment: 16.8997
delta: 2.5634

interval: {2.5: 2.4238, 97.5: 2.7029}
'''