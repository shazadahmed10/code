#### Script for All OU Report ####
#Date; July30, 2021 #
# Steps: pull in PSNUxIM, indicators, trim down anythingn not needed #


#### Load necessary packages
library ("tidyverse")
library ("openxlsx")

####import latest PSNUxIM dataset
master <- read_tsv ("C:/Users/lqa9/Desktop/21Q2/MER_Structured_Datasets_PSNU_IM_FY19-21_20210618_v2_1.txt",
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


#### transformation steps include: dropping columns, subsetting indicators, creating ou_type & art_cov & pitc
master2 <- master %>% 
  select(-c(operatingunituid, countryname, mech_code, mech_name, pre_rgnlztn_hq_mech_code,
            prime_partner_duns, award_number, categoryoptioncomboname, snu1uid, psnuuid, statustb, statuscx,
            otherdisaggregate_sub, hiv_treatment_status, source_name)) %>%
  filter(indicator %in% c("HTS_TST", "HTS_INDEX", "HTS_INDEX_KNOWNPOS", "HTS_INDEX_NEWNEG", "HTS_INDEX_NEWPOS", "HTS_RECENT",
                          "TX_NEW", "HTS_SELF", "TX_PVLS", "TX_CURR")) %>%
  mutate(ou_type = 
           if_else(operatingunit %in% c("Democratic Republic of the Congo","Lesotho", "Malawi", "Nigeria", 
                                        "South Sudan", "Uganda", "Ukraine", "Vietnam", "Zambia"), "ScaleFidelity",
                   if_else(operatingunit %in% c("Burundi", "Eswatini", "Ethiopia", "Kenya", "Namibia",
                                                "Rwanda", "Zimbabwe"), "Sustain",
                           if_else(operatingunit %in% c("Angola", "Botswana", "Cameroon", "Dominican Republic", 
                                                        "Haiti", "Mozambique", "South Africa", "Tanzania", 
                                                        "Cote d'Ivoire", "Western Hemisphere Region"), "Reboot",
                                   "N/A")))) %>%
  mutate(art_cov = 
           if_else(operatingunit %in% c("Asia Region", "Botswana", "Burundi", "Western Hemisphere Region", 
                                        "Eswatini", "Namibia", "Rwanda", "Uganda", "Zimbabwe"), "80% and Higher",
                   if_else(operatingunit %in% c("Ethiopia", "Kenya", "Lesotho", "Malawi", "Zambia"), "70-79%",
                           if_else(operatingunit %in% c("Angola", "Cameroon", "Cote d'Ivoire", "Democratic Republic of the Congo",
                                                        "Haiti", "Mozambique", "Nigeria", "South Africa", "Tanzania",
                                                        "Ukraine", "Vietnam", "Dominican Republic", 
                                                        "West Africa Region", "South Sudan"), "Under 70%",
                                   "No Info")))) %>%
  mutate(pitc=
           if_else(modality %in% c("Emergency Ward", "Inpat", "Malnutrition", "Pediatric", "TBClinic", "OtherPITC", 
                                   "OtherMod", "PMTCT ANC", "Post ANC 1", "STI Clinic"), "PITC", "N/A"))

View(count(master2, modality, pitc, art_cov, ou_type))

#### only including index/indexmod for HTS_TST
#tst <- filter(master2, indicator == "HTS_TST" & modality %in% c("Index", "IndexMod")) 
#master3 <- filter(master2, indicator != "HTS_TST")
#master4 <- bind_rows(master3, tst)

#### only including relevant tx_new disaggs for proxy linkage
#txnew <-filter(master4, indicator == "TX_NEW" & standardizeddisaggregate %in% c("Age Aggregated/Sex/HIVStatus", 
#                                                                                "Age/Sex/HIVStatus",
#                                                                                "Total Numerator"))
#master5 <-filter(master4, indicator != "TX_NEW")
#master6 <-bind_rows(master5, txnew)

#### dropping fiscal year values to trim dataset
#master7 <-filter(master6, fiscal_year != "2018")
#master8 <-filter(master7, fiscal_year != "2021")

#### QC tables
View(count(master4, ou_type, indicator, modality))
View(count(master8, indicator, standardizeddisaggregate, fiscal_year))
View(count(master2, fiscal_year))
View(count(master2, ou_type))
View(count(master2, statushiv))


write_tsv(master2,  "C:/Users/lqa9/OneDrive - CDC/Files/HTS/DGHT HTS report/All OU Report/allOUdataset_081021.txt", na = "")



