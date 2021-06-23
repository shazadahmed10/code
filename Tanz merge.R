#### R Script for Creating Dataset for Tanzani S&E INdex dashboard ####
# Created on June 10, 2021  - Shazad Ahmed 
# need: they requested viz with SNU1/PSNU breakdowns. These need to be manually added 

#### Steps: #### 
# 1. import Tanz S&E dataset
# 2. load Site xIM MSD and strip down to PSNU and orgunituid
# 3. merge on orgunituid to S&E for USAID entries, then fill in by factly names, then merge on sitename to get the rest?
# (USAId entries in S&E dataset have orgunituid, but no fctlyname, CC and DOD have names, no UID)



library("tidyverse")
library("openxlsx")


#### open sitexIM MSD #### 
msd <- read_tsv("C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/Tanz Request/Genie_SITE_IM_Tanzania_Frozen_eb7a2b3a-cab9-45d3-beda-bede6f70187c.txt") 
msd2 <- select(msd, orgunituid, sitename, snu1, psnu) 
msd3 <- distinct(msd2, orgunituid, sitename, snu1, psnu)

#unique Sitename needed for merge on sitename; however, this arbitrarily chooses a sitename when multiple orgnituids belong to
# same site name. Because there are duplicate sitenames with different orgunituid/PSNU, the merge ends up with extra rows
msd4 <- mutate(msd3, sitename = tolower(sitename))
#msd5 <- distinct(msd3, sitename, .keep_all = TRUE)


#### open Tanz S&E dataset ####
tanz <- read.xlsx("C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/Tanz Request/Safe_Ethical_Index_Tanzania_May2021_DODupdate.xlsx", 
                  sheet = "RawData")

# break up rows with orgunituid and those with fcltyname populated already # 
View(count(tanz, agency, fclty_name,orgunituid))

orgunit <- filter (tanz, orgunituid != "NA")
master_orgunit <-left_join(orgunit, msd4, by = "orgunituid")
master_orgunit2 <- select(master_orgunit, -fclty_name)



#### filter rows with fclty_name for merge on sitename ####
# decided not to do this because it would arbitraliry assign PSNU to sites # 
fac <- tanz %>% 
  filter(is.na(orgunituid)) %>% 
  mutate(fclty_name = tolower(fclty_name)) %>%
  rename (sitename = fclty_name)

#fac4 <- select(fac3, -orgunituid)

#master_fac <- left_join(fac4, msd5, by = "sitename")

#### stack master_fac and master_org
master <- bind_rows(fac, master_orgunit2)
master <- select(master, record_id, ou, agency, assess_date, assessment_type, question, question_text, 
                 response, question_category, site_finalscore, snu1, psnu, orgunituid, everything())




write.csv(master, "C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/Tanz request/Tanz_June11.csv", na = "", row.names = FALSE)





#### Merge on June 16, 2021 ####

##### PART 2 ########
# Take CDC/dod rows only, create unique IP-Sitename combo and merge on that to bring in regions for these rows properly#
# merge to xwalk provided by Tanz team #

xwalk <- read.xlsx("C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/Tanz Request/COP21 facilities xwalk.xlsx", 
                   sheet = "xwalk")

#make IP names lower case, create combo site/IP field, filter for only CDC/DOD sites and then stack back to USAID rows later#  

xwalk2 <- xwalk %>%
  mutate(ip_name = tolower(`COP.19/FY20.IP`)) %>%
  mutate(sitename = tolower(sitename)) %>%
  select(-'COP.19/FY20.IP') %>%
  unite(siteipcombo, "sitename", "ip_name", remove = TRUE) %>%
  filter(Funding.Agency %in% c("HHS/CDC", "DOD")) %>%
  rename(snu1 = SNU1, psnu = PSNU) %>%
  select(-Funding.Agency) %>% 
  distinct(siteipcombo, .keep_all = TRUE)

#make ip_name lower case, create site/IP combo field, filter for just CDC/DOD rows, remove region columns for a clean merge#
mastercdc <- master %>%
  mutate(ip_name = tolower(ip_name)) %>%
  unite(siteipcombo, "sitename", "ip_name", remove = FALSE) %>%
  filter(agency %in%  c("cdc", "DOD")) %>%
  select(-snu1, -psnu, -orgunituid)

#extract usaid rows to stack later. The usaid rows already have info merged from earlier#
masterusaid <- filter(master, agency == "usaid")

#merge xwalk to CDC/dod data#
master2 <- left_join(mastercdc, xwalk2, by = "siteipcombo")


#stack usaid rows back on. # of rows should match master. then reorder columns#
master3 <- bind_rows(master2, masterusaid)
master3 <- select(master3, record_id, ou, agency, assess_date, assessment_type, question, question_text, 
                 response, question_category, site_finalscore, snu1, psnu, orgunituid, everything())


write.csv(master3, "C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/Tanz request/Tanz_June22.csv", na = "", row.names = FALSE)

