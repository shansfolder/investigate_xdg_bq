import numpy as np
import pandas as pd
from expan.core.experiment import Experiment

# f_q = './size_drop_down.sql'
# with open(f_q, 'r') as query_file:
#     query = query_file.read()

# bq_df = pd.read_gbq(query=query, project_id="team-octopus", verbose=False)

df_before = pd.read_csv('size_drop_down.csv')
df_before = df_before.loc[df_before['variant'].isin(['ControlSingleWithToggle', 'SingleNoToggle'])]
print("BEFORE")
print("data size:", len(df_before))
print("number of variants:", len(df_before['variant'].unique()))
print("number of client ids:", len(df_before['entity'].unique()))

exp = Experiment(control_variant_name='ControlSingleWithToggle', 
				 data=df_before, metadata={}, 
				 report_kpi_names=['conversion_rate'],
				 derived_kpis=[{'name':'conversion_rate','formula':'orders/sessions'}])
print(exp.delta())


# user_id = df_before['entity'].value_counts().idxmax()
# freq = df_before['entity'].value_counts().max()
# print("user " + user_id + " has appeared: " + str(freq) + " times.")
# print(df_before[df_before['entity']=='403044ca-c5bc-40ad-96cc-a41af47063ee'])


df_after = pd.read_csv('size_drop_down_after_removal.csv')
df_after = df_after.loc[df_after['variant'].isin(['ControlSingleWithToggle', 'SingleNoToggle'])]
print("AFTER")
print("data size:", len(df_after))
print("number of variants:", len(df_after['variant'].unique()))
print("number of client ids:", len(df_after['entity'].unique()))

exp = Experiment(control_variant_name='ControlSingleWithToggle', 
				 data=df_after, metadata={}, 
				 report_kpi_names=['conversion_rate'],
				 derived_kpis=[{'name':'conversion_rate','formula':'orders/sessions'}])
print(exp.delta())

'''
properties of dataset

min date: 20170518
max date: 20170705
number of variants: 2
number of tests: 1
'''


'''
Before removal:

#client ids: 1556561
n_x: 778871
n_y: 777690

delta' -0.0005
mu_x: 0.1654
mu_y: 0.1659

interval: {2.5: -0.0019, 97.5: 0.0009}
'''


'''
Before removal:

#client ids: 1223879
n_x: 612354 
n_y: 611526

mu_x: 0.1454
mu_y: 0.1461
delta: -0.0007

interval: {2.5: -0.0022, 97.5: 0.0008}
'''