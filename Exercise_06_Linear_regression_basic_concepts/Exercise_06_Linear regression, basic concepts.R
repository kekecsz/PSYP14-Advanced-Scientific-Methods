
############################################################
#                                                          #
#              Basics of linear regression                 #
#                                                          #
############################################################

# # Abstract	

# This exercise is related to learning the basic logic behind making predictions with linear regression models, and to quantifying the effectiveness of our predictions.	

# # Data management and descriptive statistics	

# ## Loading packages	

# You will need to load the following packages for this exercise:	


library(psych) # for describe	
library(tidyverse) # for tidy code	


# ## Custom functions	

# The following custom functions will come in handy during the visualization of the error of the predictions of the regressions line. This is not essential for the analysis and you don't need to learn how this custom function works if you don't want to. 	


	
	
error_plotter <- function(mod, col = "black", x_var = NULL){	
  mod_vars = as.character(mod$call[2])	
  data = as.data.frame(eval(parse(text = as.character(mod$call[3]))))	
  y = substr(mod_vars, 1, as.numeric(gregexpr(pattern ='~',mod_vars))-2)	
  x = substr(mod_vars, as.numeric(gregexpr(pattern ='~',mod_vars))+2, nchar(mod_vars))	
  	
  data$pred = predict(mod)	
  	
  if(x == "1" & is.null(x_var)){x = "response_ID"	
  data$response_ID = 1:nrow(data)} else if(x == "1"){x = x_var}	
  	
  plot(data[,y] ~ data[,x], ylab = y, xlab = x)	
  abline(mod)	
  	
  for(i in 1:nrow(data)){	
    clip(min(data[,x]), max(data[,x]), min(data[i,c(y,"pred")]), max(data[i,c(y,"pred")]))	
    abline(v = data[i,x], lty = 2, col = col)	
  }	
  	
}	


# ## Get some data	

# Lets say we are a company that sells shows, and we would like to be able to tell people's shoe size just by knowing their height. Maybe because our branch is located at a place with lots of tourists, who do not know their european shoe size.	

# You can load the data we just collected with the following code	


# alternative download link: https://raw.githubusercontent.com/kekecsz/PSYP13_Data_analysis_class-2018	
# /master/Shoe%20and%20height%20data%20PSYP13-HT18.csv	
mydata = as_tibble(read.csv("https://tinyurl.com/shoesize-data-1"))	


# ## Check the dataset for irregularities	

# You should always check the dataset for coding errors or data that does not make sense.	

# View data in the data viewer tool 	

View(mydata)	


# and display simple descriptive statistics and plots.	

# You can investigate the structure of the dataset with the str() function, use the summary() function to get a basic overview. 	


	
mydata %>% 	
  summary()	


# Visualization is also key in checking and exploring data.	


	
mydata %>% 	
  ggplot() +	
  aes(x = height) +	
  geom_histogram()	
	
mydata %>% 	
  ggplot() +	
  aes(x = shoe_size) +	
  geom_histogram()	
	
mydata %>% 	
  ggplot() +	
  aes(y = shoe_size, x = height) +	
  geom_point()	
	




# # Prediction with linear regressioin	
# ## how to set up and interpret simple regression	

# Regression is all about predicting or etimating an outcome by knowing the value of predictor variables that are associated with the outcome.	

# You can set up a simple regression model by using the code below.	
# In the code we first specify an object where the results will be saved (mod1), then we specify the regression formula. In the formula, we start with specifying the outcome variable, what we are interested in predicting (shoe_size), then, after a ~ we specify the predictors. In simple regresison we only have one predictor (here this is height), but we could add more predictor variables, spearated with a + sign. In the end of the code we specify the data file where these variables originate from. Remember to use the cleaned dataset (mydata).	



mod1 <- lm(shoe_size ~ height, data = mydata)	


# In simple regression, we identifies the underlying pattern of the data, by fitting a single straight line that is closest to all data points.	


mydata %>% 	
  ggplot() +	
  aes(x = height, y = shoe_size) +	
  geom_point() +	
  geom_smooth(method = "lm", se = F)	


# Regression provides a matematical equation (called the regression equation) with which you can predict the outcome by knowing the value of the predictors.	

# The **regression equation** is formalized as: Y = b0 + b1*X1, where Y is the predicted value of the outcome, b0 is the intercept, b1 is the regression coefficient for predictor 1, and X1 is the value of predictor 1. 	


mod1	


# This means that the regression equiation for predicting shoe size is:	

# shoe size = `r round(mod1[[1]][1], 2)` + `r round(mod1[[1]][2], 2)` * height	

