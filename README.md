# Match-Prediction-in-DOTA-2
![alt text](https://raw.githubusercontent.com/akhilpatlolla/Match-Prediction-in-DOTA-2/master/Images/word%20cloud.png)

Match Prediction using Random Forest Classification in Defense of the Ancients 2(DOTA 2) 

	In the game of DOTA2, the players of one team coordinate among themselves to fight against other teams. The factors which affect the game are hero picking, lane selection and item build along with farming in the neutral camps. The major attributes of any hero are strength, agility and intelligence. Here, our main goal is to predict a probable winner based on the game metrics and subsequently build a prediction model. 

#Data Handling and Methodologies

	The data was parsed from steam we API, which is a collection of game data.SORT operation is performed based on MMR (Match Making Rank) of the players and by selecting equal distribution of the players data from the pool based on ranking. The selected data set comprises of 48 billion records.Task is to pick the features which affect the win prediction of the match. The game play involves metrics such as GPM (Gold Per Minute) i.e. average gold gained per every minute by each player, XPM (Experience Per Minute) average experience gained per every minute in the game, total gold earned in the game etc. Collected gold is spent towards ingame purchases such as items and buyback. Last hit is a metric which evaluates the skill to kill Creeps i.e. if a Creep is dead with the final hit of the player, then the respective hero will obtain bonus gold and experience. Also, last hit is recorded and higher the lasthit, better chance of the hero to have better GPM, XPM.
![alt text](https://raw.githubusercontent.com/akhilpatlolla/Match-Prediction-in-DOTA-2/master/Images/stats.png)

Skills considered to build the Random

	Forest First Prediction Model:
	'gold', 'gold_spent', 'gold_per_min', 'xp_per_min', 'kills', 'deaths', 'assists', 'denies', 'last_hits', 'stuns', hero_damage', 'hero_healing', 'tower_damage'



	The AUC for this model is observed to be 0.50 which predicts that both the teams have equal probability to win. Hence, the model fails. Considering the above model, correlation of all the features has been calculated with respect to Win Prediction.

![alt text](https://raw.githubusercontent.com/akhilpatlolla/Match-Prediction-in-DOTA-2/master/Images/correlation.png)

	A prediction model is built considering True-Skill as feature over Random Forest Classifier and a test set of around 1 million records is supplied as test data for the model and the ROC curve for that prediction model is as follows:

	The AUC for the above prediction is 0.75 which represents a better model than the prior one. 

![alt text](https://raw.githubusercontent.com/akhilpatlolla/Match-Prediction-in-DOTA-2/master/Images/roc%20cuve.png)