
**********************************
HITS SAS Code to produc 'FactView' datasets
*********************************;

* Creating data variable for output files;
%let todaydate = 2019_02_24_;





*************************************************************************************
*************************************************************************************
Macro for pulling site data and outputting two datasets in 
Excel:
<countryname>_f Site level wide dataset with Yield and Prevalance data
<countryname>_1 Site-IM Factview dataset with HTC indicators

*************************************************************************************
*************************************************************************************
*************************************************************************************
**************************** IM x Site data pull per country ************************
*************************************************************************************
*************************************************************************************
*************************************************************************************;
options compress = yes;
%macro hits(nxt, nxtx);


proc datasets library=work nolist;
save SASMACR;
run;
quit;


/*Choosing country;*/
/******** 1) Pulling data *******************************/


/*Pulling the data using appropriate length statments to avoid truncation*/
data &nxt;
infile "C:\Users\lqa9\Desktop\19Q1\Site\MER_Structured_Dataset_SITE_IM_FY17-19_20190215_v1_1_&nxt..txt"
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
informat indicator $255. ;
informat numeratorDenom $2. ;
informat indicatorType $25. ;
informat disaggregate $50. ;
informat standardizedDisaggregate $100. ;
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
informat FY2018Q3 BEST32.;
informat FY2018Q4 BEST32.;
informat FY2018APR BEST32.;
informat FY2019_TARGETS BEST32.;
informat FY2019Q1 BEST32.;



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
format indicator $255. ;
format numeratorDenom $2. ;
format indicatorType $25. ;
format disaggregate $50. ;
format standardizedDisaggregate $100. ;
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
format FY2018Q3 BEST32.;
format FY2018Q4 BEST32.;
format FY2018APR BEST32.;
format FY2019_TARGETS BEST32.;
format FY2019Q1 BEST32.;

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
indicator $
numeratorDenom $
indicatorType $
disaggregate $
standardizedDisaggregate $
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
FY2018Q2
FY2018Q3
FY2018Q4
FY2018APR 
FY2019_TARGETS
FY2019Q1 ;

RUN;



/*Creating SiteID variable from Facility, Community, and Military UID
  Creating */
data &nxt._1;
set &nxt;

if orgUnitUID = FacilityUID then SitePrioritization = FacilityPrioritization;
else if orgUnitUID = CommunityUID then SitePrioritization = CommunityPrioritization;
else if orgUnitUID = PSNUuid then SitePrioritization = SNUPrioritization;


where indicator in 
("HTS_TST", "HTS_TST_POS") AND standardizedDisaggregate in (
	"Modality/MostCompleteAgeDisagg",
	"Total Numerator",
	"Modality/Age/Sex/Result",
	"Modality/Age Aggregated/Sex/Result");

rename orgUnitUID = SiteID;
RUN;



***Only Fy18 uses age/sex/result and age aggregated/sex/result, so keep only those rows for Fy18. Drop Fy17 values for those disaggs**;
 data &nxt._2;
 set &nxt._1;
if (FY2018Q1 = . & Fy2018Q2 = . & FY2018Q3 = . & FY2018Q4 = . & FY2019Q1 = . ) & StandardizedDisaggregate IN 
("Modality/Age/Sex/Result", "Modality/Age Aggregated/Sex/Result") then delete;
 run;


/*Arranging the data for output*/
data &nxt._3;
retain
OperatingUnit
SNU1
PSNU
SNUPrioritization
PrimePartner
FundingAgency
MechanismID
ImplementingMechanismName
indicator
numeratorDenom
indicatorType
disaggregate
resultStatus
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
Fy2018Q2
FY2018Q3
FY2018Q4
FY2018APR
FY2019_TARGETS
FY2019Q1
SiteID
SiteType
SitePrioritization
SiteName
StandardizedDisaggregate
isMCAD
Modality;
set &nxt._2;
keep 
OperatingUnit
SNU1
PSNU
SNUPrioritization
PrimePartner
FundingAgency
MechanismID
ImplementingMechanismName
indicator
numeratorDenom
indicatorType
disaggregate
resultStatus
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
Fy2018Q2
FY2018Q3
FY2018Q4
FY2018APR
FY2019_TARGETS
FY2019Q1
SiteID
SiteType
SitePrioritization
SiteName
StandardizedDisaggregate
isMCAD
Modality;
RUN;




