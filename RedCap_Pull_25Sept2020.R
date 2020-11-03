library(RCurl)
library(data.table)
library(tidyverse)
library(dplyr)
library(httr)

setwd("C:/Users/oyd6/CDC/CGH-DGHT-KeyPopulations - Documents/Index Testing Certification Materials")

#Pulling English in raw results table
result_eng <- postForm(
  uri='https://airc.cdc.gov/api/',
  token='66DA42990EB09331D2C8A8C6E2E41A34',
  content='report',
  format='csv',
  report_id='1016',
  rawOrLabel='raw',
  rawOrLabelHeaders='raw',
  exportCheckboxLabel='false',
  returnFormat='csv'
)
con_eng <- textConnection(result_eng)
df_eng <- read.csv(con_eng, na.strings =c("", "NA"))
df_eng <- df_eng %>% mutate(record_id = paste0("100",record_id))
df_eng$record_id <- as.numeric(df_eng$record_id)

#Pulling Spanish in raw results table
result_spa <- postForm(
  uri='https://airc.cdc.gov/api/',
  token='21B35B03073AF171E9232AF83EE38EDD',
  content='report',
  format='csv',
  report_id='1009',
  rawOrLabel='raw',
  rawOrLabelHeaders='raw',
  exportCheckboxLabel='false',
  returnFormat='csv'
)
con_spa <- textConnection(result_spa)
df_spa <- read.csv(con_spa, na.strings =c("", "NA"))
df_spa <- df_spa %>% mutate(record_id = paste0("200",record_id))
df_spa$record_id <- as.numeric(df_spa$record_id)

#Pulling Portuguese in raw results table
result_por <- postForm(
  uri='https://airc.cdc.gov/api/',
  token='1BBD6770A8A5820331F150497C711598',
  content='report',
  format='csv',
  report_id='1010',
  rawOrLabel='raw',
  rawOrLabelHeaders='raw',
  exportCheckboxLabel='false',
  returnFormat='csv'
)
con_por <- textConnection(result_por)
df_por <- read.csv(con_por, na.strings =c("", "NA"))
df_por <- df_por %>% mutate(record_id = paste0("300",record_id))
df_por$record_id <- as.numeric(df_por$record_id)


#Pulling French in raw results table
result_fr <- postForm(
  uri='https://airc.cdc.gov/api/',
  token='76AFD42C36FCA0E032BE9612E4ADB98E',
  content='report',
  format='csv',
  report_id='1011',
  rawOrLabel='raw',
  rawOrLabelHeaders='raw',
  exportCheckboxLabel='false',
  returnFormat='csv'
)
con_fr <- textConnection(result_fr)
df_fr <- read.csv(con_fr, na.strings =c("", "NA"))
df_fr <- df_fr %>% mutate(record_id = paste0("400",record_id))
df_fr$record_id <- as.numeric(df_fr$record_id)
df_fr <- df_fr %>% rename(kp_index_testing_minimum_requirements_complete = index_testing_minimum_requirements_complete)

#Pulling Russian in raw results table
result_ru <- postForm(
  uri='https://airc.cdc.gov/api/',
  token='60A82D6E01921193170F1E8B7B8F4743',
  content='report',
  format='csv',
  report_id='1012',
  rawOrLabel='raw',
  rawOrLabelHeaders='raw',
  exportCheckboxLabel='false',
  returnFormat='csv'
)
con_ru <- textConnection(result_ru)
df_ru <- read.csv(con_ru, na.strings =c("", "NA"))
df_ru <- df_ru %>% mutate(record_id = paste0("500",record_id))
df_ru$record_id <- as.numeric(df_ru$record_id)

#Pulling Ethiopia in raw results table
result_eth <- postForm(
  uri='https://airc.cdc.gov/api/',
  token='075A40444B0C1E634A2A469E6549CE47',
  content='report',
  format='csv',
  report_id='1017',
  rawOrLabel='raw',
  rawOrLabelHeaders='raw',
  exportCheckboxLabel='false',
  returnFormat='csv'
)
con_eth <- textConnection(result_eth)
df_eth <- read.csv(con_eth, na.strings =c("", "NA"))
df_eth <- df_eth %>% mutate(record_id = paste0("600",record_id))
df_eth$other_16b_2 <- NA_character_
df_eth$upload_17g <- NA_character_
df_eth$train_docs <- NA_character_
df_eth$postrain_docs <- NA_character_
df_eth$ipvtrain_docs <- NA_character_
df_eth$kp_legal___1 <- NA_character_
df_eth$kp_legal___2 <- NA_character_
df_eth$kp_legal___3 <- NA_character_
df_eth$kp_legal___4 <- NA_character_
df_eth$record_id <- as.numeric(df_eth$record_id)

#Cleaning first step
df_eng$indexnum <- as.integer(df_eng$indexnum)
df_eng$total_providers <- as.integer(df_eng$total_providers)

#Appending all results in one mega 
df0 <- bind_rows(df_eng, df_spa, df_por, df_fr, df_ru)

#Exporting Very Raw dataset for ICPI aggregation
write.csv(df0, "IndexTesting_Very_Raw.csv", row.names=F,na = "")

#Pulling in Data Dictionary
dataDictionary <- postForm(
  uri='https://airc.cdc.gov/api/',
  token='66DA42990EB09331D2C8A8C6E2E41A34',
  content='metadata',
  format='csv',
  returnFormat='csv'
)
con_dd <- textConnection(dataDictionary)
dd <- read.csv(con_dd)

#Exporting Data Dictionary for ICPI aggregation
write.csv(dd, "IndexTesting_Data_Dictionary.csv", row.names=F,na = "")

# Data cleaning

# trim all white space and make strings not be factors
df <- data.frame(lapply(df0, trimws), stringsAsFactors = FALSE)
dd <- data.frame(lapply(dd, trimws), stringsAsFactors = FALSE)

# convert all characters to uppercase for ease of analysis
df <- data.frame(lapply(df, function(v) {
  if (is.character(v)) return(toupper(v))
  else return(v)
}))

# Replace all unchecked with 0 and checked with 1
df <- data.frame(lapply(df, function(x) {gsub("UNCHECKED", "0", x)}), stringsAsFactors = FALSE)
df <- data.frame(lapply(df, function(x) {gsub("CHECKED", "1", x)}), stringsAsFactors = FALSE)

# Create a variable for all rows that will be dropped
df$drop <- 0

#Drop India sites


# Exclude blank rows
df$drop[which(is.na(df$ou_name)|is.na(df$fclty_name))] <- 1

# Exclude scores 1 or less
df$finalscore <- as.numeric(df$finalscore)
df$drop[which(df$finalscore<=1)] <- 1
df$drop[which(is.na(df$finalscore))] <- 1

# Exclude names whose name has only one character in string
df$drop[which(nchar(df$ip_name)<=1)] <- 1

# Exclude names that have an xx or test or dummy in them
df$drop[grepl("XX|TEST|DUMMY", df$ip_name)] <- 1 
df$drop[grepl("XX|TEST|DUMMY", df$fclty_name)] <- 1 
df$drop[grepl("XX|TEST|DUMMY", df$assess_name)] <- 1 

#Cleaning up IP Names
df$ip_name_old <- df$ip_name
df$ip_name[grepl("ANGLICARE", df$ip_name)] <- "ANGLICARE"
df$ip_name[grepl("ANOVA", df$ip_name)] <- "ANOVA HEALTH INSTITUTE"
df$ip_name[grepl("ANOVQ", df$ip_name)] <- "ANOVA HEALTH INSTITUTE"
df$ip_name[grepl("AURUM", df$ip_name)] <- "AURUM INSTITUTE"
df$ip_name[grepl("AURUUM", df$ip_name)] <- "AURUM INSTITUTE"
df$ip_name[grepl("DAPP", df$ip_name)] <- "DAPP"
df$ip_name[grepl("FHI", df$ip_name)] <- "FHI360"
df$ip_name[grepl("HST|TRUST|TRSUT", df$ip_name)] <- "HEALTH SYSTEMS TRUST"
df$ip_name[grepl("INTRAHEALTH", df$ip_name)] <- "INTRAHEALTH"
df$ip_name[grepl("ITECH|I-TECH|- TECH", df$ip_name)] <- "I-TECH"
df$ip_name[grepl("SOLUTION|CHS", df$ip_name)] <- "CENTER FOR HEALTH SOLUTIONS"
df$ip_name[grepl("PSI", df$ip_name)] <- "PSI"
df$ip_name[grepl("WITS|RHI", df$ip_name)] <- "WITS RHI"
df$ip_name[grepl("UZIMA", df$ip_name)] <- "CHAK-CHAP UZIMA"
df$ip_name[df$ip_name=="SS"] <- "SOLEDAD SOTOMAYOR"
df$ip_name[df$ip_name=="FPD"] <- "FOUNDATION FOR PROFESSIONAL DEVELOPMENT"

#Cleaning Kenya Names
df$ip_name[df$ou_name=="52" & grepl("UNIVERSITY OF MARYLAND", df$ip_name)] <- "UMB"
df$ip_name[df$ou_name=="57" & grepl("KCCB", df$ip_name)] <- "KCCB-KARP"
df$ip_name[df$ou_name=="57" & grepl("EADRP", df$ip_name)] <- "EDARP"
df$ip_name[df$ou_name=="57" & grepl("DEANERY", df$ip_name)] <- "EDARP"
df$ip_name[df$ou_name=="57" & grepl("SLUMS OF NAIROBI", df$ip_name)] <- "FAITH BASED SITES IN THE EASTERN SLUMS OF NAIROBI"
df$ip_name[df$ou_name=="57" & grepl("CHAK", df$ip_name)] <- "CHAK-CHAP UZIMA"


#Cleaning Bots IP Names
df$ip_name[df$ou_name=="31" & grepl("Umbrella", df$ip_name)] <- "MK UMBRELLA"


#Cleaning Malawi Names
df$ip_name[df$ou_name=="57" & grepl("EGPAF", df$ip_name)] <- "EGPAF"
df$ip_name[df$ou_name=="57" & grepl("ELIZABETH", df$ip_name)] <- "EGPAF"

#Cleaning Namibia IP Names
df$ip_name[df$ou_name=="60" & grepl("TCE", df$ip_name)] <- "TCE & MOHSS"
df$ip_name[df$ou_name=="60" & grepl("HOPE", df$ip_name)] <- "MOHSS, PROJECT HOPE"
df$ip_name[df$ou_name=="60" & grepl("TRAINING AND EDUCATION", df$ip_name)] <- "I-TECH"

#Cleaning Nigeria IP Names
df$ip_name[df$ou_name=="63" & grepl("APIN", df$ip_name)] <- "APIN"
df$ip_name[df$ou_name=="63" & grepl("VIROLOGY", df$ip_name)] <- "IHVN"
df$ip_name[df$ou_name=="63" & grepl("HVN", df$ip_name)] <- "IHVN"

#Cleaning South Africa IP Names
df$ip_name[df$ou_name=="68" & grepl("HEALTH", df$ip_name)] <- "HEALTH SYSTEMS TRUST"
df$ip_name[df$ou_name=="68" & grepl("MK", df$ip_name)] <- "MK UMBRELLA"
df$ip_name[df$ou_name=="68" & grepl("UMBRELLA", df$ip_name)] <- "MK UMBRELLA"
df$ip_name[df$ou_name=="68" & grepl("TB", df$ip_name)] <- "TB/HIV CARE"

#Cleaning Zim IP Names
df$ip_name[df$ou_name=="79" & df$ip_name == "I-TECH" ] <- "ZIM-TTECH"
df$ip_name[df$ip_name=="ZIMTTECH"] <- "ZIM-TTECH"
df$ip_name[df$ip_name=="ZIM-TECH"] <- "ZIM-TTECH"

#Cleaning Zambia IP Names
df$ip_name[df$ou_name=="78" & grepl("CATHOLIC", df$ip_name)] <- "CRS"
df$ip_name[df$ou_name=="78" & grepl("ICAP", df$ip_name)] <- "ICAP"
df$ip_name[df$ou_name=="78" & grepl("SOUTH", df$ip_name)] <- "SPHO"
df$ip_name[df$ou_name=="78" & grepl("WEST", df$ip_name)] <- "WPHO"
df$ip_name[grepl("WPHO", df$ip_name)] <- "WPHO"



check <- df[,c("ip_name", "ip_name")]
 
#Dropping records where drop == 0
df <- df[which(df$drop==0),]

#Creating variable to indicate if site has passed assessment with minimum score
df$finalscore <- as.double(df$finalscore)
df <- df %>% mutate(result = case_when(
  finalscore  == 33 ~ 1,
  finalscore < 33 ~ 0,
  TRUE ~ NA_real_
))

#Renaming Q32
df <- df %>% rename(checklist_17f = yn_17f)
dd <- dd %>% mutate(field_name = case_when(
  field_name == "yn_17f" ~ "checklist_17f",
  TRUE ~ field_name
))

