#___________________________________________________________________________
#~~~~~~~~~~~      _____   _             _       _                ~~~~~~~~~~~~~~~
#~~~~~~~~~~~     |  __ \ | |           (_)     (_)               ~~~~~~~~~~~~~~~ 
#~~~~~~~~~~~     | |__) || |_ _ __ __ _ _ _ __  _ _ __   __ _    ~~~~~~~~~~~~~~~
#~~~~~~~~~~~     |  _  / | __| '__/ _` | | '_ \| | '_ \ / _` |   ~~~~~~~~~~~~~~~
#~~~~~~~~~~~     | | \ \ | |_| | | (_| | | | | | | | | | (_| |   ~~~~~~~~~~~~~~~
#~~~~~~~~~~~     |_|  \_\ \__|_|  \__,_|_|_| |_|_|_| |_|\__, |   ~~~~~~~~~~~~~~~
#~~~~~~~~~~~           ______                            __/ |   ~~~~~~~~~~~~~~~
#~~~~~~~~~~~          |______|                           \___/   ~~~~~~~~~~~~~~~
#___________________________________________________________________________



#### R Training Series: SESSION 2 ####
#Produced by the DAQ on behalf of ICPI



#### Topics covered:  ####
# 0. Setting up
# 1. Create new variables
# 2. Clean up erroneous values
# 3. Rename variables
# 4. Delete variables
# 5. Pipe (%>%)
# 6. Summarize Data like pivot tables
# 7. Stack datasets
# 8. Transpose wide to long
# 9. Merge: left join
# 10. Merge: anti-join



# ----------------------------------- #
#### Topic 0: Setting Up ####
# ----------------------------------- #


# "#" allows the user to provide 
# comments within a script that won't affect the commands 
# within. You may notice the color changes to signify this 
# text is not like the other codes within the script.
# They provide an easy way for a programmer to provide
# context to the code within a script, detail what they 
# want users to know, and provide organizational flow. 


# if you don't already have it, you'll need to install tidyverse to run this sessions' script
install.packages("tidyverse")

# load packages
library(tidyverse)

# checking your working directory
getwd() 

# Since we're using an RProj file, the working directory will already be set where we need it to be, but changing
# it is easy and important when calling files using relative paths.  

# example new working directory:
# setwd("C:/Users/[USERID]/[FILEFOLDER]//[FILEFOLDER]")


# Next, you need to import the dataset you will be using for this course
# You can import datasets in two general ways:
# (1) Point-and-click
#     This option requires no explicit coding
#     You can select FILE > IMPORT DATASET > FROM [filtype]
#     Or, click IMPORT DATASET in the Environment pane 

# (2) readr from the tidyverse package

msd <- read_tsv("C:/Users/lqa9/OneDrive - CDC/DAQ/PVA R training/PVA Course 2/MER_Structured_TRAINING_Datasets_PSNU_IM_FY18-20_20200214_v2_1.txt",
                col_types = cols(.default = "c",
                                 targets	= "d",
                                 qtr1	= "d",
                                 qtr2	= "d",
                                 qtr3	= "d",
                                 qtr4	= "d",
                                 cumulative = "d"))


# ------------------------------------------------ #
#### Topic 1: Create new variables (mutate ) ####
# ------------------------------------------------ #

# The function used to create new variables in Tidyverse is 'mutate'. 
# Execute ?mutate to view the documentation for this function

# Simple example: Dividing cumulative values by 10
msd2 <- mutate(msd, cumulative_alt = cumulative/10)
View (select(msd2, cumulative, cumulative_alt))


# New Partner Names, one change
# mutate() and if_else() make for a powerful combination in tandem.
# if_else function is comprable to IF function in excel 

View(count(msd, primepartner)) # view this variable
msd2 <- mutate(msd, newpartnername = 
                if_else(primepartner == "Triangulum Australe", "Triangulum", primepartner))