***deleting blank rows from FactView to shorten file size***;


data &nxt._4;
set &nxt._3;

if FY2017_TARGETS = 0 then FY2017_TARGETS = . ;
if FY2017Q1 = 0 then FY2017Q1 =. ;
if FY2017Q2 = 0 then FY2017Q2 = . ;
if FY2017Q3 = 0 then FY2017Q3 =. ; 
if FY2017Q4 = 0 then FY2017Q4 = . ;
if FY2017APR = 0 then FY2017APR = . ;
if FY2018_TARGETS = 0 then FY2018_TARGETS = . ;
if FY2018Q1 = 0 then FY2018Q1 =. ;
if FY2018Q2 = 0 then FY2018Q2 = . ;
if FY2018Q3 = 0 then FY2018Q3 =. ; 
if FY2018Q4 = 0 then FY2018Q4 = . ;
if FY2018APR = 0 then FY2018APR = . ;
if FY2019_TARGETS = 0 then FY2019_TARGETS = . ;
if FY2019Q1 = 0 then FY2019Q1 = . ;
run;


data &nxt._5;
set &nxt._4;
if (FY2017_TARGETS = . & FY2017Q1 = . & FY2017Q2 = . & FY2017Q3 = . & FY2017Q4 = . & FY2017APR =. 
& FY2018_TARGETS =. & FY2018Q1 =. & FY2018Q2 = . & FY2018Q3 = . & FY2018Q4 = . & FY2018APR = . & 
FY2019_TARGETS = . & FY2019Q1 = . ) then delete;
run;


/*Exporting the datasets*/

proc export data = &nxt._5
dbms = excel outfile = "\\cdc.gov\private\M333\lqa9\HTS\HITS 1.0\FY19Q1\Datasets\&todaydate._&nxt._HITS.xlsx"
replace;
sheet = "SiteMSD";
run;



%mend hits;



/*%hits (Rwanda, 'Rwanda');*/
/*%hits (Mozambique, 'Mozambique');*/
%hits (SAfrica, 'South Africa');
/*%hits (Angola, 'Angola');*/
%hits (AsiaReg, 'Asia Regional Program');
/*%hits (Botswana, 'Botswana');*/
/*%hits (Burma, 'Burma');*/
/*%hits (Burundi, 'Burundi');*/
/*%hits (Cambodia, 'Cambodia');*/
/*%hits (Cameroon, 'Cameroon');*/
%hits (CaribbReg, 'Caribbean Region');
%hits (CentAmer, 'Central America Region');
%hits (CentAsia, 'Central Asia Region');
%hits (DRC, 'Democratic Republic of the Congo');
%hits (DR, 'Dominican Republic');
/*%hits (Ethiopia, 'Ethiopia');*/
/*%hits (Ghana, 'Ghana');*/
/*%hits (Haiti, 'Haiti');*/
/*%hits (India, 'India');*/
/*%hits (Indonesia, 'Indonesia');*/
/*%hits (Kenya, 'Kenya');*/
/*%hits (Lesotho, 'Lesotho');*/
/*%hits (Malawi, 'Malawi');*/
/*%hits (Namibia, 'Namibia');*/
/*%hits (Nigeria, 'Nigeria');*/
%hits (PNG, 'Papua New Guinea');
%hits (SSudan, 'South Sudan');
/*%hits (Eswatini, 'Eswatini');*/
%hits (Tanzania, 'Tanzania');
/*%hits (Uganda, 'Uganda');*/
/*%hits (Ukraine, 'Ukraine');*/
/*%hits (Vietnam, 'Vietnam');*/
/*%hits (Zambia, 'Zambia');*/
/*%hits (Zimbabwe, 'Zimbabwe');*/
%hits (CIV, "Cote d'Ivoire"); /* Would need to do this with double quotes */


