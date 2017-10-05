#Chat Analysis word cloud 


import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
from PIL import Image
import matplotlib.pyplot as plt
import wordcloud

chatDF = pd.read_csv('chat.csv')
chatDF.head()
selected_chat = chatDF
text = ' '.join(selected_chat['key'].astype(str).tolist())
stopwords = set(['fuck','gg','lol','haha','noob','XD','that','this','the','ok','wtf','ty','wp','fucking',
                'nice','ez','ggwp','idiot','yeah','my','retard','wow','bitch','jaja','noob','hahaha','rofl','shit','lmao'])
alice_mask = np.array(Image.open( "dota.jpg"))

wc = wordcloud.WordCloud(stopwords=stopwords,mask=alice_mask, background_color='white',colormap='terrain').generate(text)
plt.figure(figsize=(4,4), dpi=180, frameon=False)
plt.imshow(wc, interpolation='bilinear')
plt.axis("off")
plt.show()

