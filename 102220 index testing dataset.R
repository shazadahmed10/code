
#### Load necessary packages
library ("tidyverse")
library ("openxlsx")

####import a PSNUxIM dataset
master <- read_tsv ("C:/Users/lqa9/Desktop/20Q3/Clean/MER_Structured_Datasets_PSNU_IM_FY18-21_20200918_v2_1.txt",
                    col_types = cols(
                      fiscal_year = col_character(),
                      qtr1 = col_double(),
                      qtr2 = col_double(),
                      qtr3 = col_double(),
                      qtr4 = col_double(),
                      targets = col_double(),
                      cumulative = col_double()))


#### transformation steps include: dropping columns, subsetting indicators, creating ou_type 
master2 <- master %>% 
  select(-c(operatingunituid, countryname, mech_code, mech_name, pre_rgnlztn_hq_mech_code,
            prime_partner_duns, award_number, categoryoptioncomboname, snu1uid, psnuuid, statustb, statuscx,
            otherdisaggregate_sub, hiv_treatment_status, source_name)) %>%
  filter(indicator %in% c("HTS_TST_POS", "HTS_INDEX", "HTS_INDEX_KNOWNPOS",
                          "HTS_INDEX_NEWNEG", "HTS_INDEX_NEWPOS", "TX_NEW", "HTS_TST", "HTS_SELF")) %>%
  mutate(ou_type = 
           if_else(operatingunit %in% c("Democratic Republic of the Congo","Lesotho", "Malawi", "Nigeria", 
                                        "South Sudan", "Uganda", "Ukraine", "Vietnam", "Zambia"), "ScaleFidelity",
                   if_else(operatingunit %in% c("Burundi", "Eswatini", "Ethiopia", "Kenya", "Namibia",
                                                "Rwanda", "Zimbabwe"), "Sustain",
                           if_else(operatingunit %in% c("Angola", "Botswana", "Cameroon", "Dominican Republic", 
                                                        "Haiti", "Mozambique", "South Africa", "Tanzania", 
                                                        "Cote d'Ivoire", "Western Hemisphere Region"), "Reboot",
                                   "N/A"))))

#### only including index/indexmod for HTS_TST
tst <- filter(master2, indicator == "HTS_TST" & modality %in% c("Index", "IndexMod")) 
master3 <- filter(master2, indicator != "HTS_TST")
master4 <- bind_rows(master3, tst)

#### only including relevant tx_new disaggs for proxy linkage
txnew <-filter(master4, indicator == "TX_NEW" & standardizeddisaggregate %in% c("Age Aggregated/Sex/HIVStatus", 
                                                                                "Age/Sex/HIVStatus",
                                                                                "Total Numerator"))
master5 <-filter(master4, indicator != "TX_NEW")
master6 <-bind_rows(master5, txnew)

#### dropping fiscal year values to trim dataset
master7 <-filter(master6, fiscal_year != "2018")
master8 <-filter(master7, fiscal_year != "2021")

#### QC tables
View(count(master4, ou_type, indicator, modality))
View(count(master6, indicator, standardizeddisaggregate, fiscal_year))
View(count(master8, fiscal_year))


write_tsv(master8,  "C:/Users/lqa9/Desktop/Files/Index Testing Coop/IndexCooP_102220.txt")

