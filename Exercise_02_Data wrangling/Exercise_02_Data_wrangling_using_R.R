############################################################
#                                                          #
#                     Data wrangling	                     #
#                                                          #
############################################################


# ## Abstract	
# 	
# This exercise teaches the most useful functions for data management in R. It shows how to read data, how to create a dataframe, how to refer to specific segments of the dataset (subsetting), and how can we modify the dataset.	
# 	
# # Understanding data	
# 	
# ## Built-in datasets in R	
# 	
# R has some built-in datasets in some of the packages. These are excellent for learning some of the basic functions related to data management.	
# 	
# Now we will use one of these built-in datasets called **USArrests**, which contains information about the number of criminal arrests made in the USA in 1973 for different criminal charges. These statistics (number of arrests per 100,000 population) are shown by States, and the dataset also contains the percentage of urban population in the given State.	
# 	
# 	
# ## Viewing raw data and meta-data	
# 	
# The three main ways of getting a first overview of a dataset is to 	
# - simply **print** the data object	
# - use the **View()** function (note that the first V is capitalized!) to get the raw data in R's built in data viewer	
# - using the **?function** command. This is a very useful function that displays the documentation of a given function or built in object. 	
# Let's use these functions now to learn more about the built-in dataset **USArrests**:	
# 	
# 	
# 	
View(USArrests)	

USArrests	

?USArrests	

# 	
# 	
# ## Basic functions to understand the structure and contents of a database	
# 	
# Although taking a look at the raw data is often useful, and we should always do this when we first encounter the dataset, it is often not very easy to extract some types of intformation from just looking at the raw data. There are multiple functions in R that lets us get more distilled information about the structure of a dataset.	
# 	
# - **length**: number of elements in a vector (not usable for data frames)	
# - **str()**: Shows the class of the object, the number of rows and columns, and the type of each variable/column in the dataset.	
# - **names()** : displays the column names/headers	
# - **row.names()**: displays the row names	
# - **nrow()**: number of rows in the dataset	
# - **ncol()**: number of columns in the dataset	
# - **head()**: lists the first x rows in the dataset (by default, 6 rows)	
# - **tail()**: lists the last x rows in the dataset (by default, 6 rows)	
# 	
# 	
# 	
length(1:10)	

str(USArrests) 	

names(USArrests)	

row.names(USArrests)	

nrow(USArrests)	

ncol(USArrests)	
# 	
# 	
# 	
head(USArrests)	

tail(USArrests, 10)	
# 	
# 	
# 	
# 	
# ## Subsetting: Referencing specific segments of the dataset	
# 	
# Sometimes we only want to work with a specific segment of the dataset, not the whole dataset. For example we might want to see the average number associated with arrests for murder in the US in 1973 in the USArrests dataset. We can use the **mean()** function to get the average, but the input of the mean function needs to be a numerical vector, so if we simply run mean(USArrests) this will give an Error message. We need to somehow extract the **"Murder"** row of the dataset and feed it into the mean() function.	
# 	
# There are multiple ways for doing this. Today we are going to lear three of these methods.	
# 	
# The first method is by using **the $ sign** as in the following example. This leads to a clean code, but it doesn't have a lot of versitility when it comes to referencing multiple variables or rows.	
# 	
# 

USArrests$Murder

class(USArrests$Murder)	
is.vector(USArrests$Murder)	

mean(USArrests$Murder)	

# 	
# The second method is called **subsetting with brackets**. Here we put brackets after the object name, and we specify the rowns and or columns we want to access within the brackets. The following code does the same thing that we did with the $ operator.	
# 	
# 	
USArrests[,"Murder"]	
class(USArrests[,"Murder"])	
is.vector(USArrests[,"Murder"])	

