
############################################################
#                                                          #
#                   Special predictors                     #
#                                                          #
############################################################

# # Abstract	

# In the previous exercises we used conitnuous predictors and modelled simple linear relationships between the predictors and the outcome without too much concern about the relationship of the predictors on each others effect on the outcome. In this exercise we will expand the array of predictors to categorical variables, interaction terms, and higher order terms.	

# # Data management and descriptive statistics	


# ## Load packages	


library(tidyverse)	
library(psych)	
library(gridExtra)	


# ## Load the weight loss dataset	

# To explore some of the more advanced predictor types, we will need a new dataset. Let's download the weight_loss dataset.	


data_weightloss = read_csv("https://tinyurl.com/weightloss-data")	


# This dataset contains simulated data. It is about a study where different types of interventions were tested to help overweight people to lose weight.	

# Variables:	

# - ID - participant ID	
# - Gender - gender	
# - Age - age	
# - BMI_baseline - Body mass index (BMI) measured before treatment	
# - BMI_post_treatment - Body mass index (BMI) measured after treatment	
# - treatment_type - The type of treatment in the group to which the participant was randomized to. Levels:	
	
# 1. no treatment	
# 2. pill - medication which lowers apetite	
# 3. psychotherapy - cognitive behavioral therapy	
# 4. treatment 3 - a third kind of treatment (see below) 	

# - motivation - self report motivation to lose weight (on a 0-10 scale from extremely low motivation to extremely high motivation)	
# - body_acceptance - how much the person feels that he or she is satisfied with his or her body. (on a scale of -7 to +7 from very unsatisfied to very satisfied)	




# ## check data	

# Lets explore the dataset we will use	


data_weightloss %>% 	
  summary()	
	
describe(data_weightloss)	


# Now lets run some more focused exploratory analysis on the variables of interest. In this exercise we would like to understand the effect of the different treatment types on BMI.	


fig_1 = data_weightloss %>% 	
  ggplot() +	
  aes(y = BMI_baseline, x = treatment_type) +	
  geom_boxplot()+	
  ylim(c(20, 45))	
	
fig_2 = data_weightloss %>% 	
  ggplot() +	
  aes(y = BMI_post_treatment, x = treatment_type) +	
  geom_boxplot()+	
  ylim(c(20, 45))	
	
grid.arrange(fig_1, fig_2, nrow=1)	
	
data_weightloss %>% 	
  group_by(treatment_type) %>% 	
    summarize(mean_pre = mean(BMI_baseline),	
              sd_pre = sd(BMI_baseline),	
              mean_post = mean(BMI_post_treatment),	
              sd_post = sd(BMI_post_treatment))	
	


# ## Categorcial predictors	

# Because it seems that the groups are comparable at baseline, lets focus on the post-treatment BMI.	

# The treatment_type is a categorical variable, while BMI is a numeric continuous variable. Thus, one of the ways in which the relationship of treatment_type and BMI can be explored is **to use a one-way ANOVA** (using the aov() function).	


anova_model = aov(BMI_post_treatment ~ treatment_type, data = data_weightloss)	
sum_aov = summary(anova_model)	
sum_aov	
	



# The result of this test tell us that the mean post-treatment BMI is significantly different among groups (F `r paste("(", unlist(sum_aov)["Df1"], ", ", unlist(sum_aov)["Df2"], ")", sep = "")` =  `r round(unlist(sum_aov)["F value1"], 2)`, `r if(round(unlist(sum_aov)["Pr(>F)1"], 3) == 0){"p < .001"} else {paste("p = ", round(unlist(sum_aov)["Pr(>F)1"], 3), sep = "")}`).	


# In linear regression it is important that the predicted variable be a numeric continuous variable. However, the predictors are not constrained by this, so predictors can be categorical as well. 	

# This means that **we could build** the above one-way ANOVA model **with lm() as well**. 	

# Notice that the result of the full model **F-test is the same** as the result of the aov().	



mod_1 = lm(BMI_post_treatment ~ treatment_type, data = data_weightloss)	
summary(mod_1)	
	


# The regression coefficient table looks different than usual, because instead of having a single row for our predictor, **we have multiple rows**, one for each treatment type (except for one). 	

# ## Interpreting the coefficients table for categorical variables	

