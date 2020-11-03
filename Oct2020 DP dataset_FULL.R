
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
            prime_partner_duns, award_number, categoryoptioncomboname, snu1uid, psnuuid,
            otherdisaggregate_sub, source_name)) %>%
  filter(indicator %in% c("HTS_TST_POS", "HTS_INDEX", "HTS_INDEX_KNOWNPOS",
                          "HTS_INDEX_NEWNEG", "HTS_INDEX_NEWPOS", "HTS_TST", "HTS_SELF", "OVC_HIVSTAT", 
                          "PMTCT_EID", "PMTCT_FO", "PMTCT_HEI_POS", "PMTCT_STAT", "PMTCT_ART", "TB_STAT",
                          "OVC_SERV", "TX_CURR", "TX_PVLS")) %>%
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
                                   "No Info"))))

View(count(master2, operatingunit, art_cov))
View(count(master2, operatingunit, ou_type))
View(count(master, operatingunit, countryname))

#### only including index/indexmod for HTS_TST
#tst <- filter(master2, indicator == "HTS_TST" & modality %in% c("Index", "IndexMod")) 
#master3 <- filter(master2, indicator != "HTS_TST")
#master4 <- bind_rows(master3, tst)


#### dropping fiscal year values to trim dataset
master3 <-filter(master2, fiscal_year != "2021")

#### QC tables
#View(count(master5, ou_type, indicator, modality))
#View(count(master5, indicator, standardizeddisaggregate, fiscal_year))
#View(count(master5, fiscal_year))


write_tsv(master3,  "C:/Users/lqa9/Desktop/Files/Index Testing Coop/CDC OD presentations/HTS_DP_Oct2020_full.txt")

