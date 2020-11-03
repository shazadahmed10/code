
****************************************************************
Purpose: This program manipulates the MSD and churns out a 
CHIPS dataset for every OU.
Steps: import, subset, drop vars, drop empty rows, 
import older data, stack to new data, trim by disaggs, convert NA, 
create FY18 Cum
Prgrammer: Shazad Ahmed 
******************************************************************;


%let curr_period = FY2018Q3;

***import the current PSNUxIM MSD. Change path in infile statement as needed****;
data psnuim_curr;
infile "C:\Users\lqa9\Desktop\18Q3 Data\MER_Structured_Dataset_PSNU_IM_FY17-18_20180815_v1_1\MER_Structured_Dataset_PSNU_IM_FY17-18_20180815_v1_1.txt"
delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2;

informat Region $255. ;
informat RegionUID $50. ;
informat OperatingUnit $255. ;
informat OperatingUnitUID $50. ;
informat CountryName $255. ;
informat SNU1 $255. ;
informat SNU1Uid $50. ;
informat PSNU $255. ;
informat PSNUuid $50. ;
informat SNUPrioritization $26. ;
informat typeMilitary $1. ;
informat mechanismUID $28. ;
informat PrimePartner $250. ;
informat FundingAgency $30. ;
informat MechanismID $32.;
informat ImplementingMechanismName $350. ;
informat indicator $255. ;
informat numeratorDenom $2. ;
informat indicatorType $25. ;
informat disaggregate $50. ;
informat standardizeddisaggregate $55. ;
informat categoryOptionComboName $50. ;
informat AgeAsEntered $50. ;
informat AgeFine $50. ;
informat AgeSemiFine $50. ;
informat AgeCoarse $50. ;
informat Sex $50. ;
informat resultStatus $50. ;
informat otherDisaggregate $50. ;
informat coarseDisaggregate $50. ;
informat modality $50.;
informat isMCAD $15.; 
informat FY2017_Targets BEST32.;
informat FY2017Q1 BEST32.;
informat FY2017Q2 BEST32.;
informat FY2017Q3 BEST32.;
informat FY2017Q4 BEST32.;
informat FY2017APR BEST32.;
informat FY2018_TARGETS BEST32.;
informat FY2018Q1 BEST32.;
informat FY2018Q2 BEST32.;
informat FY2018Q3 BEST32.;
informat FY2019_TARGETS BEST32.;



format Region $255. ;
format RegionUID $50. ;
format OperatingUnit $255. ;
format OperatingUnitUID $50. ;
format CountryName $255. ;
format SNU1 $255. ;
format SNU1Uid $50. ;
format PSNU $255. ;
format PSNUuid $50. ;
format SNUPrioritization $26. ;
format typeMilitary $1. ;
format mechanismUID $28. ;
format PrimePartner $250. ;
format FundingAgency $30. ;
format MechanismID $32.;
format ImplementingMechanismName $350. ;
format indicator $255. ;
format numeratorDenom $2. ;
format indicatorType $25. ;
format disaggregate $50. ;
format standardizeddisaggregate $55. ;
format categoryOptionComboName $50. ;
format AgeAsEntered $50. ;
format AgeFine $50. ;
format AgeSemiFine $50. ;
format AgeCoarse $50. ;
format Sex $50. ;
format resultStatus $50. ;
format otherDisaggregate $50. ;
format coarseDisaggregate $50. ;
format modality $50.;
format isMCAD $15.; 
format FY2017_Targets BEST32.;
format FY2017Q1 BEST32.;
format FY2017Q2 BEST32.;
format FY2017Q3 BEST32.;
format FY2017Q4 BEST32.;
format FY2017APR BEST32.;
format FY2018_TARGETS BEST32.;
format FY2018Q1 BEST32.;
format FY2018Q2 BEST32.;
format FY2018Q3 BEST32.;
format FY2019_TARGETS BEST32.;


input 
Region $
RegionUID $
OperatingUnit $
OperatingUnitUID $
CountryName $
SNU1 $
SNU1Uid $
PSNU $
PSNUuid $
SNUPrioritization $
typeMilitary $
mechanismUID $
PrimePartner $
FundingAgency $
MechanismID $
ImplementingMechanismName $
indicator $
numeratorDenom $
indicatorType $
disaggregate $
standardizeddisaggregate $
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
FY2017_Targets
FY2017Q1
FY2017Q2
FY2017Q3
FY2017Q4
FY2017APR
FY2018_TARGETS
FY2018Q1
FY2018Q2
FY2018Q3
FY2019_TARGETS;

