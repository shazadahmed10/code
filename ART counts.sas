*******************************
Programmer: Shazad Ahmed
Purpose: To get site counts of all site giving ART to kids and adults
Date: 06/11/18
*******************************;

*PROCESS: import site level dataset, subset by indicator and isMCAD = Y. Then, drop unwatned time periods, stack time periods vertically,
delete blank rows, sort by unique site/IM/time period/ age. Then, stack all OUs together. Perofrm separate macros for Burma/Burundi
due to different .txt coloumn order***
CONDITIONS: removed Dedup since that's is not true data entry. Entry of 0 is considered not reported. ; 

%let date = 20180613; *<- update with current date;*



options compress = yes;
%macro artcount(ou, nxtx);


/*Choosing country;*/
/******** 1) Pulling data *******************************/


/*Pulling the data using appropriate length statments to avoid truncation*/
data &ou;
infile "C:\Users\lqa9\Desktop\18Q2 Data\Site\ICPI_MER_Structured_Dataset_SITE_IM_FY17-18_&ou._20180515_v1_1.txt"
delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2;
informat orgUnitUID $50. ;
informat SiteName  $100. ;
informat Region $255. ;
informat RegionUID $50. ;
informat OperatingUnit $255. ;
informat OperatingUnitUID $50. ;
informat CountryName $255. ;
informat SNU1 $255. ;
informat SNU1UID $50. ;
informat PSNU $255. ;
informat PSNUuid $50. ;
informat SNUPrioritization  $26. ;
informat typeMilitary $1. ;
informat mechanismUID $28. ;
informat PrimePartner $250. ;
informat FundingAgency $30. ;
informat MechanismID $50. ;
informat ImplementingMechanismName $350. ;
informat CommunityUID $50. ; 
informat Community $75.;   
informat CommunityPrioritization $50.;   
informat FacilityUID $50. ;
informat Facility $75.;  
informat FacilityPrioritization  $50.;
informat SiteType $20. ;  
informat dataElementUID $255. ;
informat indicator $255. ;
informat numeratorDenom $2. ;
informat indicatorType $25. ;
informat disaggregate $50. ;
informat standardizedDisaggregate $100. ;
informat categoryOptionComboUID $255. ;
informat categoryOptionComboName $55. ;
informat AgeAsEntered $50. ;
informat AgeFine $50. ;
informat AgeSemiFine $50. ;
informat AgeCoarse $50. ;
informat Sex $50. ;
informat resultStatus $50. ;
informat otherDisaggregate $55. ;
informat coarseDisaggregate $50. ;
informat modality $100.;
informat isMCAD $5.;
/*informat FY2015Q2 BEST32.;*/
/*informat FY2015Q3 BEST32.;*/
/*informat FY2015Q4 BEST32.;*/
/*informat FY2015APR BEST32.;*/
/*informat FY2016_TARGETS BEST32.;*/
/*informat FY2016Q1 BEST32.;*/
/*informat FY2016Q2 BEST32.;*/
/*informat FY2016Q3 BEST32.;*/
/*informat FY2016Q4 BEST32.;*/
/*informat FY2016APR BEST32.;*/
informat FY2017_TARGETS BEST32.;
informat FY2017Q1 BEST32.;
informat FY2017Q2 BEST32.;
informat FY2017Q3 BEST32.;
informat FY2017Q4 BEST32.;
informat FY2017APR BEST32.;
informat FY2018_TARGETS BEST32.;
informat FY2018Q1 BEST32.;
informat FY2018Q2 BEST32.;



