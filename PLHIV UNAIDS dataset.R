#### PLHIV cascade dataset ####
# Programmer: S.Ahmed 
# Orig Date: July 1, 2021
#### Steps: import PLHIV data from UNAIDS file, organize columns, create PEPFAR regions; drop non-PEPFAR OUs



#### Load necessary packages
library ("tidyverse")
library ("openxlsx")
library ("readxl")


####import a PLHIV dataset
unaid <- read_xlsx ("C:/Users/lqa9/Desktop/DGHT PLHIV VLC dash/UNAIDS_raw.xlsx", sheet = "unaids")



#### transformations to UNAIDS PLHIV ####
# group in to regions, summarize their results, add 2021 from NAT/SUBNAT eventually 
`%notin%` <- Negate(`%in%`)

unaid2 <- unaid %>%
  rename(countryname = ou) %>%
  mutate(operatingunit = 
           if_else(countryname %in% c("Myanmar", "China", "India", "Indonesia", "Kazakhstan", "Kyrgyzstan", "Laos", "Nepal",
                                      "Papua New Guinea", "Philippines", "Tajikistan", "Thailand"), "Asia Region", 
                   if_else(countryname %in% c("Burkina Faso", "Ghana", "Liberia", "Mali", "Senegal", "Sierra Leone", "Togo"), 
                           "West Africa Region",
                           if_else(countryname %in% c("Barbados", "Brazil", "El Salvador", "Guatemala", "Guyana", "Honduras",
                                                      "Jamaica", "Nicaragua", "Panama", "Suriname", "Trinidad and Tobago"),
                                                      "Western Hemisphere Region",countryname)))) %>%
  filter(operatingunit %notin% c("Central African Republic", "Congo", "Guinea-Bissau")) 
# any OUs not in PEPFAR, include in above line for removal   


View(count(unaid2, operatingunit, countryname, indicator))
write.xlsx(unaid2, "C:/Users/lqa9/Desktop/DGHT PLHIV VLC dash/unaidsdatasetAug12.xlsx", sheetName = "unaids")
#write_tsv(master, "C:/Users/lqa9/Desktop/DGHT PLHIV VLC dash/datasetJuly2.txt", na = "")