run;


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
/**/
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
/**/
/*FY2015Q2 */
/*FY2015Q3 */
/*FY2015Q4 */
/*FY2015APR */
/*FY2016_TARGETS */
/*FY2016Q1 */
/*FY2016Q2 */
/*FY2016Q3 */
/*FY2016Q4*/
/*FY2016APR;*/




****Subset by indicators***;
data master_curr;
set psnuim_curr;
where indicator IN ("HTS_TST", "HTS_TST_POS", "HTS_TST_NEG", "TX_NEW");
run;


****Drop unnecessary columns***;
data master_curr;
set master_curr;
drop region regionuid snu1uid operatingunituid countryname psnuuid 
mechanismUID MechanismID disaggregate coarsedisaggregate FY2019_TARGETS;
run;

data master_curr2;
set master_curr;
if fy2017q1 = 0 then fy2017q1 = .;
if fy2017q2 = 0 then fy2017q2 = .;
if fy2017q3 = 0 then fy2017q3 = .;
if fy2017q4 = 0 then fy2017q4 = .;
if fy2018q1 = 0 then fy2018q1 = .;
if fy2018q2 = 0 then fy2018q2 = .;
if fy2018q3 = 0 then fy2018q3 = .;
if FY2017_TARGETS = 0 then FY2017_TARGETS = .;
if FY2018_TARGETS = 0 then FY2018_TARGETS = .;
run;

data master_curr3;
set master_curr2;
if (fy2017q1 = . & fy2017q2 = . & fy2017q3 = . & fy2017q4 = . & fy2018q1 = . & fy2018Q2 =. & fy2018q3 =. &
 FY2017_TARGETS = . & FY2018_TARGETS = .) then delete;
run;





***import the HISTORICAL(FY15-16) PSNUxIM MSD. Change path in infile statement as needed****;
data psnuim_old;
infile "C:\Users\lqa9\Desktop\18Q2 Data\ICPI_MER_Structured_Dataset_PSNU_IM_FY15-16_20180515_v1_1.txt"
delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2;

informat Region $255. ;
informat RegionUID $50. ;
informat OperatingUnit $255. ;
informat OperatingUnitUID $50. ;
informat CountryName $255. ;
informat SNU1 $255. ;
informat SNU1Uid $50. ;
informat PSNU $255. ;
informat PSNUuid $50. ;
informat CurrentSNUPrioritization $26. ;
informat typeMilitary $1. ;
informat mechanismUID $28. ;
informat PrimePartner $250. ;
informat FundingAgency $30. ;
informat MechanismID $32.;
informat ImplementingMechanismName $350. ;
informat dataElementUID $255. ;
informat indicator $255. ;
informat numeratorDenom $2. ;
informat indicatorType $25. ;
informat disaggregate $50. ;
informat standardizeddisaggregate $55. ;
informat categoryOptionComboUID $255. ;
informat categoryOptionComboName $50. ;
informat AgeAsEntered $50. ;
informat AgeFine $50. ;
informat AgeSemiFine $50. ;
informat AgeCoarse $50. ;
informat Sex $50. ;
informat resultStatus $50. ;
informat otherDisaggregate $50. ;
informat coarseDisaggregate $50. ;
informat modality $50.;
informat isMCAD $15.; 
informat FY2015Q2 BEST32.;
informat FY2015Q3 BEST32.;
informat FY2015Q4 BEST32.;
informat FY2015APR BEST32.;
informat FY2016_TARGETS BEST32.;
informat FY2016Q1 BEST32.;
informat FY2016Q2 BEST32.;
informat FY2016Q3 BEST32.;
informat FY2016Q4 BEST32.;
informat FY2016APR BEST32.;



