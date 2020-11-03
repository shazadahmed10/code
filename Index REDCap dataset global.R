
#install.packages("janitor")

library("tidyverse")
library("openxlsx")
library("janitor")

#### open CDC dataset. use Raw, which is processed.
cdc <- read_csv("C:/Users/lqa9/Desktop/Files/Index Testing Coop/REDCap assessment work/CDC/IndexTesting_Raw_102920.csv", 
                col_types  = cols(record_id= "c"))


#### open USAID dataset. from 9/30
aid <- read_csv("C:/Users/lqa9/Desktop/Files/Index Testing Coop/REDCap assessment work/USAID/USAID index to 9.30.20.csv") 
 
#aid <- read.xlsx("C:/Users/lqa9/Desktop/Files/Index Testing Coop/REDCap assessment work/USAID/USAID index to 9.30.20.xlsx")



# compare columns between two sources

View(compare_df_cols(aid, cdc))

# add agency columns & recode country names in aid dataset
aid2 <- mutate(aid, agency = "usaid")
cdc2 <- mutate(cdc, agency = "cdc")


View(count(aid2, ou_name_v2))

aid3 <- aid2 %>% mutate(ou_name = 
                 if_else(ou_name_v2 == 29, "Angola", 
                         if_else(ou_name_v2 == 31, "Botswana",
                                 if_else(ou_name_v2 == 33, "Burkina Faso",
                                         if_else(ou_name_v2 == 34, "Burma",
                                                 if_else(ou_name_v2 == 35, "Burundi",
                                                         if_else(ou_name_v2 == 36, "Cameroon",
                                                                 if_else(ou_name_v2 == 37, "Cote d'Ivoire",
                                                                         if_else(ou_name_v2 == 38, "Democratic Republic of the Congo",
                                                                                 if_else(ou_name_v2 == 39, "Dominican Republic",
                                                                                         if_else(ou_name_v2 == 41, "Ewsatini",
                                                                                                 if_else(ou_name_v2 == 42, "Ethiopia",
                                                                                                         if_else(ou_name_v2 == 45, "Guyana",
                                                                                                                 if_else(ou_name_v2 == 46, "Haiti",
                                                                                                                         if_else(ou_name_v2 == 51, "Kazakhstan",
                                                                                                                                 if_else(ou_name_v2 == 52, "Kenya",
                                                                                                                                         if_else(ou_name_v2 == 53, "Kyrgyzstan",
                                                                                                                                                 if_else(ou_name_v2 == 54, "Laos",
                                                                                                                                                         if_else(ou_name_v2 == 55, "Lesotho",
                                                                                                                                                                 if_else(ou_name_v2 == 56, "Liberia",
                                                                                                                                                                         if_else(ou_name_v2 == 57, "Malawi",
                                                                                                                                                                                 if_else(ou_name_v2 == 58, "Mali",
                                                                                                                                                                                         if_else(ou_name_v2 == 59, "Mozambique",
                                                                                                                                                                                                 if_else(ou_name_v2 == 60, "Namibia",
                                                                                                                                                                                                         if_else(ou_name_v2 == 61, "Nepal",
                                                                                                                                                                                                                 if_else(ou_name_v2 == 63, "Nigeria",
                                                                                                                                                                                                                         if_else(ou_name_v2 == 65, "Papua New Guinea",
                                                                                                                                                                                                                                 if_else(ou_name_v2 == 68, "South Africa",
                                                                                                                                                                                                                                         if_else(ou_name_v2 == 69, "South Sudan",
                                                                                                                                                                                                                                                 if_else(ou_name_v2 == 70, "Tajikistan",
                                                                                                                                                                                                                                                         if_else(ou_name_v2 == 71, "Tanzania",
                                                                                                                                                                                                                                                                 if_else(ou_name_v2 == 72, "Thailand",
                                                                                                                                                                                                                                                                         if_else(ou_name_v2 == 73, "Togo",
                                                                                                                                                                                                                                                                                 if_else(ou_name_v2 == 78, "Zambia",
                                                                                                                                                                                                                                                                                         if_else(ou_name_v2 == 79, "Zimbabwe",
                                                                                                                                                                                                                                                                                                 if_else(ou_name_v2 == 80, "Cambodia", ""
                                                                                                                                         )))))))))))))))))))))))))))))))))))) %>%
  select(-ou_name_v2)

View(count(aid3, ou_name))

# stack to one another
global <- bind_rows(aid3, cdc2)
View(count(global, ou_name, agency))

#reorder columns
global2 <- select(global, record_id, ou_name, agency, everything())
# appears that all usaid columns have "_v2" in them. need to get rid of this
names(aid2) <- sub("_v2", "", names(aid2))

#recode values from usaid data for checklist columns, country values, rename agency label 'agency'
#convert variable types to matching types

#rename columns for max column alignment before stacking them





# export usaid for now and manually stack to cdc
write.xlsx(aid2, "C:/Users/lqa9/Desktop/Files/Index Testing Coop/REDCap assessment work/usaid.xlsx")
write.xlsx(cdc2, "C:/Users/lqa9/Desktop/Files/Index Testing Coop/REDCap assessment work/cdc.xlsx")
#write.xlsx(global, "C:/Users/lqa9/Desktop/Files/Index Testing Coop/REDCap assessment work/globalv1.xlsx", na = "")
write.csv(global2, "C:/Users/lqa9/Desktop/Files/Index Testing Coop/REDCap assessment work/globalv1.csv", na = "")

