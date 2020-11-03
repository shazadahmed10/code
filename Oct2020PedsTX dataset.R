
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
  select(-c(operatingunituid, categoryoptioncomboname, snu1uid, psnuuid,otherdisaggregate_sub, source_name)) %>%
  filter(indicator %in% c("TX_CURR", "TX_PVLS")) %>%
  filter(operatingunit %in% c("Bostwana", "Cameroon", "Cote d'Ivoire", "Eswatini", "Ethiopia", "Haiti", "Kenya", 
                              "Lesotho", "Malawi","Mozambique", "Namibia", "Nigeria", "Rwanda", "South Africa", 
                              "SouthSudan", "Tanzania", "Uganda", "Zambia","Zimbabwe"))



View(count(master, operatingunit))
View(count(master2, indicator ))



write_tsv(master2,  "C:/Users/lqa9/Desktop/PedsTX_102020.txt")