# that is, for a person who is 170 cm tall, the predicted shoe size is calcluated this way:	

# `r round(mod1[[1]][1], 2)` + `r round(mod1[[1]][2], 2)` * 170 = `r round(mod1[[1]][1], 2) + (round(mod1[[1]][2], 2) * 170)`	

# You don't have to do the calculations by hand, you can get the predicted values by using the predict() function.	

# The predictors have to have the same variable name as in the regression formula, and they need to be in a data.frame or tibble object.	


height = c(150, 160, 170, 180, 190)	
height_df = as_tibble(height)	
	
predictions = predict(mod1, newdata = height_df)	
	
height_df_with_predicted = cbind(height_df, predictions)	
height_df_with_predicted	


# Predicted values all fall on the regression line	


	
mydata %>% 	
  ggplot() +	
  aes(x = height, y = shoe_size) +	
  geom_point() +	
  geom_point(data = height_df_with_predicted, aes(x = value, y = 	
                                                    predictions), col = "red", size = 7) +	
  geom_smooth(method = "lm", formula = 'y ~ x', se = F)	
  	




# *______Practice_______*	

# 1. Load the mtcars dataset by running data(mtcars). This way you will have a data.frame object called mtcars in your workspace. (This data is a built in dataset in R that was extracted from the 1974 Motor Trend US magazine, and comprises fuel consumption and 10 aspects of automobile design and performance for 32 automobiles. You can get more infor on it by running ?mtcars)	
# 2. Build a simple linear regression model using the lm() function where **mpg** (miles per gallon) is the outcome variable and **hp** (raw hourse power) is the predictor. Save the output of the model into a new object.	
# 3. Write down the regression equation for estimating mpg	
# 4. Interpret the regression equation. Cars with higher hoursepower would have lower or higher miles per gallon? How much higher mpg is predicted for each step up on hp?	
# 5. Create a scatterplot of the relationship of mpg and hp including the regression line and use the plot to verify your interpretation from before.	
# 6. Using this model, what is the predicted mpg for cars with hoursepowers of 100, 200, and 300? (you can use the predict() function to answer this question)	

# *________________________*	




# ## How good (or bad) is my model?	

# You can measure how effective your model is by measureing the difference between the actual outcome values and the predicted values. We call this residual error in regression.	

# The residual error for each observed shoe size can be seen on this plot (this will only work if you ran the code in the top of the script containing the error_plotter() custom function). This code is only for visualization purposes.	


error_plotter(mod1, col = "blue")	


# You can simply add up all the residual error (the length of these lines), and get a good measure of the overall efficiency of your model. This is called the residual absolute difference (RAD). However, this value is rarely used. More common is the residual sum of squared differences (RSS). The interpretation is practiacally the same, gives an indication of the total amount of error when using the model.	



RAD = sum(abs(mydata$shoe_size - predict(mod1)))	
RAD	
	
RSS = sum((mydata$shoe_size - predict(mod1))^2)	
RSS	


# ## Is my model useful?	

# To establish how much benefit did we get by taking into account the predictor, we can compare the residual error when using out best guess (mean) without taking into account the predictor, with the residual error when the predictor is taken into account.	

# Below you can find regression model where we only use the mean of the outcome variable to predict the outcome value.	

# We can calculate the sum of squared differences the same way as before, but for the model without any predictors, we call this the total sum of squared differences (TSS).	


mod_mean <- lm(shoe_size ~ 1, data = mydata)	
	
error_plotter(mod_mean, col = "red", x_var = "height") # visualize error	
	
TSS = sum((mydata$shoe_size - predict(mod_mean))^2)	
TSS	



# The total amount of information gained about the variability of the outcome is shown by the R squared statistic (R^2).	


R2 = 1-(RSS/TSS)	
R2	


# This means that by using the regression model, we are able to explain `r paste(round(R2, 4)*100, "%", sep = "")` of the variability in the outcome.	

# R^2 = 1 means all variablility of the outcome is perfectly predicted by the predictor(s)	

# R^2 = 0 means no variablility  of the outcome is predicted by the predictor(s)	

# ## Is the model with the predictor significantly better than a model without the predictor?	

# You can do an anova to find out, comparing the amount of variance explained by the two models.	


anova(mod_mean, mod1)	


# Or, you can get all this information and more from the model summary	


summary(mod1)	


# The confidence interval of the regression coefficient is given by the confint() function	


confint(mod1)	


# You can also plot the confidence interval of the predictions using geom_smooth() in ggplot()	


	
mydata %>% 	
  ggplot() +	
  aes(x = height, y = shoe_size)+	
  geom_point()+	
  geom_smooth(method="lm")	
	



