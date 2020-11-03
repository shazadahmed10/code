***********************************************
Purpose: Subsetting CIV site data for TX_NEW, HTS_POS and all PMTCT indicators
Date: 6/18/2018
Step: Import, subset, trim down file size, export
**********************************************;

/*STEP 1: IMport Site Level Data*/

data CIV;
infile "C:\Users\lqa9\Desktop\18Q2 Data\Site\ICPI_MER_Structured_Dataset_SITE_IM_FY17-18_CIV_20180515_v1_1.txt"
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
informat PrimePartner $100. ;
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
informat indicator $100. ;
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
format PrimePartner $100. ;
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
format indicator $100. ;
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



/*STEP 2: Subset for inidicators needed*/

data civ2;
set civ;
where indicator IN ("TX_NEW", "HTS_TST_POS") OR substr(indicator, 1, 5) = 'PMTCT';
run;

/*STEP 3: drop unnecessary variables and empty rows*/

data civ3;
set civ2;
drop region regionuid operatingunituid snu1uid psnuuid mechanismuid communityuid facilityuid dataelementuid operatingunit countryname;
if (FY2017_TARGETS = . & FY2017Q1 = . & FY2017Q2 = . & FY2017Q3 = . & FY2017Q4 = . & FY2017APR = . & FY2018_TARGETS = . &
FY2018Q1 = . & FY2018Q2 = .) then delete;
run;


/*STEP 4: Export as excel dataset*/

proc export data = civ3
dbms = excel outfile = "C:\Users\lqa9\Desktop\ART count request\CIV_PMTCT.xlsx"
replace;
sheet = "CIV Site Level";
run;


