#### Script for Historic HTS/POS data for ALL OU report ####
#Date; Aug 4, 2021 #
# Steps: pull in historic data file, pull in OUxIM for all DATIM years, TST & POS indicators, 
# drop columns not needed, align columns names, stack.
# objective : to get historic data (until 2016 in with 2015 - present)#


#### Load necessary packages
library ("tidyverse")
library ("openxlsx")
library ("readxl")

####import ouxIM dataset. This dataset was pulled from Genie for POS/TST total num for all years, all OUs
master <- read_tsv ("C:/Users/lqa9/OneDrive - CDC/Files/HTS/DGHT HTS report/All OU report/MER 15-21.txt",
                    col_types = cols(
                      fundingagency = col_character(),
                      statushiv = col_character(),
                      modality = col_character(),
                      fiscal_year = col_character(),
                      qtr1 = col_double(),
                      qtr2 = col_double(),
                      qtr3 = col_double(),
                      qtr4 = col_double(),
                      targets = col_double(),
                      cumulative = col_double()))

historic <- read_xlsx("C:/Users/lqa9/OneDrive - CDC/Files/HTS/DGHT HTS report/All OU report/historic HTS.xlsx", sheet = "rawdata")


#drop columns, rows not needed from MSD; need HTS and POS total num from 2015-present

master2 <- master %>%
  select(c(operatingunit, countryname, primepartner, fundingagency, indicator, indicatortype,
           fiscal_year, targets, cumulative))

#for historic data: harmonize column names, remove 15/16, remove DSD from '13 and DSD+TA from '14 before stacking to MSD data
`%notin%` <- Negate(`%in%`)
historic2 <- historic %>%
  rename(indicator = `Indicator Short Name`, fiscal_year = "Year", countryname = "Country/Region", cumulative = `Measure Value`,
         indicatortype = "DSD/TA", type = `Measure Name`) %>%
  select(c(fiscal_year, countryname, indicator, cumulative, type, indicatortype )) %>%
  filter(fiscal_year %notin% c("2015", "2016")) 

historic13 <- historic2 %>%
  filter(fiscal_year == "2013") %>%
  filter(indicatortype != "DSD")
# for '14, POS needs DSD+TA and TST doesn't have it, so it needs DSD, TA separately; need to create teo data frames for '14
# for each indicator and stack those
historic14 <- historic2 %>% filter(fiscal_year == "2014") 
historic14tst <- filter(historic14, indicator == "HIV Testing and Counseling Services")
historic14pos <- historic14 %>%
  filter(indicator == "HIV Tested Positive") %>%
  filter(indicatortype == "DSD+TA")
historic14 <- bind_rows(historic14pos, historic14tst)


historic3 <-filter(historic2, fiscal_year %notin% c("2013", "2014"))
historic4 <- bind_rows(historic3, historic13, historic14)
#convert fiscal_year to char to allow stack to MSD
historic4$fiscal_year <- as.character(historic4$fiscal_year)

View(count(master2, indicator, fiscal_year))
View(count(historic4, indicator, fiscal_year, indicatortype))
View(count(historic14, indicator, fiscal_year, indicatortype))



#stack historic data to 15-current rows from MSD; 
master3 <- bind_rows(master2, historic4)

#write.xlsx(historic2, "C:/Users/lqa9/OneDrive - CDC/Files/HTS/DGHT HTS report/All OU report/historic.xlsx")
write.xlsx(master3, "C:/Users/lqa9/OneDrive - CDC/Files/HTS/DGHT HTS report/All OU report/master_historic.xlsx")