mean(USArrests[,"Murder"])	
# 	
# 	
# If you are subsetting a vector, you only have a single dimension to worry about, but when we are working with data frames, we often need to specify which rows and which columns we are interested in. Subsetting with brackets allows this. **Inside the brackets, we can first refer to rows, and after a coma, we can select columns.** If we leave one of the dimensions empty, R interprets that as "I want all of that dimension".	
# 	
# For example USArrests[2, "Murder"] means that I want to work with the second row of the dataset and only the "Murder" column. Basically selecting a single observation/cell within the dataset.	
# 	
# Here are a few other examples for better understanding of how this works. (Note that the **c() function** can be used within the brackets to indicate multiple rows or columns). Both rows and columns can be **referenced by either their number or their name**.	
# 	
# 	
USArrests[5, "Assault"]	
USArrests[c("Illinois", "Arkansas"), "UrbanPop"]	
USArrests[c("Illinois", "Arkansas"), 2:4]	
# 	
# 	
# Subsetting with brakets also allows us to **exclude** segments of the dataset. This is usually handled by using the "-" sign like in the example below. Here we exclude all rows between 4-to-50 from the dataset, basically only leaving the first 3 rows.	
# 	
# 	
USArrests[-c(4:50),]	
# 	
# 	
# The following command also excludes the second column. 	
# 	
# 	
USArrests[-c(4:50),-2]	
USArrests[-c(4:50),-which(names(USArrests) == "Assault")]	
# 	
# 	
# Negative subsetting (exclusion) works a bit awkwardly if we want to use names, especially if we want to exclude multiple named columns/rows. But it is doable if necessary using the %in% (within) operator. So the followign lines of code are equvivalent:	
# 	
# 	
USArrests[-c(4:50),-which(names(USArrests) %in% c("Murder", "Assault"))]	
USArrests[-c(4:50),-c(1,2)]	
# 	
# 	
# Whenever possible **use names instead of row/column numbers** to reference for subsetting, because this makes for a more transparent/ human readable code.	
# 	
# 	
# *_________________Practice__________________*	
# 	
# 1. Assign therow names of **USArrests** into an object named **row_names**	
# 2. Using a function determine the number of elements of this new object.	
# 3. What is the class of this object?	
# 4. Create a new data frame which only contains the "UrbanPop" and "Rape" columns. Name the new object **USArrests_UrbanPop_Rape**	
# 5. List the final 8 rows of the **USArrests_UrbanPop_Rape** object	
# 6. Display the UrbanPop values for "Colorado" and "Mississippi" States.	
# 	
# *____________________________________________*	
# 	
# 	
# # Tidyverse	
# 	
# Data managment in the R community is often referred to as **Data wrangling**. Data wrangling is not a trivial process using base R functions, it often results in very coplicated code that is hard to decipher, and can take the better half of the total time spent on data analysis.	
# 	
# **tidyverse** is a package collection that is specifically designed to make data wrangling easier and to make the code very clear.	
# 	
# First, lets install tidyverse using the install.packages() function as learned before, and lets load the package. The installation process can take a while since it installs several different pacakges.	
# 	
# 	
library(tidyverse)	
# 	
# 	
# Now lets create a numerical vector with a bunch of numbers.	
# 	
# 	
x <- c(55:120, 984, 552, 17, 650)	
# 	
# 	
# 	
# ## The %>% (pipe operator) 	
# 	
# One of the core elements of **tidy programming** is the %>% (**pipe operátor**). The pipe was invented to allow the easily linking multiple functions in a chain hading the results of previous functions successively to the next functions. And to make all this very clean and simple to read in the code.	
# 	
# For exmaple if we want to get the logarithm on with base 10 of the mean of the above numerical vector, and we want to round the result to a single digit precision, we could use the base R functions as follows: 	
# 	
# round(log(mean(x)), digits = 1). 	
# 	
# However, the many parentheses enclosed within each other makes it very hard to clearly see the sequence of this chane of functions even while only three different functions are used. Often we use multiple functions with much more complicated paramater structures, making this significantly harder.	
# 	
# Instead we can use the %>% to hand the product of each function to the next successively, while keeping the code clean. This is also called "chaining functions":	
# 	
# 	
# 	

round(log(mean(x)), digits = 1) # base R	

# the same with tidyverse pipes	
x %>%	
  mean() %>%	
    log() %>% 	
      round(digits = 1)	


# 	
# 	
# We can imagine the %>% pipe as an actual pipe or conveyer belt transporting the products of functions between workstations / production lines.	
# 	
# *- - - - - - - - - - - TIP - - - - - - - - - - - *	
# 	
# 	
# The %>% operator can be produced in R using **Ctrl + Shift + M** for faster typing.	
# 	
# *- - - - - - - - - - - - - - - - - - - - - - - - *	
# 	
# Not all functions are compatible with pipes, but most functions have a tidy-equvivalent version.	
# 	
# For example simple mathematical operators at the beggining of lines usually dont run in pipe chains. 	
# 	
# 	