#Outputting OU/IP List
#ou_ip <- df %>% group_by(ou_name, ip_name) %>% count()
#write.csv(ou_ip, "ou_ip_list.csv", row.names=F,na = "")

#Deduplicating Facilities. Taking the assessment with the highest score, then date for each facility
df1 <- df[order(as.numeric(df$finalscore), as.Date(df$assess_date), decreasing = TRUE),]
df2 <- df1[order(df1$fclty_name, df1$ip_name, df1$ou_name, decreasing = FALSE),]
df2 <- df2 %>% distinct(ou_name,ip_name,fclty_name, .keep_all = TRUE)
df <- df2

#Creating value & variable labels
checklist_17f_labels <- data.frame(
  c("checklist_17f", "checklist_17f"),c("0", "1"), c("No/None/Never", "Yes/All/Always"), stringsAsFactors = FALSE)
names(checklist_17f_labels) <- c("field_name", "code", "label")
labels <- dd %>% filter(field_name != "finalscore" & field_name != "fclty_name") %>% select(field_name, select_choices_or_calculations) %>%
  as.data.frame(stringsAsFactors = FALSE) %>% 
  mutate(select_choices_or_calculations = strsplit(as.character(select_choices_or_calculations), "[|]")) %>% 
  unnest(select_choices_or_calculations) %>% separate(select_choices_or_calculations, c("code", "label"), ",") %>% 
  lapply(trimws) %>% rbind(checklist_17f_labels) %>% as.data.frame(stringsAsFactors = FALSE)
field_labels <- dd  %>% select(field_name, field_label) %>% as.data.frame(stringsAsFactors = FALSE)
VNums <- dd %>% distinct(field_name) %>% mutate(VariableNum = row_number())


#Applying value labels & creating long dataset
df_long <- df %>% gather(Variable, Value_raw, -c(record_id, ou_name, ip_name, fclty_name, assess_name, assessor_email, assess_date)) %>% 
  left_join(labels, by = c("Variable" = "field_name", "Value_raw" = "code")) %>% 
  mutate(Value = case_when(
    !is.na(label) ~ label,
    is.na(label) ~ Value_raw,
    TRUE ~ NA_character_
  )) %>% left_join(field_labels, by = c("Variable" = "field_name")) %>% left_join(VNums, by = c("Variable" = "field_name")) %>%
  rename(Variable_Description = field_label) %>% select(-c(Value_raw, label)) %>% filter(Variable != "upload_17g")

#Applying value labels to wide raw dataset
df <- df %>% gather(Variable, Value_raw, -c(record_id)) %>% left_join(labels, by = c("Variable" = "field_name", "Value_raw" = "code")) %>% 
  mutate(Value = case_when(
    !is.na(label) ~ label,
    is.na(label) ~ Value_raw,
    TRUE ~ NA_character_
  )) %>%
  select(record_id, Variable, Value) %>% spread(Variable, Value) %>% 
  setcolorder(colnames(df))

#Creating long score only dataframe
scores <- df_long %>% filter(grepl("checklist", Variable)) %>% rename(ChecklistItem = Variable) %>% rename(Response = Value)
QNums <- scores %>% distinct(ChecklistItem) %>% mutate(Question = row_number())
scores <- scores %>% 
  mutate(Category = case_when(
    grepl("11", ChecklistItem) ~ "Counseling",
    grepl("12", ChecklistItem) ~ "Informed Consent",
    grepl("13", ChecklistItem) ~ "Confidentiality",
    grepl("14", ChecklistItem) ~ "Connection to services",
    grepl("15", ChecklistItem) ~ "IPV Risk Assessment",
    grepl("16", ChecklistItem) ~ "Training and Supporitve Supervision",
    grepl("17", ChecklistItem) ~ "Adverse Events and Response",
    TRUE ~ NA_character_
  )) %>% 
  left_join(QNums, by = "ChecklistItem")  %>% select(record_id:ChecklistItem, Category, Question, Response, Variable_Description)

#Cleaning up variable descriptions (removing html info)
df_long$Variable_Description <- gsub("<[^>]+>", "",df_long$Variable_Description)
scores$Variable_Description <- gsub("<[^>]+>", "",scores$Variable_Description)

#Outputting files for Power BI
write.csv(df, "IndexTesting_Raw.csv", row.names=F,na = "")
write.csv(df_long, "IndexTesting_Long.csv", row.names=F,na = "")
write.csv(scores, "IndexTesting_Scores.csv", row.names=F,na = "")

