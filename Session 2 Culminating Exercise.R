
#------- Session 2 Culminating Exercise ----------
#-------------------------------------------------

# This exercise is intended for you to do indepdently after the Session 2 lesson.
# This exercise will integrate most of the methods gained from Session 2 into a 
#   simulation of analyses you may do in real life using MER data 


# Question 1: You just joined the field team of the OU, Essos, in PEPFAR. 
# You need to create a dataset that just has data for your OU, Essos. 
# you also need to change the names of some of the PSNUs and Partners to account for influx of migrants and other changes:
# For PSNU: Flatlands is now "Hogsmeade"
# For Partner: Warg is now "Hogwarts" and "Trueborn" is now "Muggles"
# You also need to filter for HTS_TST_POS and TX_NEW data only
# Also rename variables "indicator" to "Indicator" and "PrimePartner" to "ThePartner"
# please use piping in your code as it will be shared with junior staff members. 
# Export the data as Essos3.csv






# Question 2: Now that you have prepared this dataset, the Branch Chief wants to know how big the dataset is, namely, # of rows and variables. 
# Then she wants to know how many people were found positive by each Partner in FY2018Q1, as a dataset
# She also wants to know how many people were new on treatment by each Partner in FY2018Q2, as another dataset
# then she wants a dataset that stacks/combines these numbers together 
# she only wants OperatingUnit, PSNU, Indicator, ThePartner, FY2018Q2 in these datasets
# please export stacked dataset as Essos4.csv
# be efficient with the coding as junior staff will use it











#---------------------------------ANSWERS-------------------------------#

# Question 1

library(tidyverse)

test <- read_tsv("RawData/ex2_data.txt",
                 col_types = cols(MechanismID        = "c",
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
                                  FY2018_TARGETS     = "d",
                                  FY2019_TARGETS     = "d"))

Essos3 <- test %>% 
  filter(OperatingUnit == "Essos", indicator == "HTS_TST_POS" | indicator == "TX_NEW") %>%
  mutate(PSNU =
         if_else(PSNU == "Flatlands", "Hogsmeade", PSNU)) %>%
  mutate(PrimePartner = 
         if_else(PrimePartner == "Warg", "Hogwarts",
                 if_else(PrimePartner == "Trueborn", "Muggles", PrimePartner))) %>%
  rename(Indicator = indicator, ThePartner = PrimePartner)
View(count(Essos3, PSNU, ThePartner, Indicator, OperatingUnit))    


write_csv(Essos3, path = "Output/Essos3.csv")



# Question 2

glimpse(Essos3)


tst_pos <- Essos3 %>% 
  filter(Indicator == "HTS_TST_POS", standardizedDisaggregate == "Total Numerator") %>% 
    select(OperatingUnit, Indicator, PSNU, ThePartner, FY2018Q1)

    

tx_new <- Essos3 %>% 
  filter(Indicator == "TX_NEW", standardizedDisaggregate == "Total Numerator") %>% 
    select(OperatingUnit, Indicator, PSNU, ThePartner, FY2018Q1)


Essos4 <- bind_rows(tst_pos, tx_new)

write_csv(Essos4, path = "Output/Essos4.csv")