# Remember what was the interpretation for the regression coefficents and the intercept from the previous exercises.	

# **The interpretation of the regression coefficients** of the predictors is: this is the amount by which the outcome variable's estimate would change if the predictor's value is increased by 1.	

# **Interpretation of the estimate of the intercept**: if all the predictors in the model would have the value of zero (0), this would be the estimated value for the outcome variable.	

# This interpretation stays the same for every linear model.	

# ### Dummy coding	

# (This is done automatically by R so we do not usually have to do this manually, we do the dummy coding here **as a demonstration**.)	

# However, for nominal predictors (like treatment_type) we do not have a numerical value for the predictor levels by default. To assign numerical value to the different factor levels, we need to **dummy code the categorical predictor**. This basically means that we will **create separate variables representing each level of the categorical variable, except for the default level**. So 	

# - we create a variable (got_pill) that will take the value of 1 if the person got the treatment "pill", and take the value of 0 every other time. 	
# - we create a variable (got_psychotherapy) that will take the value of 1 if the person got the treatment "psychotherapy", and take the value of 0 every other time.	
# - we create a variable (got_treatment_3) that will take the value of 1 if the person got the treatment "treatment_3", and take the value of 0 every other time.	
# - we ususally only create one fewer dummy variables than the number of levels in the categorical predictor, and leave the "default level" of the predictor un-dummied. In our case the "default leve" is "no_treatment", and we would like to compare the effect of each other level to this level.	

# Now if we **fit a regression model using these dummies**, we will see how the results of the previously seen regression output were generated. 	



data_weightloss = data_weightloss %>% 	
  mutate(	
         got_pill = recode(treatment_type,	
                           "no_treatment" = "0",	
                           "pill" = "1",	
                           "psychotherapy" = "0",	
                           "treatment_3" = "0"),	
         got_psychotherapy = recode(treatment_type,	
                           "no_treatment" = "0",	
                           "pill" = "0",	
                           "psychotherapy" = "1",	
                           "treatment_3" = "0"),	
         got_treatment_3 = recode(treatment_type,	
                           "no_treatment" = "0",	
                           "pill" = "0",	
                           "psychotherapy" = "0",	
                           "treatment_3" = "1")	
         )	
	
mod_2 = lm(BMI_post_treatment ~ got_pill + got_psychotherapy + got_treatment_3, data = data_weightloss)	
summary(mod_2)	
	
	


# This model produces the **same results as the model above** where we entered the variable name of the categorical predictor directly into the model, because **the lm() function does all the dummy-ing automatically**. It is important to understnad though **how the "default level" is selected** in this automatic process. It is selected to be the earliest level name in alphabetic order.	

# Now we can use the **same interpretation that we are used to for the regression coefficients** in the coefficient table: The intercept is the value of the outcome if every predictor's value is zero (this basically means that this is the predicted value of the outcome variable at the "default level". The coefficients of the predictors show the amount of change in the outcome variable's value if the given predictor's value increases by 1 point. This can happen for "got_pill" if the person got the treatment "pill". **This change is always in relation to the default level**.	

# So in our example: 	

# - In case of "no_treatment" we can expect a post-test BMI of `r round(coef(mod_2)["(Intercept)"], 2)`,	
# - if someone got "pill" treatment instead, we expect a BMI `r round(coef(mod_2)["got_pill1"], 2)` difference compared to the intercept, 	
# - if someone got "psychotherapy" treatment instead, we expect a BMI `r round(coef(mod_2)["got_psychotherapy1"], 2)` difference compared to the intercept	
# - if someone got "treatment_3" treatment instead, we expect a BMI `r round(coef(mod_2)["got_treatment_31"], 2)` difference compared to the intercept	


# *__________Practice___________*	

# Open the house sale dataset from the previous exercise and build a regression model where we predict the sales price with sqm_living, grade, has_basement as predictors. has_basement is a categorical predictor with two levels: "has basement" and "no basement". Interpret the regression coefficents based on the description above. Pay attention to what is the default level and why in order to be able to interpret the meaning of the values correctly.	

# How much more or less can a person expect to get for their apartment if it has a basement?	

# How would you interpret the intercept in this model?	




data_house = read.csv("https://bit.ly/2DpwKOr")	
	
