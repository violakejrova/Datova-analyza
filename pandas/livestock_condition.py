#!/usr/bin/env python
# coding: utf-8

# In[3]:


import pandas as pd
df = pd.read_csv('pandas.csv')
pivot_df = df.pivot(index='druh', columns='intake_condition', values='count').fillna(0)

pivot_df.plot(kind='bar', stacked=True, figsize=(8, 5))


# In[ ]:




