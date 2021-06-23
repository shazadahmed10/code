

#### Next Steps: 
# only keep indicators to be analyzed (the checklist questions and other non-text reponses)
# go long
# create a spearate dataset with the qualitateive/leftover indicators
# split into OU specific datasets for both
# check on SNU info for CDC








#install.packages("janitor")

library("tidyverse")
library("openxlsx")
library("janitor")


#### open CDC dataset. use Raw, which is processed.
cdc <- read_csv("C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/CDC/IndexTesting_Raw Mar312021.csv", 
                col_types  = cols(record_id= "c",
                                  train_type___1 = "c",
                                  train_type___2 = "c"))


#### open USAID dataset. from 3/31.
#### before opening, find and replace in csv and get rid of _v2 in the values
aid <- read_csv("C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/USAID/USAID index to 3.31.21 v1.csv")


#### Dod Aggregate data: OU level, no sites
dod <- read_csv("C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/DoD/DOD Aggregated Scores_PEPFAR.csv")

# compare columns between two sources to see incompaitbilities 
#View(compare_df_cols(aid, cdc))


# add agency columns & recode country names in aid dataset. 
#Also renamed assess_date column in USAID dataset because I can't reconcile yet
aid2 <- aid %>% 
  mutate(agency = "usaid")
# appears that all usaid columns have "_v2" in them. need to get rid of this
names(aid2) <- sub("_v2", "", names(aid2))

  #rename(assess_date_usaid_v2 = assess_date_v2)
cdc2 <- mutate(cdc, agency = "cdc")

# Dod modifications: rename columns and add agency
dod2 <- mutate(dod, agency = "dod")
dod2 <- rename(dod2, ip_name = Partner, countryname = Country, finalscore = `Average Score`)


#Create a long dataset for cdc for all categorical responses(checklist responses will be long, other info will repeat row after row by unique site, IP, data combo) 
cdc3 <- gather (cdc2, key = "question", value = "response", 
                   checklist_11a:checklist_11d, checklist_12a:checklist_12e, checklist_13a:checklist_13f, checklist_14a:checklist_14b,
                   checklist_15a:checklist_15f, checklist_16a:checklist_16d, checklist_17a:checklist_17e, 
                   checklist_17f, na.rm = FALSE)

#rename columns so overlapping columns match between both
cdc4 <- rename(cdc3, countryname= ou_name )



aid3 <- aid2 %>% 
  rename(countryname = OU, question = Question, response = `score values`, record_id = `unique record id`, 
         question_category = `Question Category`, question_text = `Question text`, q = `Q code`, orgunituid = Orgunituid,
         kp_index_testing_minimum_requirements_complete_usaid = kp_index_testing_minimum_requirements_generic_complete) %>%
  select(-c(q)) 


# stack to one another
global <- bind_rows(cdc4, aid3, dod2)
View(count(global, countryname, agency, question, response))