x %>%	
  mean() %>%	
  log() %>% 	
  round(digits = 1) %>% 	
  -3 %>% 	
  +5 %>% 	
  /2	
# 	
# 	
# but the magrittr package contains the equvivalent subtract(), add(), divide_by() etc. functions that are tidy-compatible. (You might need to install magrittr tfor this to run)	
# 	
# 	
library(magrittr)	


x %>%	
  mean() %>%	
  log() %>% 	
  round(digits = 1) %>% 	
  subtract(3) %>% 	
  add(5) %>% 	
  divide_by(2)	


# 	
# 	
# 	
# ## The four basic functions of dplyr	
# 	
# dplyr is the main workhorse package withtin tidyverse used for data wrangling. The following 4 core functions are a must-know:	
# 	
# - **filter()**: For selecting which observations (rows) to use	
# - **mutate()**: For modifying existing variables (columns) and for creating new ones. 	
# - **group_by()**: For forcing following functions in the chain to be run separately by the specified groups.	
# - **summarise()**: Provides summary results about specific variables using specified functions	
# 	
# ### Exmaples of use:	
# 	
# Now we will use the ToothGrowth dataset to learn how to use these basic functions.	
# 	
# By running the ?ToothGrowth command we can get basic information about this built-in dataset:	
# 	
# *"The response is the length of odontoblasts (cells responsible for tooth growth) in 60 guinea pigs. Each animal received one of three dose levels of vitamin C (0.5, 1, and 2 mg/day) by one of two delivery methods, orange juice or ascorbic acid (a form of vitamin C and coded as VC)."*	
# 	
# The following variables are included in the dataset:	
# 	
# - len (numeric): Tooth length	
# - supp (factor): Supplement type (VC or OJ).	
# - dose (numeric):	Dose of vitamin C in milligrams/day	
# 	
# 	
# **filter()**: Lets select the cases which got vitamin C using orange juice (OJ)	
# 	
# 	
ToothGrowth %>%	
  filter(supp == "OJ")	


# 	
# 	
# **mutate()**: Tooth length is in millimeters now in len. Lets create a new variable where the same data is present but converted to centimeters.	
# 	
# *- - - - - - - - - - - TIP  - - - - - - - - - - *	
# 	
# Importantly, changes to the dataset made by mutate are only saved if we assign it to a new or the original object. Otherwise the functions run, but the result is simply listed in the console and cannot be used later.	
# 	
# *- - - - - - - - - - - - - - - - - - - - - - - - *	
# 	
# Now we will create a new variable called **len_cm** (we could name this variable anything we like)	
# 	
# Note that below we save the result of this code to a new object called **my_ToothGrowth**. It is always preferrable to keep the original raw data in its original form in an object and save modifications under new object names to make it easier to reference and come back to original versions. 	
# 	
# 	
# 	
my_ToothGrowth <- ToothGrowth %>%	
  mutate(len_cm = len / 10)	
# 	
# 	
# **summarise()**: Now lets look at what is the average tooth lenght in centimeters.	
# 	
# 	
my_ToothGrowth %>%	
  summarise(mean_len_cm = mean(len_cm))	
# 	
# Note that I named the output descriptive statistic as mean_len_cm after the summarise() function. It is not strictly necessary to give a name to the output of the summarise() function, but it can make the output that much clearer to interpret, so this is advised.	
# 	
# The **n()** function can be used to count the number of rows. Since this is another descritive statistic, we can add this to the summarise() function after the mean() separated by a ",". In this case the output will be a table including both descriptive statistics. Naming the descriptive outputs has even more values when we have output tables containing multiple data points.	
# 	
# 	
# 	

my_ToothGrowth %>%	
  summarise(mean_len_cm = mean(len_cm),	
            n_cases = n())	
# 	
# 	
# Using **group_by()** we are forcing the functions chained after group_by to run the functions separately for the specified gorups. For example the following code provides the previously shown summary statistics separately for each group within the "supp" variable, so we get separate results for groups VC and OJ.	
# 	
# 	
ToothGrowth %>%	
  mutate(len_cm = len / 10) %>% 	
  group_by(supp) %>%	
  summarise(mean_len_cm = mean(len_cm),	
            cases = n())	