format orgUnitUID $50. ;
format SiteName $100. ;
format Region $255. ;
format RegionUID $50. ;
format OperatingUnit $255. ;
format OperatingUnitUID $50. ;
format CountryName $255. ;
format SNU1 $255. ;
format SNU1UID $50. ;
format PSNU $255. ;
format PSNUuid $50. ;
format SNUPrioritization  $26. ;
format typeMilitary $1. ;
format mechanismUID $28. ;
format PrimePartner $250. ;
format FundingAgency $30. ;
format MechanismID $50. ;
format ImplementingMechanismName $350. ;
format CommunityUID $50. ; 
format Community $75.;   
format CommunityPrioritization $50.;   
format FacilityUID $50. ;   
format Facility $75. ; 
format FacilityPrioritization  $50.;
format SiteType $20. ;   
format dataElementUID $255. ;
format indicator $255. ;
format numeratorDenom $2. ;
format indicatorType $25. ;
format disaggregate $50. ;
format standardizedDisaggregate $100. ;
format categoryOptionComboUID $255. ;
format categoryOptionComboName $55. ;
format AgeAsEntered $50. ;
format AgeFine $50. ;
format AgeSemiFine $50. ;
format AgeCoarse $50. ;
format Sex $50. ;
format resultStatus $50. ;
format otherDisaggregate $55. ;
format coarseDisaggregate $50. ;
format modality $100.;
format isMCAD $5.;
/*format FY2015Q2 BEST32.;*/
/*format FY2015Q3 BEST32.;*/
/*format FY2015Q4 BEST32.;*/
/*format FY2015APR BEST32.;*/
/*format FY2016_TARGETS BEST32.;*/
/*format FY2016Q1 BEST32.;*/
/*format FY2016Q2 BEST32.;*/
/*format FY2016Q3 BEST32.;*/
/*format FY2016Q4 BEST32.;*/
/*format FY2016APR BEST32.;*/
format FY2017_TARGETS BEST32.;
format FY2017Q1 BEST32.;
format FY2017Q2 BEST32.;
format FY2017Q3 BEST32.;
format FY2017Q4 BEST32.;
format FY2017APR BEST32.;
format FY2018_TARGETS BEST32.;
format FY2018Q1 BEST32.;
format FY2018Q2 BEST32.;

input 
orgUnitUID $
SiteName $
Region $
RegionUID $
OperatingUnit $
OperatingUnitUID $
CountryName $
SNU1 $
SNU1UID $
PSNU $
PSNUuid $
SNUPrioritization $
typeMilitary $
mechanismUID $
PrimePartner $
FundingAgency $
MechanismID $
ImplementingMechanismName $
CommunityUID $
Community $
CommunityPrioritization $
FacilityUID $
Facility $
FacilityPrioritization $
SiteType $
dataElementUID $
indicator $
numeratorDenom $
indicatorType $
disaggregate $
standardizedDisaggregate $
categoryOptionComboUID $
categoryOptionComboName $
AgeAsEntered $
AgeFine $
AgeSemiFine $
AgeCoarse $
Sex $
resultStatus $
otherDisaggregate $
coarseDisaggregate $
modality $
isMCAD $
/*FY2015Q2*/
/*FY2015Q3*/
/*FY2015Q4*/
/*FY2015APR*/
/*FY2016_TARGETS*/
/*FY2016Q1*/
/*FY2016Q2*/
/*FY2016Q3*/
/*FY2016Q4*/
/*FY2016APR*/
FY2017_TARGETS
FY2017Q1 
FY2017Q2
FY2017Q3
FY2017Q4
FY2017APR 
FY2018_TARGETS
FY2018Q1
FY2018Q2;

RUN;



/*Creating SiteID variable from Facility, Community, and Military UID
  Creating */
data &ou._1;
set &ou;
where indicator = "TX_CURR" AND isMCAD = "Y";
rename orgUnitUID = SiteID;
if fundingagency = "Dedup" then delete;
RUN;



***Only Fy18 uses age/sex/result and age aggregated/sex/result, so keep only those rows for Fy18. Drop Fy17 values for those disaggs**;
 data &ou._2;
 set &ou._1;
drop FY2017_TARGETS
FY2017Q1
FY2017Q2
FY2017Q3
FY2017APR
FY2018_TARGETS;
 run;


 ***deleting blank rows from FactView to shorten file size***;
data &ou._3;
set &ou._2;
if Fy2017Q4 = 0 then Fy2017Q4 = .;
if Fy2018Q1 = 0 then Fy2018Q1 = .;
if Fy2018Q2 = 0 then Fy2018Q2 = .;
if FY2017Q4 = . & Fy2018Q1 = . & Fy2018Q2 =. then delete;
run; 


/*Arranging the data for output*/
data &ou._4;
retain
OperatingUnit
SNU1
PSNU
PrimePartner
FundingAgency
MechanismID
ImplementingMechanismName
indicator
numeratorDenom
indicatorType
standardizeddisaggregate
FY2017Q4
FY2018Q1
Fy2018Q2
SiteID
SiteType
SiteName
isMCAD
agecoarse;
set &ou._3;
keep 
OperatingUnit
SNU1
PSNU
PrimePartner
FundingAgency
MechanismID
ImplementingMechanismName
indicator
numeratorDenom
indicatorType
standardizeddisaggregate
FY2017Q4
FY2018Q1
Fy2018Q2
SiteID
SiteType
SiteName
isMCAD
agecoarse;
RUN;


