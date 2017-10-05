library(ggplot2) 
library(readr) 
library(dplyr)
library(matrixStats)
library(randomForest)
library(ROCR)

setwd("~/dota-2-matches")
 
##
## Reading the data into data Tables ##
##
data = read.table("player_time.csv",header=TRUE, row.names=NULL,sep = ",",fill = TRUE)
dataMatch = read.table("match.csv",header=TRUE, row.names=NULL,sep = ",",fill = TRUE)
##
## Creatig Data Frames from tables ##
##
df <- data.frame(data)
dfMatch <- data.frame(dataMatch)
df <- df[!(df$times == 0),]
dfMatch<- dfMatch[(dfMatch$game_mode == 22),]
dfMatch <- dfMatch[,!(colnames(dfMatch) %in% c("negative_votes","positive_votes","cluster"))]

##
## Calculating the aggregate value of gold for the whole team ##
##
RadiantGold <- df$gold_t_0 + df$gold_t_1 + df$gold_t_2 + df$gold_t_3 + df$gold_t_4
df$RadiantGold <- RadiantGold

RadiantGoldSD <-apply(df[,c("gold_t_0","gold_t_1","gold_t_2","gold_t_3","gold_t_4")],1,sd)
df$RadiantGoldSD <- RadiantGoldSD

RadiantGoldMAD <-apply(df[,c("gold_t_0","gold_t_1","gold_t_2","gold_t_3","gold_t_4")],1,mad)
df$RadiantGoldMAD <- RadiantGoldMAD

DireGold <- df$gold_t_128 + df$gold_t_129 + df$gold_t_130 + df$gold_t_131 + df$gold_t_132
df$DireGold <- DireGold

##
## Calcualte the aggregate value of experience for the whole team ##
##

RadiantXp <- df$xp_t_0 + df$xp_t_1 + df$xp_t_2 + df$xp_t_3 + df$xp_t_4
df$RadiantXp <- RadiantXp

RadiantXpSD <-apply(df[,c("xp_t_0","xp_t_1","xp_t_2","xp_t_3","xp_t_4")],1,sd)
df$RadiantXpSD <- RadiantXpSD

RadiantXpMAD <-apply(df[,c("xp_t_0","xp_t_1","xp_t_2","xp_t_3","xp_t_4")],1,mad)
df$RadiantXpMAD <- RadiantXpMAD

DireXp <- df$xp_t_128 + df$xp_t_129 + df$xp_t_130 + df$xp_t_131 + df$xp_t_132
df$DireXp <- DireXp
df$RadiantGoldAdv <- df$RadiantGold - df$DireGold 
df$DireGoldAdv <- df$DireGold - df$RadiantGold

df$RadiantXpAdv <- df$RadiantXp - df$DireXp 
df$DireXpAdv <- df$DireXp - df$RadiantXp

##
## Joining data based on the requiremnt and  ##
##
matchSoT <- merge(df,dfMatch, by ="match_id")
matchSoT$radiant_win <- matchSoT$radiant_win == "True"

matchSoT$dire_win <- !matchSoT$radiant_win
match15 <- matchSoT[(matchSoT$times == 900),]

match15Adv <- match15[,c("match_id","RadiantXpAdv","RadiantGoldAdv","RadiantGoldSD","RadiantGoldMAD","RadiantXpSD","RadiantXpMAD","radiant_win")]

matchEvery5 <- matchSoT[(matchSoT$times%%900==0),]
matchTableau <- matchEvery5[,c("match_id","times","RadiantXpAdv","RadiantGoldAdv","radiant_win")]

##
## Features on which operations are performed ##
##

set.seed(1234)
train <- head(match15Adv,45000)
test  <- tail(match15Adv,3666)

extractFeatures <- function(data) {
  features <- c("RadiantXpAdv","RadiantGoldAdv","RadiantGoldSD","RadiantGoldMAD","RadiantXpSD","RadiantXpMAD")
  fea <- data[,features]
  return(fea)
}

##
##  Training the model ##
##
rf <- randomForest(extractFeatures(train),as.factor(train$radiant_win), ntree=100, importance = TRUE,keep.forest=TRUE)

submission <- data.frame(match_id = test$match_id)
submission$WinPct <- 1-predict(rf,extractFeatures(test), type="prob")
write.csv(submission , file = "dotapredict.csv", row.names = FALSE)

imp <- importance(rf,type=1)
featureImportance <- data.frame(Feature = row.names(imp), Imporance = imp[,1])
##
## Model Evaluation ##
##
aucData <- merge(submission, match15Adv, by ="match_id")
aucData$radiant_win <- lapply(aucData$radiant_win, as.numeric) 

pred <- prediction(unname(aucData$WinPct[,1]),unlist(data.matrix(aucData$radiant_win)))
auc.tmp <- performance(pred,"auc")
auc <- as.numeric(auc.tmp@y.values)

perf <- performance(pred, measure = "tpr", x.measure = "fpr") 

plot(perf)


##Corelation win Percentage vs True Skill 

library(ggplot2) 
library(readr) 
setwd("~/dota-2-matches")
##
## True Skill Values ##
##
players_rating  <- read.table('player_ratings.csv',   header=TRUE, row.names=NULL,sep = ",", fill = TRUE)
idxReliable     <- players_rating$total_matches >= 50

##
## Checking the correlation for the variable  ##
##

pct         <- players_rating[idxReliable,"total_wins"] / players_rating[idxReliable,"total_matches"]
rating      <- players_rating[idxReliable,"trueskill_mu"]
correlation <- cor(pct,rating)

##
## Plotting the correlation ##
##

plot(pct,rating)
print(correlation)

##training
train_feat_comp.drop(['account_id'], axis=1, inplace=True)
test_feat_comp.drop(['account_id'], axis=1, inplace=True)
def unstack_simplify(df):
    return df.unstack().iloc[10:].reset_index(drop=True)
test_feat_group = test_feat_comp.groupby('match_id')
test_feats = test_feat_group.apply(unstack_simplify)
train_feat_group = train_feat_comp.groupby('match_id')
train_feats = train_feat_group.apply(unstack_simplify)

for i in range(0,40, 10):
    print(test_feats.iloc[0,i:i+10],'\n')
row_nans = test_feats.isnull().sum(axis=1)
nan_counts = row_nans.value_counts()
nan_counts = nan_counts.reset_index()

nan_counts.columns = ['num_missing_players','count']
nan_counts.loc[:, 'num_missing_players'] =(nan_counts.loc[:,'num_missing_players']/12).astype(int)
nan_counts

##model building 
rf = ensemble.RandomForestClassifier(n_estimators=150, n_jobs=-1)
rf.fit(train_feats,train_labels) 



test_feats.replace(np.nan, 0, inplace=True)

test_probs = rf.predict_proba(test_feats)
test_preds = rf.predict(test_feats)
metrics.log_loss(test_labels.values.ravel(), test_probs[:,1])
metrics.roc_auc_score(test_labels.values, test_probs[:,1])
print(metrics.classification_report(test_labels.values, test_preds))