
############################################################
#                                                          #
#                       Overfitting                        #
#                                                          #
############################################################

# # Abstract	

# This exercise will demonstrate how overfitting can lead to bad decisions about the importance of predictors and goodness of fit of models. The basic idea is that by providing too much flexibility for the model, we allow it to fit to the sample it is being trained on too well. However, this close fit to the sample will also fit some of the patterns that are only present in our sample (due to the sampling error), and are not present in the whole population. 	

# # Data management and descriptive statistics	

# ## Loading packages	

# You will need to load the following packages for this exercise:	


library(tidyverse) # for tidy format	


# ## Load data about housing prices in King County, USA 	

# In this exercise we will predict the price of apartments and houses. 	

# We use a dataset from Kaggle containing data about housing prices and variables that may be used to predict housing prices. This dataset contains house sale prices for King County, USA (Seattle and sorrounding area) which includes Seattle. It includes homes sold between May 2014 and May 2015. More info about the dataset here: https://www.kaggle.com/harlfoxem/housesalesprediction	

# We only use a portion of the full dataset now containing information about N = 200 accomodations.	

# You can load the data with the following code	


data_house = read_csv("https://bit.ly/2DpwKOr")	


# ## Check the dataset	

# You should always get familiar with the dataset you are usung, and check for any inconsistencies that need to be corrected.	

# In the code below we convert the area metrics that are in square feet in the original dataset to square meters. We also specify that the variable has_basement is a factor.	


data_house = data_house %>% 	
  mutate(price_thsnd_USD = round(price/1000, 0),	
         sqm_living = sqft_living * 0.09290304,	
         sqm_lot = sqft_lot * 0.09290304,	
         sqm_above = sqft_above * 0.09290304,	
         sqm_basement = sqft_basement * 0.09290304,	
         sqm_living15 = sqft_living15 * 0.09290304,	
         sqm_lot15 = sqft_lot15 * 0.09290304,	
         has_basement = factor(has_basement))	
	
data_house %>% 	
  summary()	


# # Overfitting	

# ## First rule of model selection:	

# **Always use the model that is grounded in theory and prior research, result-driven model selection can lead to bad predictions on new datasets due to overfitting!**	


# "Predicting" variability of the outcome **in your original data** is easy	
# If you fit a model that is flexible enough, you will get perfect fit on your intitial data.	

# For example you can fit a line that would cover your data perfectly, reaching 100% model fit... to a dataset where you already knew the outcome.	

# See the example "prediction line" below.	


data_house %>% 	
 ggplot() +	
  aes(y = price_thsnd_USD, x = sqm_living) +	
  geom_point(size = 3) +	
  geom_line()	
  	



# However, when you try to apply the same model to new data, it will produce bad model fit. In most cases, worse, than a simple regression.	

# ## Comparing model performance on the training set and the test set	

# In this context, data on which the model was built is called the training set, and the new data where we test the true prediction efficiency of a model is called the test set. The test set can be truely newly collected data, or it can be a set aside portion of our old data which was not used to fit the model.	

# Linear regression is very inflexible, so it is less prone to overfitting. This is one of its advantages compared to more flexible prediction approaches.	

# In the next part of the exercise we will demonstrate that the more predictors you have, the higher your R^2 will be, even if the predictors have nothing to do with your outcome variable.	

# First, we will generate some random variables for demonstration purposes. These will be used as predictors in some of our models in this exercise. It is important to realize that these variables are randomly generated, and have no true relationship to the sales price_thsnd_USD of the apartments. Using these random numbers we can demonstrate well how people can be mislead by good prediction performance of models containing many predictors.	


rand_vars = as.data.frame(matrix(rnorm(mean = 0, sd = 1, n = 50*nrow(data_house)), ncol = 50))	
data_house_withrandomvars = cbind(data_house, rand_vars)	


# We create a new data object from the first half of the data (N = 100). We will use this to fit our models on. This is our training set. We set aside the other half of the dataset so that we will be able to test prediction performance on it later. This is called the test set.	


training_set = data_house_withrandomvars[1:100,] # training set, using half of the data	
test_set = data_house_withrandomvars[101:200,] # test set, the other half of the dataset	


# Now we will perform a hierarchical regression where first we fit our usual model predicting price_thsnd_USD with sqm_living and grade on the training set. Next, we fit a model containing sqm_living and grade and the 50 randomly generated variables that we just created.	

# (the names of the random variables are V1, V2, V3, ...)	


mod_house_train <- lm(price_thsnd_USD ~ sqm_living + grade, data = training_set)	
mod_house_rand_train  <- lm(price_thsnd_USD ~ sqm_living + grade+ V1 + V2 + V3 + V4 + V5 + V6 + V7 + 	
                              V8 + V9 + V10 + V11 + V12 + V13 + V14 + V15 + V16 + V17 + 	
                              V18 + V19 + V20 + V21 + V22 + V23 + V24 + V25 + V26 + V27 + 	
                              V28 + V29 + V30 + V31 + V32 + V33 + V34 + V35 + V36 + V37 + 	
                              V38 + V39 + V40 + V41 + V42 + V43 + V44 + V45 + V46 + V47 + 	
                              V48 + V49 + V50,	
                            data = training_set)	


