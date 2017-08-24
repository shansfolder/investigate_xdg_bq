import numpy as np
import pandas as pd

# f_q = './size_drop_down.sql'
# with open(f_q, 'r') as query_file:
#     query = query_file.read()

# bq_df = pd.read_gbq(query=query, project_id="team-octopus", verbose=False)

df = pd.read_csv('size_drop_down_for_xdg.csv')
print("data size:", len(df))
print("number of variants:", len(df['TestVariant'].unique()))
print("number of tests:", len(df['TestName'].unique()))
print("number of client ids:", len(df['userID'].unique()))


user_id = df['userID'].value_counts().idxmax()
freq = df['userID'].value_counts().max()
print("user " + user_id + " has appeared: " + str(freq) + " times.")

# print(df[df['userID']=='403044ca-c5bc-40ad-96cc-a41af47063ee'])


# some properties of this dataset
'''
min date: 20170518
max date: 20170705
data size: 3098337
number of variants: 4
number of tests: 1
number of client ids: 3097610
user cf30ad8d-5c18-41d9-81b3-f970d6c0303b has appeared: 4 times 4 different test variants.
'''