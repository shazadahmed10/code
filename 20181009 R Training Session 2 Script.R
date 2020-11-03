

#___________________________________________________________________________
#
#         ___  2
#         |__) 
#         |  \    R Training Session II   
#
#___________________________________________________________________________



# R Studio Projects -------------------------------------------------------
# R Studio projects are a great feature which allow you to have one dedicated session for each project you are working on
# One of the great features is that it sets the working directory to the project folder automatically so others can easily
# work off the same file without having to adjust their file paths (and everything is step up the exact same).
# To start an R Project that already exists, double click on the .Rproj file in the folder.
# If you have not opened this session via the .Rproj file, you will need to so that all the file paths work the same on your machine



# Every time you open R, you will need to "open" or load your packages, using library()
library(tidyverse)


#--------------------------------------------------------------
# ---- (0) Importing the dataset ----- 
#--------------------------------------------------------------
# Pulling in the dataset for next steps
df <- read_tsv("RawData/ex2_data.txt",
                      col_types = cols(MechanismID      = "c",
                                     AgeAsEntered       = "c",            
                                     AgeFine            = "c",     
                                     AgeSemiFine        = "c",    
                                     AgeCoarse          = "c",      
                                     Sex                = "c",     
                                     resultStatus       = "c",     
                                     otherDisaggregate  = "c",     
                                     coarseDisaggregate = "c",     
                                     FY2017_TARGETS     = "d",
                                     FY2017Q1           = "d",      
                                     FY2017Q2           = "d",      
                                     FY2017Q3           = "d",      
                                     FY2017Q4           = "d",      
                                     FY2017APR          = "d",
                                     FY2018Q1           = "d",
                                     FY2018Q2           = "d",
                                     FY2018Q3           = "d",
                                     FY2018_TARGETS     = "d"))
spec(df)
View(slice (df, 1:20))





#--------------------------------------------------------------
# ---- (1) Creating New Variables (Mutate) ----- 
#--------------------------------------------------------------


# Dividing FY2017APR values by 10
df2 <- mutate(df, FY2017APR_true = FY2017APR/10)
View (select(df2, FY2017APR, FY2017APR_true))

# Above step AND doubling the FY18 Q2 values
df2 <- mutate(df, FY2017APR_true = FY2017APR/10, FY2018Q2_true = FY2018Q2 *2) 
View (select(df2, FY2017APR, FY2017APR_true, FY2018Q2, FY2018Q2_true))


# New Partner Names, one change
# mutate() and if_else() make for a powerful combination in tandem.
# if_else function is comprable to IF function in excel 

View(count(df, PrimePartner)) # view this variable
df3 <- mutate(df, newpartnername = 
                if_else(PrimePartner == "TBD", "Good Partner", PrimePartner))
View(count(df3, PrimePartner, newpartnername))


# New Partner Names, multiple changes. 
df4 <- mutate(df, newpartnername = 
                if_else(PrimePartner == "TBD", "Good Enough Partner", 
                        if_else(PrimePartner == "John Snow, Inc.", "JSI", 
                                if_else(PrimePartner == "Dedup" , "Confusing Adjustments", PrimePartner))))
View(count(df4, PrimePartner, newpartnername))


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 1. Create a new dataset called test1 from "df" and
# create a new variable called "newvar", which will change the PSNU value "South East District" to "SE District"
# 1a. Using count, view the PSNU column in dataset test1 





#----------------------------------------------------------------------
# ---- (2) Piping %>%  - Bringing It All Together ----- 
#----------------------------------------------------------------------


# Pipes let you take the output of one function and send it directly to the next, 
# which is useful when you need to do many things to the same dataset

# %>% returns an object, you can actually allow the calls to be 
# chained together in a single statement, without needing variables 
# to store the intermediate results.



# Examples:
# Voluntary circumcisions found by Total Numerator:
vmmc1 <- df %>%   # this is the pipe! goes at end of every function statement 
  filter(indicator == "VMMC_CIRC" & standardizedDisaggregate == "Total Numerator") %>%
  select (OperatingUnit, indicator, PSNU, PrimePartner, FundingAgency, standardizedDisaggregate, FY2018Q1, FY2017APR)

View(slice(vmmc1, 1:20))


# Same example Without Piping:
# you have to create several intermediate datasets, which is inefficient 
vmmc_nopipe <- filter (df, indicator == "VMMC_CIRC" & standardizedDisaggregate == "Total Numerator")
vmmc_nopipe2 <- select(vmmc_nopipe, OperatingUnit, indicator, PSNU, PrimePartner, FundingAgency, standardizedDisaggregate, FY2018Q1, FY2017APR)

View(slice(vmmc_nopipe2, 1:20))