#reorder columns; recode some yesno columns; create customized question labels in question_text columns
global2 <- global %>% 
  select(record_id, countryname, agency, assess_date, assessment_type, question, question_text, response, question_category, finalscore, 
         everything()) %>%
  mutate(ipvtrain = recode(ipvtrain, `1` = "Yes", `0` = "No")) %>%
  mutate(commfeedback = recode(commfeedback, `1` = "Yes", `0` = "No")) %>%
  mutate(kp_grps = recode(kp_grps, `1` = "Yes", `0` = "No")) %>%
  mutate(kp_index_testing_minimum_requirements_complete = 
           recode(kp_index_testing_minimum_requirements_complete, `2`="Complete", `1` = "Unverified", `0` = "Incomplete")) %>%
  rename(site_finalscore = finalscore) %>%
  mutate(question_text = 
           if_else(question == "checklist_11a","1.1a: pre-test counseling",
                   if_else(question == "checklist_11b", "1.1b: risks/benefits of ICT",
                           if_else(question == "checklist_11c", "1.1c: review four approaches",
                                   if_else(question == "checklist_11d", "1.1d: anonymous notification", question_text
                                           ))))) %>%
  mutate(question_text = 
           if_else(question == "checklist_12a", "1.2a: voluntary informed consent",
                   if_else(question == "checklist_12b", "1.2b: right to decline",
                           if_else(question == "checklist_12c", "1.2c: reconfirm consent",
                                   if_else(question == "checklist_12d", "1.2d: patient rights posted",
                                           if_else(question == "checklist_12e", "1.2e: how to report violations and get support", question_text
                                                   )))))) %>%
  mutate(question_text = 
           if_else(question == "checklist_13a", "1.3a: private space for ICT",
                   if_else(question == "checklist_13b", "1.3b: patient info is secure",
                           if_else(question == "checklist_13c", "1.3c: confidentiality agreement",
                                   if_else(question == "checklist_13d", "1.3d: data sharing agreement",
                                           if_else(question == "checklist_13e", "1.3e: SOP for provider assisted notification",
                                                   if_else(question == "checklist_13f", "1.3f: ICT register includes risk group", question_text
                                                           ))))))) %>% 
  mutate(question_text =
           if_else(question == "checklist_14a", "1.4a: linkage to ART procedures",
                   if_else(question == "checklist_14b", "1.4b: linkage to prevention", question_text
                           ))) %>% 
  mutate(question_text = 
           if_else(question == "checklist_15a", "1.5a: IPV risk assessment for partner",
                   if_else(question == "checklist_15b", "1.5b: document IPV risk",
                           if_else(question == "checklist_15c", "1.5c: SOP to ensure client safety",
                                   if_else(question == "checklist_15d", "1.5d: providers trained on LIVES",
                                           if_else(question == "checklist_15e", "1.5e: list of supportive services",
                                                   if_else(question == "checklist_15f", "1.5f: referral system to KP/PLHIV", question_text
                                                           ))))))) %>%
  mutate(question_text = 
           if_else(question == "checklist_16a", "1.6a: trained using standard curriculum",
                   if_else(question == "checklist_16b", "1.6b: training emphasizes patient rights",
                           if_else(question == "checklist_16c", "1.6c: completed at least one supportive supervison assessment",
                                   if_else(question == "checklist_16d", "1.6d: ongoing mentoring/supervision plan", question_text
                                           ))))) %>%
  mutate(question_text =
           if_else(question == "checklist_17a", "1.7a: providers trained on AE monitoring",
                   if_else(question == "checklist_17b", "1.7b: site has AE monitoring system",
                           if_else(question == "checklist_17c", "1.7c: providers routinely assess for AE",
                                   if_else(question == "checklist_17d", "1.7d: process for clients to anonymously report AE",
                                           if_else(question == "checklist_17e", "1.7e: process for providers to anonymously report AE",
                                                   if_else(question == "checklist_17f", "1.7f: site has SOP for investigating AE", question_text
                                                           )))))))



View(count(global2, question, question_text))
   


#harmonize format of assess_date_usaid attempt:
#global2$assess_date_usaid <- format(global2$assess_date_usaid , format = "%d/%m/%y")
#View(count(global2, assess_date_usaid))


#Export wide dataset
#write.xlsx(global2, "C:/Users/lqa9/Desktop/Files/Index Testing Coop/REDCap assessment work/globalNov17.xlsx", na = "")
#write.csv(global2, "C:/Users/lqa9/Desktop/Files/Index Testing Coop/REDCap assessment work/globalDec3.csv", na = "", row.names = FALSE)