# 	
# 	
# ## Other useful dplyr functions	
# 	
# **select()**: Selecting columns.	
# 	
# We can select specific variables if we only want to use them in the chain moving forward.	
# 	
# Using the "-" sign has the opposite effect, excluding the specified variable for the following functions.	
# 	
# Just like when we use bracket subsetting, we can also use position of the column instead its name for subsetting, but using the name is preferred.	
# 	
# Also note that in the tidyverse functions we don't need to use "" to refer to variables.	
# 	
# The select() function also has helper functions to allow for easier subsetting. Such as starts_with(), which lets you select variables the name of which starts with a specific string.	
# 	
# 	
ToothGrowth %>%	
  select(supp, len) %>% 	
  summary()	

ToothGrowth %>%	
  select(-dose)	

ToothGrowth %>% 	
  select(1, 2) 	

ToothGrowth %>% 	
  select(2:3)	

ToothGrowth %>%	
  select(starts_with("d", ignore.case = TRUE)) 	
# 	
# 	
# 	
# **arrange**: Arranging cases by value taken on a specific variable in an ascending order.	
# 	
# 	
ToothGrowth %>%	
  mutate(len_cm = len / 10) %>% 	
  group_by(supp) %>%	
  summarise(mean_len_cm = mean(len_cm),	
            cases = n()) %>% 	
  arrange(mean_len_cm)	
# 	
# 	
# We can use the minus sign to get a descending order linke this: 	
# 	
# 	
ToothGrowth %>%	
  mutate(len_cm = len / 10) %>% 	
  group_by(supp) %>%	
  summarise(mean_len_cm = mean(len_cm),	
            cases = n()) %>% 	
  arrange(-mean_len_cm)	
# 	
# 	
# **rename()**: Renames a specific column	
# 	
# 	
ToothGrowth %>%	
  rename(new_name = dose)	
# 	
# 	
# 	
# ## Recoding variables	
# 	
# One of the main uses of mutate() is to recode variables. This can be done using different functions. The two main ones being recode() and case_when().	
# 	
# **recode()**: recode is used to recode descrete variables into descrete variables. See an example below:	
# 	
# 	

ToothGrowth %>% 	
  mutate(dose_recode = recode(dose, 	
                              "0.5" = "small",	
                              "1.0" = "medium",	
                              "2.0" = "large"))	
# 	
# 	
# 	
# **case_when()**: to recode a continuous variable into descrete categories, it is more effective to use the case_when() function. The following code creates a new variable, where cases that take the value 0.5 on the variable dose are labeled "small", while those that take values larger than 0.5 are labeled "medium_to_large".	
# 	
# 	
ToothGrowth %>% 	
  mutate(len_new = case_when(len <= 10 ~ "small",	
                                      len > 10 ~ "medium_to_large"))	
# 	
# 	
# 	
#                                       	
# *_________________Practice__________________*	
# 	
# 7. Within the ToothGrowth dataset list the average tooth length (len, or len_cm) for each dose sparately only for cases where the vitamin C was administered as ascorbic acid (supp == "VC"). Do all this in a single code chain using %>% operators.	
# 8. Load the titanic package (if necessary, install it first) Load the titanic train dataset with the code below. Notice that the code below drops the rows with any missing values from the dataset	
#   library(tidyverse)	
#   library(titanic)	
# 	
#   titanic_data <- titanic_train %>% 	
#     drop_na()	
# 9. Determine the number of valid cases in the dataset (number of rows)	
# 10. Recode the "Survived" variable so that values of 1 will be recoded as "survived" and values of 0 will be recoded as "died".	
# 11. How many people have survived the disaster from this dataset? ("Survived" variable) Try to get this information using the summirise() function.	
# 12. Create a new dataset only containing people who travelled on first class (information found in "Pclass" variable).	
# 13. Arrange the dataset based on how much people paid for their ticket ("Fare" variable) in an ascending oder.	
# 14. The "Fare" is given in USD. Create a new variable containing the fare in Canadian dollars.	
# 	
# *____________________________________________*	
# 	
# 	
# 	
# 	