# Now we can compare the model performance.	
# First, if we look at the normal R^2 indexes of the models or the RSS, we will find that the model using the random variables (mod_house_rand_train) was much better at predicting the training data. The error was smaller in this model, and the overall variance explained is bigger. You can even notice that some of the random predictors were identified as having significant added prediction value in this model, even though they are not supposed to be related to price_thsnd_USD at all, since we just created them randomly. This is because some of these variables are alligned with the outcome to some extend by random chance.	


summary(mod_house_train)	
summary(mod_house_rand_train)	
	
pred_train <- predict(mod_house_train)	
pred_train_rand <- predict(mod_house_rand_train)	
RSS_train = sum((training_set[,"price_thsnd_USD"] - pred_train)^2)	
RSS_train_rand = sum((training_set[,"price_thsnd_USD"] - pred_train_rand)^2)	
RSS_train	
RSS_train_rand	


# That is why we need to use model fit indexes that are more sensitive to the number of variables we included as redictors, to account for the likelyhood that some variables will show a correlation by chance. Such as adjusted R^2, or the AIC. The anova() test is also sensitive to the number of predictors in the models, so it is not easy to fool by adding a bunch of random data as predictors. Better yet, the AIC indicates that smaller model is significantly better than the more complicated model.	


summary(mod_house_train)$adj.r.squared	
summary(mod_house_rand_train)$adj.r.squared	
	
AIC(mod_house_train)	
AIC(mod_house_rand_train)	
	
anova(mod_house_train, mod_house_rand_train)	




# ## Result-based models selection	

# (Result-based models selection is only shown here with demonstration purposes, to show how it can mislead researchers. Whenever possible, stay away from using such approaches, and rely on theoretical considerations and previous data when building models.)	

# After seeing the performance of mod_house_rand_train, and not knowing that it contains random variables, one might be tempted to build a model with only the predictors that were identified as having a significant added predictive value, to improve the model fit indices (e.g. adjusted R^2 or AIC). And that would achieve exactly that: it would result in the virtual improvement of the indexes, but not the actual prediction efficiency, so the better indexes would be just an illusion resulting from the fact that we "concealed" from the statistical tests that we have tried to use a lot of predictors in a previous model.	

# Excluding variables that seem "useless" based on the results will blind the otherwise sensitive measures of model fit. This is what happens when using automated model selection procedures, such as backward regression.	

# In the example below we use backward regression. This method first fits a complete model with all of the specified predictors, and then determins which predictor has the smallest amount of unique added explanatory value to the model, and excludes it from the list of predictors, refitting the model without this predictor. This procedure is iterated until until there is no more predictor that can be excluded without significantly reducing model fit, at which point the process stops. 	


mod_back_train = step(mod_house_rand_train, direction = "backward")	


# The final model with the reduced number of predictors will have much better model fit indexes than the original compex model, because the less useful variables were excluded, and only the most influential ones were retained, resulting in a small and powerful model. Or at least this is what the numbers would suggest us on the training set.	

# Lets compare the prediction performance of the final model returned by backward regression (mod_back_train) with the model only containing our good old predictors, sqm_living and grade (mod_house_train) on the training set.	


anova(mod_house_train, mod_back_train)	
	
summary(mod_house_train)$adj.r.squared	
summary(mod_back_train)$adj.r.squared	
	
AIC(mod_house_train)	
AIC(mod_back_train)	


# All of the above model comparison methods indicate that the backward regression model (mod_back_train) performs better. We know that this model can't be too much better than the smaller model, since it only contains a number of randomly generated variables in addition to the two predictors in the smaller model. So if we would only rely on these numbers, we would be fooled to think that the backward regression model is better.	


# ## Testing performance on the test set	

# A surefire way of determining actual model performance is to test it on new data, data that was not used in the "training" of the model. Here, we use the set aside test set to do this.	

# Note that we did not re-fit the models on the test set, we use the models fitted on the training set to make our predictions using the predict() function on the test_set!!!	


# calculate predicted values 	
pred_test <- predict(mod_house_train, test_set)	
pred_test_back <- predict(mod_back_train, test_set)	
	
# now we calculate the sum of squared residuals 	
RSS_test = sum((test_set[,"price_thsnd_USD"] - pred_test)^2)	
RSS_test_back = sum((test_set[,"price_thsnd_USD"] - pred_test_back)^2)	
RSS_test	
RSS_test_back	


# This test reveals that the backward regression model has more error than the model only using sqm_living and grade.	

# ## BOTTOM LINE 	
# 1. Model selection should be done pre-analysis, based on theory, previous results from the literature, or conventions on the field. Post-hoc result-driven predictor selection can lead to overfitting. 	
# 2. The only good test of a model's true prediction performance is to test the accuracy of its predictions on new data (or a set-asid test set using the above described training-set test-set approach)	