#assigning categories; removing empty columns; fixing duplicate ou names; adding region column 
global3 <- global2 %>% mutate(question_category = 
           if_else (question %in% c("checklist_11a", "checklist_11b", "checklist_11c", "checklist_11d"), "Counseling", 
                    if_else(question %in% c("checklist_12a", "checklist_12b", "checklist_12c", "checklist_12d", "checklist_12e"), "Informed Consent",
                        if_else(question %in% c("checklist_13a", "checklist_13b", "checklist_13c", "checklist_13d", "checklist_13e", "checklist_13f"), "Confidentiality",
                                if_else(question %in% c("checklist_14a", "checklist_14b"), "Connection to Services",
                                        if_else(question %in% c("checklist_15a", "checklist_15b", "checklist_15c", "checklist_15d", "checklist_15e", "checklist_15f"), "IPV",
                                                if_else(question %in% c("checklist_16a", "checklist_16b", "checklist_16c", "checklist_16d"), "Training and Supportive Supervision",
                                                        if_else(question %in% c("checklist_17a", "checklist_17b", "checklist_17c", "checklist_17d", "checklist_17e", "checklist_17f"), "Adverse Events Monitoring",""
                                                                )))))))) %>%
  select(-c(assess_name, assessor_email, facility_poc, comments, yn_17f)) %>%
  mutate(countryname = 
           if_else(countryname == "Democratic Republic of the Congo", "DRC",
                   if_else(countryname == "Dom Rep", "DR",
                           if_else(countryname == "Dominican Republic", "DR", 
                                   if_else(countryname == "Papua New Guinea", "PNG", countryname
                                   ))))) %>%
  mutate(operatingunit= 
           if_else(countryname %in% c("Barbados", "Brazil", "El Salvador", "Guatemala", "Guyana", "Honduras", "Jamaica", "Nicaragua", "Panama",
                             "Trinidad & Tobago"), "West Hem",
                   if_else(countryname %in% c("Burkina Faso", "Ghana", "Liberia", "Mali", "Senegal", "Togo"), "West Africa",
                           if_else(countryname %in% c("Cambodia", "India", "Indonesia", "Thailand", "Laos", "Kazakhstan", "Kyrgyzstan",
                                             "Nepal", "Tajikistan"), "Asia", countryname
                                             )))) %>%
  select(record_id, operatingunit, countryname, agency, assess_date, assessment_type, question, question_text, response, question_category, site_finalscore, 
         everything()) 



View(count(global3, question, question_category))
View(count(global3, countryname, region))

#for cells with n/a, give them a 'no repsonse' value to allow graphs to include N/As
global3$response[is.na(global3$response)] <- "No Response"


                 
#Export Long
write.csv(global3, "C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/global_long_June07.csv", na = "", row.names = FALSE)


#### IF CREATING GLOBAL DATASET ONLY STOP HERE ####
#### FOR OU specific DATASET, CONTINUE WITH SCRIPT ####
#for automation; I need one dataset per OU
View(count(global3, ou))


Ou <- filter(global3, ou == "Angola")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Angola.xlsx")
Ou <- filter(global3, ou == "Botswana")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Botswana.xlsx")
Ou <- filter(global3, ou == "Burma")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Burma.xlsx")
Ou <- filter(global3, ou == "Burundi")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Burundi.xlsx")
Ou <- filter(global3, ou == "Cameroon")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Cameroon.xlsx")
Ou <- filter(global3, ou == "Cote d'Ivoire")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Cote d'Ivoire.xlsx")
Ou <- filter(global3, ou == "DR")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/DR.xlsx")
Ou <- filter(global3, ou == "DRC")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/DRC.xlsx")
Ou <- filter(global3, ou == "Eswatini")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Eswatini.xlsx")
Ou <- filter(global3, ou == "Ethiopia")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Ethiopia.xlsx")
Ou <- filter(global3, ou == "Haiti")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Haiti.xlsx")
Ou <- filter(global3, ou == "Kenya")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Kenya.xlsx")
Ou <- filter(global3, ou == "Lesotho")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Lesotho.xlsx")
Ou <- filter(global3, ou == "Malawi")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Malawi.xlsx")
Ou <- filter(global3, ou == "Mozambique")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Mozambique.xlsx")
Ou <- filter(global3, ou == "Namibia")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Namibia.xlsx")
Ou <- filter(global3, ou == "Nigeria")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Nigeria.xlsx")
Ou <- filter(global3, ou == "PNG")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/PNG.xlsx")
Ou <- filter(global3, ou == "Rwanda")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Rwanda.xlsx")
Ou <- filter(global3, ou == "South Africa")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/South Africa.xlsx")
Ou <- filter(global3, ou == "South Sudan")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/South Sudan.xlsx")
Ou <- filter(global3, ou == "Tanzania")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Tanzania.xlsx")
Ou <- filter(global3, ou == "Vietnam")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Vietnam.xlsx")
Ou <- filter(global3, ou == "Zambia")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Zambia.xlsx")
Ou <- filter(global3, ou == "Zimbabwe")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Zimbabwe.xlsx")
#regional programs
Ou <- filter(global3, region == "Asia")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/Asia.xlsx")
Ou <- filter(global3, region == "West Hem")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/West Hem.xlsx")
Ou <- filter(global3, region == "West Africa")
write.xlsx(Ou,"C:/Users/lqa9/OneDrive - CDC/Files/HTS/Index Testing Coop/REDCap assessment work/OU Datasets/West Africa.xlsx")