data_house = data_house %>% 	
  mutate(sqm_living = sqft_living * 0.09290304,	
         sqm_lot = sqft_lot * 0.09290304,	
         sqm_above = sqft_above * 0.09290304,	
         sqm_basement = sqft_basement * 0.09290304,	
         sqm_living15 = sqft_living15 * 0.09290304,	
         sqm_lot15 = sqft_lot15 * 0.09290304,	
         has_basement = factor(has_basement))	
	
	




# *______________________________*	


# ## Introducing interaction terms into the model	

# **treatment_3** is actually a condition where the **person got both pill and psychotherapy** treatments at the same time.	

# Lets **recode** the got_pill and got_psychotherapy variables to correctly represent this.	


data_weightloss = data_weightloss %>% 	
  mutate(	
         got_pill = replace(got_pill, treatment_type == "treatment_3", "1"),	
         got_psychotherapy = replace(got_psychotherapy, treatment_type == "treatment_3", "1")	
         )	
	


# Now we can answer the question whether there is an **interaction between the pill and the psychotherapy treatments**. That is, can we expect a **different effect of one of these predictors on the outcome depending on the value of the other predictor** (for example a multiplicative effect), or are the effects completely independent from each other (this would represent a simple additive effect).	

# We can **enter the interaction term into the model** by using a * isntead of a + between the predictors we want to include the interaction of.	


mod_3 = lm(BMI_post_treatment ~ got_pill * got_psychotherapy, data = data_weightloss)	
summary(mod_3)	
	


# Now we have **a new predictor in our model**, which is basically the **product of** got_pill * got_psychotherapy. The interpretation of the regression coefficient for the interaction term is the same as before, that is: if the product of  got_pill and got_psychotherapy increases by 1, we can expect this change in the value of the predicted variable. 	

# We need to realize that this also means that **the value of got_pill and/or the value of got_psychotherapy also needs to change** (to produce a change in the product), so the effect of change in the original predictors,also called **the "main effect" is already factored in**, meaning that the coefficient of the interaction term can be **interpreted as the unique effect of the interaction** of the two predictors not including the "main effect" of the predictors alone.	

# In our example this means that:	

# - In case of "no_treatment" we can expect a post-test BMI of `r round(coef(mod_2)["(Intercept)"], 2)`,	
# - The main effect of getting pill treatment on BMI is `r round(coef(mod_3)["got_pill1"], 2)` 	
# - The main effect of getting psychoterapy treatment on BMI is `r round(coef(mod_3)["got_psychotherapy1"], 2)` 	
# - the interaction effect of pill and psychotherapy is `r round(coef(mod_3)["got_pill1:got_psychotherapy1"], 2)`	


# *__________Practice___________*	

# Build a new model where you predict **BMI_post_treatment** with the predictors **motivation** and **body_acceptance**. Interpret the coefficients. How much change in BMI can a person expect if the level of motivation is increased by 1? How much change in BMI can a person expect if the level of body_acceptance is increased by 1? Is there a significant interaction between the two predictors? How is the coefficient of the interaction term interpreted?  	


# *______________________________*	



# ## Including higher order terms in regression models to model non-linear relationships	

# Let's build a linear regression model with body_acceptance as a predictor of post-treatment BMI the usual way.	


mod_4 = lm(BMI_post_treatment ~ body_acceptance, data =  data_weightloss)	
summary(mod_4)	
	


# The coefficient table tells us that with every step up the value of body_acceptance, we can expect `r round(coef(mod_4)["body_acceptance"], 2)` change in BMI post treatment (so the more satisfied the person is with their body at baseline, the higher the BMI will be at post-test, note that this is probably because of the higher baseline BMI of those who are less satisfied with their body to begin with).	

# The output tells us that this model is significantly better than a null model (F `r paste("(", round(summary(mod_4)$fstatistic[2]), ", ", round(summary(mod_4)$fstatistic[3]), ")", sep = "")` =  `r round(summary(mod_4)$fstatistic[1], 2)`, `r if(round(pf(summary(mod_4)$fstatistic[1],summary(mod_4)$fstatistic[2],summary(mod_4)$fstatistic[3],lower.tail=F), 3) == 0){"p < .001"} else {paste("p = ", round(pf(summary(mod_4)$fstatistic[1],summary(mod_4)$fstatistic[2],summary(mod_4)$fstatistic[3],lower.tail=F), 3), sep = ")")}`, Adj. R^2 = `r round(summary(mod_4)$adj.r.squared, 2)`, AIC = `r round(AIC(mod_4), 2)`). This means that taking into account body acceptance adds significant predictive power to the model (this being the only predictor).	