format Region $255. ;
format RegionUID $50. ;
format OperatingUnit $255. ;
format OperatingUnitUID $50. ;
format CountryName $255. ;
format SNU1 $255. ;
format SNU1Uid $50. ;
format PSNU $255. ;
format PSNUuid $50. ;
format CurrentSNUPrioritization $26. ;
format typeMilitary $1. ;
format mechanismUID $28. ;
format PrimePartner $250. ;
format FundingAgency $30. ;
format MechanismID $32.;
format ImplementingMechanismName $350. ;
format dataElementUID $255. ;
format indicator $255. ;
format numeratorDenom $2. ;
format indicatorType $25. ;
format disaggregate $50. ;
format standardizeddisaggregate $55. ;
format categoryOptionComboUID $255. ;
format categoryOptionComboName $50. ;
format AgeAsEntered $50. ;
format AgeFine $50. ;
format AgeSemiFine $50. ;
format AgeCoarse $50. ;
format Sex $50. ;
format resultStatus $50. ;
format otherDisaggregate $50. ;
format coarseDisaggregate $50. ;
format modality $50.;
format isMCAD $15.; 
format FY2015Q2 BEST32.;
format FY2015Q3 BEST32.;
format FY2015Q4 BEST32.;
format FY2015APR BEST32.;
format FY2016_TARGETS BEST32.;
format FY2016Q1 BEST32.;
format FY2016Q2 BEST32.;
format FY2016Q3 BEST32.;
format FY2016Q4 BEST32.;
format FY2016APR BEST32.;


input 
Region $
RegionUID $
OperatingUnit $
OperatingUnitUID $
CountryName $
SNU1 $
SNU1Uid $
PSNU $
PSNUuid $
CurrentSNUPrioritization $
typeMilitary $
mechanismUID $
PrimePartner $
FundingAgency $
MechanismID $
ImplementingMechanismName $
dataElementUID $
indicator $
numeratorDenom $
indicatorType $
disaggregate $
standardizeddisaggregate $
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
FY2015Q2 
FY2015Q3 
FY2015Q4 
FY2015APR 
FY2016_TARGETS 
FY2016Q1 
FY2016Q2 
FY2016Q3 
FY2016Q4
FY2016APR;

run;


****Subset by indicators***;
data master_old;
set psnuim_old;
where indicator IN ("HTS_TST", "HTS_TST_POS", "HTS_TST_NEG", "TX_NEW");
run;


****Drop unnecessary columns***;
data master_old;
set master_old;
drop region regionuid snu1uid operatingunituid dataelementuid categoryoptioncomboUID countryname psnuuid 
mechanismUID MechanismID disaggregate coarsedisaggregate FY2015Q2 FY2015Q3 FY2015Q4 FY2015APR FY2016Q1 FY2016Q2  
FY2016Q3 FY2016Q4;
run;


****delete empty rows to cut down on size***;
data master_old2;
set master_old;
if FY2016APR = 0 then FY2016APR = .;
if FY2016_TARGETS = 0 then FY2016_TARGETS = .;
run;

data master_old3;
set master_old2;
if FY2016APR = . & FY2016_TARGETS = . then delete;
run;

data master_old4;
set master_old3;
rename CurrentSNUPrioritization = SNUPrioritization;
run;

***MERGE old and current to form master dataset****;
data master;
set master_old4 master_curr3;
run;



**MACRO BEGINS**;
options compress = yes ;
%macro form (ou, oux);




proc datasets library=work nolist;
save psnuim master SASMACR;
run;
quit;


data master2;
set master;
where operatingunit = &ou;
run;




**For tx_new, we only need total numerator and MCAD for sex***;
data master3;
set master2;
if indicator = "TX_NEW" & standardizeddisaggregate NOTIN ("Total Numerator", "Age/Sex/HIVStatus") then delete;
run;

***requirements for HTS_TST***;
data master4;
set master3;
if indicator = "HTS_TST" & standardizeddisaggregate IN ("Age Aggregated/Sex/Result", "AgeAboveTen/Sex", "AgeAboveTen/Sex/Positive",
"AgeLessThanTen", "Age Aggregated/Sex", "AgeLessThanTen/Positive", "Results", "KeyPop/Result", "CommunityDeliveryPoint", 
"FacilityDeliveryPoint", "Modality/Age Aggregated/Sex/Result", "Positive", "ServiceDeliveryPoint", "ServiceDeliveryPoint/Result") then delete;
run;


***requirements for HTS_TST_POS***;
data master5;
set master4;
if indicator = "HTS_TST_POS" & standardizeddisaggregate NOTIN ("Total Numerator", "MostCompleteAgeDisagg", 
"Modality/MostCompleteAgeDisagg", "Modality/Age/Sex/Result") then delete;
run;