***make time periods into long format***;

data &ou._17q4;
length timeperiod $10. value $10.;
set &ou._4;
drop Fy2018Q1 Fy2018q2;
timeperiod = "FY2017Q4";
value = FY2017Q4;

data &ou._18Q1;
length timeperiod $10. value $10.;
set &ou._4;
drop FY2017Q4 FY2018Q2;
timeperiod = "FY2018Q1";
value = FY2018Q1;

data &ou._18Q2;
length timeperiod $10. value $10.;
set &ou._4;
drop FY2017Q4 FY2018Q1;
timeperiod = "FY2018Q2";
value  = FY2018Q2;
run; 


data &ou;
set &ou._17q4 &ou._18q1 &ou._18q2;
drop FY2017Q4 FY2018Q1 FY2018Q2;
if value = . then delete;
drop value;
sitecount = 1;
run;

proc sort data = &ou nodupkey;
by sitename mechanismID timeperiod agecoarse;
run;

proc datasets library=work nolist;
delete &ou._1 &ou._2 &ou._3 &ou._4 &ou._17q4 &ou._18q1 &ou._18q2;
run;
quit;


%mend artcount;


******Macro for Burma and Burundi since their column order is different***;
options compress = yes;
%macro artcount2(ou, nxtx);




/*Choosing country;*/
/******** 1) Pulling data *******************************/


/*Pulling the data using appropriate length statments to avoid truncation*/
data &ou;
infile "C:\Users\lqa9\Desktop\18Q2 Data\Site\ICPI_MER_Structured_Dataset_SITE_IM_FY17-18_&ou._20180515_v1_1.txt"
delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2;
informat orgUnitUID $50. ;
informat SiteName  $100. ;
informat Region $255. ;
informat RegionUID $50. ;
informat OperatingUnit $255. ;
informat OperatingUnitUID $50. ;
informat SNU1 $255. ;
informat SNU1UID $50. ;
informat PSNU $255. ;
informat PSNUuid $50. ;
informat SNUPrioritization  $26. ;
informat typeMilitary $1. ;
informat mechanismUID $28. ;
informat PrimePartner $250. ;
informat FundingAgency $30. ;
informat MechanismID $50. ;
informat ImplementingMechanismName $350. ;
informat CommunityUID $50. ; 
informat Community $75.;   
informat CommunityPrioritization $50.;   
informat FacilityUID $50. ;
informat Facility $75.;  
informat FacilityPrioritization  $50.;
informat SiteType $20. ;  
informat dataElementUID $255. ;
informat indicator $255. ;
informat numeratorDenom $2. ;
informat indicatorType $25. ;
informat disaggregate $50. ;
informat standardizedDisaggregate $100. ;
informat categoryOptionComboUID $255. ;
informat categoryOptionComboName $55. ;
informat AgeAsEntered $50. ;
informat AgeFine $50. ;
informat AgeSemiFine $50. ;
informat AgeCoarse $50. ;
informat Sex $50. ;
informat resultStatus $50. ;
informat otherDisaggregate $55. ;
informat coarseDisaggregate $50. ;
informat modality $100.;
informat isMCAD $5.;
/*informat FY2015Q2 BEST32.;*/
/*informat FY2015Q3 BEST32.;*/
/*informat FY2015Q4 BEST32.;*/
/*informat FY2015APR BEST32.;*/
/*informat FY2016_TARGETS BEST32.;*/
/*informat FY2016Q1 BEST32.;*/
/*informat FY2016Q2 BEST32.;*/
/*informat FY2016Q3 BEST32.;*/
/*informat FY2016Q4 BEST32.;*/
/*informat FY2016APR BEST32.;*/
informat FY2017_TARGETS BEST32.;
informat FY2017Q1 BEST32.;
informat FY2017Q2 BEST32.;
informat FY2017Q3 BEST32.;
informat FY2017Q4 BEST32.;
informat FY2017APR BEST32.;
informat FY2018_TARGETS BEST32.;
informat FY2018Q1 BEST32.;
informat FY2018Q2 BEST32.;