View(count(msd2, primepartner, newpartnername))


# New Partner Names, multiple changes. 
msd3 <- mutate(msd, newpartnername = 
                if_else(primepartner == "Triangulum Australe", "Triangulum", 
                        if_else(primepartner == "Ursa Major", "Ursa Minor", 
                                if_else(primepartner == "Orion" , "Orion's Belt", primepartner))))
View(count(msd3, primepartner, newpartnername))




# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 1. Create a new dataset called test1 from "msd" and
# create a new variable called "newvar", which will change the PSNU value "Europa" to "Europa Major"
# 1a. Using count, view the PSNU and newvar columns in dataset test1 







# --------------------------------------------- #
#### Topic 2: Clean up erroneous values (recode, remove NA)  ####
# --------------------------------------------- #

# Let's say there are values in a dataset that are incorrect spelled or recorded.
# A common data management step is to clean up these values by re-coding them
# One way to do this is to create a new variable and use if_else statements to recode. 
# This is essentially what is happening in Topic 1
# However what if you don't want to create a new variable?

# Example on character values using (mutate - recode): 
View(count(msd, primepartner)) # view this variable
msd2 <- mutate(msd, primepartner = recode(primepartner, "Triangulum Australe" = "Triangulum"))
View(count(msd2, primepartner))






#What if you want to remove NA values? 





# --------------------------------------------------------- #
#### Topic 3: Rename variables (rename) ####
# --------------------------------------------------------- #

View (slice(msd, 1:20)) #seeing what is there currently

# like all R assignments, the new variable is on the left side of argument
msd4 <- rename(msd, partner = primepartner, agency = fundingagency)

View(msd4) # you will see new names in column headers



# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 3. Please create a new dataset called test3 from msd and rename SNU1 to EssEnYouOne. Also rename countryname to country.
# then view the dataset too see the new column names





# --------------------------------------------------------- #
#### Topic 4: Delete variables (select) ####
# --------------------------------------------------------- #

View (slice(msd, 1:20)) #seeing what is there currently

# Let's remove UIDs
msd5 <- select(msd, -regionuid, -operatingunituid, -snu1uid, -psnuuid)

# can also do it this way using combine (-c) :
msd5 <- select (msd, -c(regionuid, operatingunituid, snu1uid, psnuuid))

View(names(msd))


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 4. Please create a new dataset, called test4 from msd and delete regionuid, operatingunituid, 
# pre_rgnlztn_hq_mech_code, prime_partner_duns, and award_number. 
# Then view the dataset to confirm deletions




# --------------------------------------------------------- #
#### Topic 5: Pipe (%>%) ####
# --------------------------------------------------------- #


# Pipes let you take the output of one function/step and send it directly to the next step, 
# which is useful when you need to do many things to the same dataset

# %>% returns an object, you can actually allow the calls to be 
# chained together in a single statement, without needing variables 
# to store the intermediate results.



# Examples:
# Positives found by Total Numerator:
hts1 <- msd %>%   # this is the pipe! goes at end of every function statement 
  filter(indicator == "HTS_TST_POS" & standardizeddisaggregate == "Total Numerator") %>%
  select (operatingunit, indicator, psnu, primepartner, fundingagency, standardizeddisaggregate, targets, cumulative)

View(slice(hts1, 1:20))


# Same example Without Piping:
# you have to create several intermediate datasets, which is inefficient 
hts_nopipe <- filter (msd, indicator == "HTS_TST_POS" & standardizeddisaggregate == "Total Numerator")
hts_nopipe2 <- select(hts_nopipe, operatingunit, indicator, psnu, primepartner, fundingagency, standardizeddisaggregate, targets, cumulative)

View(slice(hts_nopipe2, 1:20))



# New Examples: 

#New on treatment by OU and 'disagg type'
tx2 <- msd %>%
  filter(indicator == "TX_NEW" & cumulative >0 ) %>%
  rename (disagg_type = standardizeddisaggregate ) %>% 
  select (operatingunit, indicator, psnu, disagg_type, cumulative)