***requirements for HTS_TST_NEG***;
data master6;
set master5;
if indicator = "HTS_TST_NEG" & standardizeddisaggregate NOTIN ("Total Numerator", "MostCompleteAgeDisagg",
"Modality/MostCompleteAgeDisagg", "Modality/Age/Sex/Result") then delete;
run;


**separate out records for 1-4,5-9, and make them all 1-9, consolidate by PSNU/indicatortype/categoryoption, rejoin to master dataset**;

/**/
/*data master6;*/
/*set master5;*/
/*if indicator = "HTS_TST" & standardizeddisaggregate = "Age/Sex/Result" & age IN ("01-04", "05-09") then age = "01-09";*/
/*run;*/


/*fy2015q2 = . & fy2015q3 = . & fy2015q4 = . & fy2015apr = . & fy2016apr = . & fy2017apr = . & fy2016q1 = . & fy2016q2 = . */
/*& fy2016q3 = . & fy2016q4 = . & FY2016_TARGETS = . */



****add current period to make current time period visuals automated when updated new time period.
    cumulative time period only necessary in Q1 -Q3 for HTS summary tab*****;
data master7;
set master6;
if FY2018Q1 = . then Fy2018Q1 = 0;
if Fy2018Q2 =. then FY2018Q2 = 0;
FY2018Cum = FY2018Q1 + FY2018Q2;
if sex = "N/A" then sex = "";
if resultstatus = "N/A" then resultstatus = "";
run;


data master8;
retain OperatingUnit SNU1 PSNU SNUPrioritization 
typeMilitary indicator numeratordenom indicatortype categoryOptionComboName 
ageasentered agefine agesemifine agecoarse sex resultstatus otherDisaggregate modality isMCAD FY2016_TARGETS FY2016APR
FY2017_TARGETS FY2017Q1 FY2017Q2 FY2017Q3 FY2017Q4 FY2017APR FY2018_TARGETS FY2018Q1 FY2018Q2 FY2018Cum
standardizeddisaggregate fundingagency primepartner implementingmechanismname; *<-preserving only the columns needed. Add additional time period(s) here if needed;
set master7;
if FY2018Q1 = 0 then FY2018Q1 =.;
if FY2018Q2 = 0 then FY2018Q2 = .;
if Fy2018Cum = 0 then FY2018Cum =.;
run;
/*FY2015Q2 FY2015Q3 FY2015Q4 FY2015APR FY2016Q1 FY2016Q2 FY2016Q3 FY2016Q4  */






****************************************************************************************
EXPORT HTS & PLHIV datasets into excel
****************************************************************************************;


***change location of outputs as needed in outfile step***;
proc export data = master8
dbms = excel outfile = "\\cdc.gov\private\M333\lqa9\HTS\CHIPS 3.0\Fy18\Q2\Clean\Datasets\HTS_&oux._Q2.xlsx" 
replace;
sheet = "dataset";
run;

%mend form;



%form("Angola", Angola);
%form("Asia Regional Program", Asia_Regional_Program);
%form("Botswana", Botswana);
%form("Burma", Burma);
%form("Burundi", Burundi);
%form("Cambodia", Cambodia);
%form("Cameroon", Cameroon);
%form("Caribbean Region", Caribbean_Region);
%form("Central America Region", Central_America_Region);
%form("Central Asia Region", Central_Asia_Region);
%form("Cote d'Ivoire", Cote_d_Ivoire);
%form("Democratic Republic of the Congo", DRC);
%form("Dominican Republic", Dominican_Republic);
%form("Ethiopia", Ethiopia);
%form("Ghana", Ghana);
%form("Haiti", Haiti);
%form("India", India);
%form("Indonesia", Indonesia);
%form("Kenya", Kenya);
%form("Lesotho", Lesotho);
%form("Malawi", Malawi);
%form("Mozambique", Mozambique);
%form("Namibia", Namibia);
%form("Nigeria", Nigeria);
%form("Papua New Guinea", Papua_New_Guinea);
%form("Rwanda", Rwanda);
%form("South Africa", South_Africa);
%form("South Sudan", South_Sudan);
%form("Swaziland", Swaziland);
%form("Tanzania", Tanzania);
%form("Uganda", Uganda);
%form("Ukraine", Ukraine);
%form("Vietnam", Vietnam);
%form("Zambia", Zambia);
%form("Zimbabwe", Zimbabwe);
