
library(tidyverse)
library(openxlsx)

master <- read_tsv("C:/Users/lqa9/Desktop/20Q1/MER_Structured_Datasets_OU_IM_FY18-20_20200214_v1_1.txt")
master2 <- master %>% 
  filter(operatingunit == "Ethiopia") %>%
  select( -c(region, regionuid, operatingunituid, countryname, pre_rgnlztn_hq_mech_code, prime_partner_duns, award_number, 
             categoryoptioncomboname, disaggregate, statustb, statuscx, hiv_treatment_status)) %>%
  filter(indicator %in% c("HTS_TST", "HTS_TST_POS"))

write.xlsx(master2, "C:/Users/lqa9/Desktop/New Feb 2020/EthiopiaTST.xlsx")