# KP_PREV by OU and disagg type
kp <- df %>%
  filter(indicator == "KP_PREV" & FY2017APR >0 ) %>%
  rename (disagg_type = standardizedDisaggregate ) %>% 
  select (OperatingUnit, indicator, PSNU, disagg_type, FY2017APR)

View(count(kp, OperatingUnit, indicator, PSNU, disagg_type, FY2017APR))



kp2 <- df %>% 
  filter((indicator == "KP_PREV" | indicator == "PP_PREV") & standardizedDisaggregate == "Total Numerator") %>%
  mutate (newpartnername = if_else(PrimePartner == "TBD", "Tolerable Partner", PrimePartner)) %>% 
  select (OperatingUnit, SNU1, SNUPrioritization, PSNU, newpartnername, indicator, standardizedDisaggregate, FY2017APR) %>%
  arrange (newpartnername) %>%
  rename (disagg_type = standardizedDisaggregate) 

View(kp2)
View(count(kp2, newpartnername, indicator, disagg_type))


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 2. Please create a new dataset, "test2" from "df" where you pipe these steps together:
# filter for KP_PREV
# select OperatingUnit, PSNU, FY2018Q2
# arrange PSNU
# then View it



#----------------------------------------------------------------------
# ---- (3) Summarizing Data  ----- 
#----------------------------------------------------------------------

# now that we know about piping.....
# most of our work involves trying to aggregate or roll things up, similar to pivot tables
# let's try to look at our SNU1 level of VMMC_CIRC results from FY2017
# We can use the summarise commands to aggregate our data

df %>% 
  summarise(FY2017APR = sum(FY2017APR, na.rm = TRUE ))

# this gave us a single line for the whole country and all indicators; let's filter
df %>% 
  filter(indicator == "VMMC_CIRC", standardizedDisaggregate == "Total Numerator") %>% 
  summarise(FY2017APR = sum(FY2017APR, na.rm = TRUE ))
# that's better but we want to look at the APR results across SNUs, so we need to use a group_by command 
# (which should follow by ungroup so we don't perform any other calculations across this group)
df %>% 
  filter(indicator == "VMMC_CIRC", standardizedDisaggregate == "Total Numerator") %>% 
  group_by(OperatingUnit, SNU1) %>% 
  summarise(FY2017APR = sum(FY2017APR, na.rm = TRUE )) %>% 
  ungroup()  # it is important to ungroup after using group_by as R data objects retain the grouping internally
             # this will lead to errors if later you try to create a new variable

# to add multiple summaries, such as FY18Q1 -FY18Q3 trends
test <-df %>% 
  filter(indicator == "VMMC_CIRC", standardizedDisaggregate == "Total Numerator") %>% 
  group_by(OperatingUnit, SNU1) %>% 
  summarise(FY2018Q1 = sum(FY2018Q1, na.rm = TRUE),
            FY2018Q2 = sum(FY2018Q2, na.rm = TRUE),
            FY2018Q3 = sum(FY2018Q3, na.rm = TRUE)) %>% 
  ungroup()



# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 3. create a new dataset, called test3 from df where you:
# filter for VMMC_CIRC and Total Numerator 
# summarise FY2017Q4 and FY2018Q1 
# and group_by PSNU
# then View it




#--------------------------------------------------------------
# ---- (4) Renaming Variables (Rename) ----- 
#--------------------------------------------------------------

View (slice(df, 1:20)) #seeing what is there currently

# like all R assignments, the new variable is on the left side of argument
df5 <- rename(df, Partner = PrimePartner, Agency = FundingAgency)

View(df5) # you will see new names in column headers

# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 4. Please create a new dataset called test4 from df and rename SNU1 to EssEnYouOne
# then view it 






#--------------------------------------------------------------
# ---- (5) Deleting Variables ----- 
#--------------------------------------------------------------

View (slice(df, 1:20))

# Let's remove UIDs
df6 <- select(df , -RegionUID, -OperatingUnitUID, -SNU1Uid, -PSNUuid, -MechanismUID)

View (slice(df6, 1:20))


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:


# 5. Please create a new dataset, called test5 from df and delete RegionUID & OperatingUnitUID
# then view it




#----------------------------------------------------------------------
# ---- (6) Stacking Datasets  ----- 
#----------------------------------------------------------------------


# Use bind_rows function to stack or merge datasets by rows 

df_double <- bind_rows(df, df2)

# If one dataset has variables that the other dataset does not, then bind_rows will
# Assigns "NA" to those rows of columns missing in one of the data frames 
df7 <- mutate(df, df1_flag = 1) # adding flag to indicate first dataset
df2 <- mutate(df2, df2_flag = 1) #adding flag to indicate second dataset

df_double2 <- bind_rows(df7, df2)
View(df_double2)











