
import pandas as pd
import numpy as np
from sklearn import ensemble 
from sklearn import metrics

matches = pd.read_csv('match.csv', index_col=0)
players = pd.read_csv('players.csv')

test_labels = pd.read_csv('test_labels.csv', index_col=0)
test_players = pd.read_csv('test_player.csv')

train_labels = matches['radiant_win'].astype(int)
matches.head()

feature_columns = players.iloc[:3,4:17].columns.tolist()
feature_columns

player_groups = players.groupby('account_id')
#Formating 
feature_components = player_groups[feature_columns].mean()

train_ids = players[['match_id','account_id']]
test_ids = test_players[['match_id','account_id']]

train_feat_comp = pd.merge(train_ids, feature_components,
                           how='left', left_on='account_id' ,
                           right_index=True)

test_feat_comp = pd.merge(test_ids, feature_components, 
                          how='left', left_on='account_id',
                          right_index=True)