View(count(tx2, operatingunit, indicator, psnu, disagg_type, cumulative))

View(count(msd, primepartner))

tx3 <- msd %>% 
  filter((indicator == "TX_CURR" | indicator == "TX_NEW" | indicator == "HTS_TST") & standardizeddisaggregate == "Total Numerator") %>%
  mutate (newpartnername = if_else(primepartner == "Ursa Major", "Ursa Minor", primepartner)) %>% 
  select (operatingunit, snu1, snuprioritization, psnu, newpartnername, indicator, standardizeddisaggregate, cumulative) %>%
  arrange (newpartnername) %>%
  rename (disagg_type = standardizeddisaggregate) 

View(tx3)
View(count(tx3, newpartnername, indicator, disagg_type))


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 5. Please create a new dataset, "test5" from "msd" where you pipe these steps together:
# filter for TX_NEW
# select operatingunit, PSNU, qtr2, qtr4
# arrange psnu
# then View the new dataset






# --------------------------------------------------------- #
#### Topic 6: Summarize Data like pivot tables ####
# --------------------------------------------------------- #

# now that we know about piping.....
# most of our work involves trying to aggregate or roll things up, similar to how we utilize pivot tables to view data
# let's try to look at our SNU1 level of TX_NEW results
# We can use the 'summarise' command to aggregate our data. the output will show up in the console menu

msd %>% 
  summarise(cumulative = sum(cumulative, na.rm = TRUE ))
# this give us a single line for the whole country and all indicators; let's filter

msd %>% 
  filter(indicator == "TX_NEW", standardizeddisaggregate == "Total Numerator") %>% 
  summarise(cumulative = sum(cumulative, na.rm = TRUE ))
# that's better but we want to look at the APR results across SNUs, so we need to use a group_by command
# (which should follow by ungroup so we don't perform any other calculations across this group)
# we also want 2020 results only

msd %>% 
  filter(indicator == "TX_NEW", standardizeddisaggregate == "Total Numerator", fiscal_year == "2020") %>% 
  group_by(operatingunit, snu1) %>% 
  summarise(cumulative = sum(cumulative, na.rm = TRUE )) %>% 
  ungroup()  # it is important to ungroup after using group_by as R data objects retain the grouping internally
# this will lead to errors if later you try to create a new variable


# throw a 'View' in there to see output in it's own window
View(msd %>% 
  filter(indicator == "TX_NEW", standardizeddisaggregate == "Total Numerator", fiscal_year == "2020") %>% 
  group_by(operatingunit, snu1) %>% 
  summarise(cumulative = sum(cumulative, na.rm = TRUE )) %>% 
  ungroup())


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 6. create a new dataset, called test6 from msd where you:
# filter for TX_CURR, Total Numerator and 2020 
# summarise cumulative 
# and group_by PSNU
# and View the table








# --------------------------------------------------------- #
#### Topic 7: Stack datasets ####
# --------------------------------------------------------- #

# 'Stacking' refers to appending or combining two or more datasets together by the addition of new rows

# Use rbind function to stack/append datasets by rows 
msd_double <- bind_rows(msd2, msd3)


# If one dataset has variables that the other dataset does not, then bind_rows will
# Assigns "NA" to those rows of columns missing in one of the data frames 
# since first dataset in the stack is tx3, most columns will show NA starting with first row since tx3 only had 8 columns
msd_double2 <- bind_rows(tx3, msd5)
View(msd_double2)



# --------------------------------------------------------- #
#### Topic 8: Transpose wide to long ####
# --------------------------------------------------------- #



# --------------------------------------------------------- #
#### Topic 9: Merge: Left-Join ####
# --------------------------------------------------------- #


# --------------------------------------------------------- #
#### Topic 10: Merge: Anti-Join ####
# --------------------------------------------------------- #