# However, the variance explained by this model is mediocre, explaining only `r round(summary(mod_4)$adj.r.squared, 2)*100`% of the variance.	

# Let's explore this relationship with a scatterplot.	


data_weightloss %>% 	
  ggplot() +	
  aes(y = BMI_post_treatment, x = body_acceptance) +	
  geom_point()	


# This scatterplot indicates that there might be **a non-linear relationship** between BMI and body acceptance. 	

# Linear models are originally designed to model linear relationships between predictors and outcomes, but with a little matematical trick we can model non-linear relationships as well. In order to do this, we need to incluide the higher order terms of the predictor in the model as well. 	

# This can be included in the model by **adding + I(body_acceptance^2)**.	

# Baed on the model summary and the model fit indices, this model fits the data better, and explains more of the variability of the predicted variable (BMI). 	



mod_5 = lm(BMI_post_treatment ~ body_acceptance + I(body_acceptance^2), data =  data_weightloss)	
summary(mod_5)	
	
AIC(mod_4)	
AIC(mod_5)	
	


# It is important to **include all of the lower order terms as well** in the model if we include higher order terms, for the model to work as intended.	


mod_6 = lm(BMI_post_treatment ~ body_acceptance + I(body_acceptance^2)+ I(body_acceptance^3), data =  data_weightloss)	
summary(mod_6)	
AIC(mod_6)	


# Here is the **regression line** for the model with the **first order term only**:	


data_weightloss = data_weightloss %>% 	
  mutate(pred_mod_4 = predict(mod_4),	
         pred_mod_5 = predict(mod_5),	
         pred_mod_6 = predict(mod_6))	
	
data_weightloss %>% 	
  ggplot() +	
  aes(y = BMI_post_treatment, x = body_acceptance) +	
  geom_point() +	
  geom_line(aes(y = pred_mod_4))	


# The model with the **first and the second order term**:	


data_weightloss %>% 	
  ggplot() +	
  aes(y = BMI_post_treatment, x = body_acceptance) +	
  geom_point() +	
  geom_line(aes(y = pred_mod_5))	


# The model with the **first, second, and third order terms**:	


data_weightloss %>% 	
  ggplot() +	
  aes(y = BMI_post_treatment, x = body_acceptance) +	
  geom_point() +	
  geom_line(aes(y = pred_mod_6))	


# It is apparent from the graphs that **the more higher order terms we include, the more flexibility we allow** for the regression line. Specifically, the we allow for one less inflection points for the line.	

# However, too much flexibility can be bad for our models performance on new data. **The more flexibility we allow, the higher the chance for "overfitting" the model** to the dataset the model is trained on, which makes it less effective in correctly esitmating the outcome on new datasets from the same population. For this reason, we usually don't use higher order terms unless there is a good theoretical grounding for there to be a non-linear effect, and even then, we usually do not include hiher order terms than three.	



# *__________Practice___________*	

# Open the house sale dataset from the previous exercise. Experiment with different models based on your theories about what could influence housing prices.	

# Try to increase the adjusted R^2 above 54%.	

# If you want to get access to the whole dataset or get ideas on which model works best, go to Kaggle, check out the top kernels, and download the data.	
# https://www.kaggle.com/harlfoxem/housesalesprediction/activity	


data_house = read.csv("https://bit.ly/2DpwKOr")	
	
data_house = data_house %>% 	
  mutate(sqm_living = sqft_living * 0.09290304,	
         sqm_lot = sqft_lot * 0.09290304,	
         sqm_above = sqft_above * 0.09290304,	
         sqm_basement = sqft_basement * 0.09290304,	
         sqm_living15 = sqft_living15 * 0.09290304,	
         sqm_lot15 = sqft_lot15 * 0.09290304,	
         has_basement = factor(has_basement))	
	
	


# *______________________________*	