format orgUnitUID $50. ;
format SiteName $100. ;
format Region $255. ;
format RegionUID $50. ;
format OperatingUnit $255. ;
format OperatingUnitUID $50. ;
format SNU1 $255. ;
format SNU1UID $50. ;
format PSNU $255. ;
format PSNUuid $50. ;
format SNUPrioritization  $26. ;
format typeMilitary $1. ;
format mechanismUID $28. ;
format PrimePartner $250. ;
format FundingAgency $30. ;
format MechanismID $50. ;
format ImplementingMechanismName $350. ;
format CommunityUID $50. ; 
format Community $75.;   
format CommunityPrioritization $50.;   
format FacilityUID $50. ;   
format Facility $75. ; 
format FacilityPrioritization  $50.;
format SiteType $20. ;   
format dataElementUID $255. ;
format indicator $255. ;
format numeratorDenom $2. ;
format indicatorType $25. ;
format disaggregate $50. ;
format standardizedDisaggregate $100. ;
format categoryOptionComboUID $255. ;
format categoryOptionComboName $55. ;
format AgeAsEntered $50. ;
format AgeFine $50. ;
format AgeSemiFine $50. ;
format AgeCoarse $50. ;
format Sex $50. ;
format resultStatus $50. ;
format otherDisaggregate $55. ;
format coarseDisaggregate $50. ;
format modality $100.;
format isMCAD $5.;
/*format FY2015Q2 BEST32.;*/
/*format FY2015Q3 BEST32.;*/
/*format FY2015Q4 BEST32.;*/
/*format FY2015APR BEST32.;*/
/*format FY2016_TARGETS BEST32.;*/
/*format FY2016Q1 BEST32.;*/
/*format FY2016Q2 BEST32.;*/
/*format FY2016Q3 BEST32.;*/
/*format FY2016Q4 BEST32.;*/
/*format FY2016APR BEST32.;*/
format FY2017_TARGETS BEST32.;
format FY2017Q1 BEST32.;
format FY2017Q2 BEST32.;
format FY2017Q3 BEST32.;
format FY2017Q4 BEST32.;
format FY2017APR BEST32.;
format FY2018_TARGETS BEST32.;
format FY2018Q1 BEST32.;
format FY2018Q2 BEST32.;

input 
orgUnitUID $
SiteName $
Region $
RegionUID $
OperatingUnit $
OperatingUnitUID $
SNU1 $
SNU1UID $
PSNU $
PSNUuid $
SNUPrioritization $
typeMilitary $
mechanismUID $
PrimePartner $
FundingAgency $
MechanismID $
ImplementingMechanismName $
CommunityUID $
Community $
CommunityPrioritization $
FacilityUID $
Facility $
FacilityPrioritization $
SiteType $
dataElementUID $
indicator $
numeratorDenom $
indicatorType $
disaggregate $
standardizedDisaggregate $
categoryOptionComboUID $
categoryOptionComboName $
AgeAsEntered $
AgeFine $
AgeSemiFine $
AgeCoarse $
Sex $
resultStatus $
otherDisaggregate $
coarseDisaggregate $
modality $
isMCAD $
/*FY2015Q2*/
/*FY2015Q3*/
/*FY2015Q4*/
/*FY2015APR*/
/*FY2016_TARGETS*/
/*FY2016Q1*/
/*FY2016Q2*/
/*FY2016Q3*/
/*FY2016Q4*/
/*FY2016APR*/
FY2017_TARGETS
FY2017Q1 
FY2017Q2
FY2017Q3
FY2017Q4
FY2017APR 
FY2018_TARGETS
FY2018Q1
FY2018Q2;

RUN;



/*Creating SiteID variable from Facility, Community, and Military UID
  Creating */
data &ou._1;
set &ou;
where indicator = "TX_CURR" AND isMCAD = "Y";
rename orgUnitUID = SiteID;
if fundingagency = "Dedup" then delete;
RUN;



***Only Fy18 uses age/sex/result and age aggregated/sex/result, so keep only those rows for Fy18. Drop Fy17 values for those disaggs**;
 data &ou._2;
 set &ou._1;
drop FY2017_TARGETS
FY2017Q1
FY2017Q2
FY2017Q3
FY2017APR
FY2018_TARGETS;
 run;


 ***deleting blank rows from FactView to shorten file size***;
data &ou._3;
set &ou._2;
if Fy2017Q4 = 0 then Fy2017Q4 = .;
if Fy2018Q1 = 0 then Fy2018Q1 = .;
if Fy2018Q2 = 0 then Fy2018Q2 = .;
if FY2017Q4 = . & Fy2018Q1 = . & Fy2018Q2 =. then delete;
run; 


