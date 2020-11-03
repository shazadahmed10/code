library ("tidyverse")
library ("openxlsx")

master <- read_tsv ("C:/Users/lqa9/Desktop/19Q4/Clean/MER_Structured_Datasets_PSNU_IM_FY17-20_20191220_v2_2.txt")
master2 <- master %>% 
  select(-c(region, regionuid, operatingunituid, countryname, mech_code, mech_name, pre_rgnlztn_hq_mech_code,
            prime_partner_duns, award_number, categoryoptioncomboname, snu1uid, psnuuid)) %>%
  filter(indicator %in% c("HTS_TST_POS", "HTS_INDEX", "HTS_INDEX_FAC", "HTS_INDEX_COM", "HTS_INDEX_KNOWNPOS",
                          "HTS_INDEX_NEWNEG", "HTS_INDEX_NEWPOS", "HTS_SELF", "TX_NEW", "HTS_TST")) %>%
  mutate(ou_type = 
           if_else(operatingunit %in% c("Democratic Republic of the Congo","Lesotho", "Malawi", "Nigeria", 
                                        "South Sudan", "Uganda", "Ukraine", "Vietnam", "Zambia"), "ScaleFidelity",
                   if_else(operatingunit %in% c("Burundi", "Eswatini", "Ethiopia", "Kenya", "Namibia",
                                                "Rwanda", "Zimbabwe"), "Sustain",
                           if_else(operatingunit %in% c("Angola", "Botswana", "Cameroon", "Dominican Republic", 
                                                        "Haiti", "Mozambique", "South Africa", "Tanzania"), "Reboot",
                                   "N/A"))))

tst <- filter(master2, indicator == "HTS_TST" & modality %in% c("Index", "IndexMod")) 
master3 <- filter(master2, indicator != "HTS_TST")
master4 <- bind_rows(master3, tst)
      

View(count(master4, ou_type, indicator, modality))

#write_excel_csv(master2, "C:/Users/lqa9/Desktop/19Q4/IndexCooP.csv")

write_tsv(master4,  "C:/Users/lqa9/Desktop/CoOP/Index Testing/IndexCooP_010820.txt")