/*Arranging the data for output*/
data &ou._4;
retain
OperatingUnit
SNU1
PSNU
PrimePartner
FundingAgency
MechanismID
ImplementingMechanismName
indicator
numeratorDenom
indicatorType
standardizeddisaggregate
FY2017Q4
FY2018Q1
Fy2018Q2
SiteID
SiteType
SiteName
isMCAD
agecoarse;
set &ou._3;
keep 
OperatingUnit
SNU1
PSNU
PrimePartner
FundingAgency
MechanismID
ImplementingMechanismName
indicator
numeratorDenom
indicatorType
standardizeddisaggregate
FY2017Q4
FY2018Q1
Fy2018Q2
SiteID
SiteType
SiteName
isMCAD
agecoarse;
RUN;


***make time periods into long format***;

data &ou._17q4;
length timeperiod $10. value $10.;
set &ou._4;
drop Fy2018Q1 Fy2018q2;
timeperiod = "FY2017Q4";
value = FY2017Q4;

data &ou._18Q1;
length timeperiod $10. value $10.;
set &ou._4;
drop FY2017Q4 FY2018Q2;
timeperiod = "FY2018Q1";
value = FY2018Q1;

data &ou._18Q2;
length timeperiod $10. value $10.;
set &ou._4;
drop FY2017Q4 FY2018Q1;
timeperiod = "FY2018Q2";
value  = FY2018Q2;
run; 


data &ou;
set &ou._17q4 &ou._18q1 &ou._18q2;
drop FY2017Q4 FY2018Q1 FY2018Q2;
if value = . then delete;
drop value;
sitecount = 1;
run;


proc sort data = &ou nodupkey;
by sitename mechanismID timeperiod agecoarse;
run;

proc datasets library=work nolist;
delete &ou._1 &ou._2 &ou._3 &ou._4 &ou._17q4 &ou._18q1 &ou._18q2;
run;
quit;


%mend artcount2;



%artcount (Rwanda, 'Rwanda');
%artcount (Mozambique, 'Mozambique');
%artcount (SAfrica, 'South Africa');
%artcount (Angola, 'Angola');
%artcount (AsiaReg, 'Asia Regional Program');
%artcount (Botswana, 'Botswana');
%artcount2 (Burma, 'Burma');
%artcount2 (Burundi, 'Burundi');
%artcount (Cambodia, 'Cambodia');
%artcount (Cameroon, 'Cameroon');
%artcount (CaribbReg, 'Caribbean Region');
%artcount (CentAmer, 'Central America Region');
%artcount (CentAsia, 'Central Asia Region');
%artcount (DRC, 'Democratic Republic of the Congo');
%artcount (DR, 'Dominican Republic');
%artcount (Ethiopia, 'Ethiopia');
%artcount (Ghana, 'Ghana');
%artcount (Haiti, 'Haiti');
%artcount (India, 'India');
%artcount (Indonesia, 'Indonesia');
%artcount (Kenya, 'Kenya');
%artcount (Lesotho, 'Lesotho');
%artcount (Malawi, 'Malawi');
%artcount (Namibia, 'Namibia');
%artcount (Nigeria, 'Nigeria');
%artcount (PNG, 'Papua New Guinea');
%artcount (SSudan, 'South Sudan');
%artcount (Swaziland, 'Swaziland');
%artcount (Tanzania, 'Tanzania');
%artcount (Uganda, 'Uganda');
%artcount (Ukraine, 'Ukraine');
%artcount (Vietnam, 'Vietnam');
%artcount (Zambia, 'Zambia');
%artcount (Zimbabwe, 'Zimbabwe');
%artcount (CIV, "Cote d'Ivoire"); /* Would need to do this with double quotes */


/*Appending the datasets*/

data master;
set Angola AsiaReg Botswana Burma Burundi Cambodia Cameroon CaribbReg CentAmer CentAsia CIV DRC DR Ethiopia
Ghana Haiti India Indonesia Kenya Lesotho Malawi Mozambique Namibia Nigeria PNG Rwanda SAfrica SSudan
Swaziland Tanzania Uganda Ukraine Vietnam Zambia  Zimbabwe;
drop SNU1 PrimePartner numeratorDenom indicatorType;
run;



***check for 35 OUs****;
proc freq data = master;
table operatingunit;
run;


proc export data = master
dbms = excel outfile = "C:\Users\lqa9\Desktop\ART count request\ARTcount_dataset_&date..xlsx"
replace;
sheet = "Dataset";
run;
