


***********************************************
Code for creating PMTCT dataset. 
Last Update: 11/26/2019
Programmer: Katie O'Connor
Updated by: S. Ahmed
***********************************************;


**************************************************
STEP 1: THIS STEP IMPORTS PSNUxIM MSD. 
Change file path in infile step!
*************************************************; 

data psnuim;
infile "C:\Users\lqa9\Desktop\Current Docs\PMTCT SAS code -Katie\19Q4i.txt"
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
informat DREAMS $1. ; 
informat PrimePartner $250. ;
informat FundingAgency $30. ;
informat mech_code $32.;
informat mech_name $350. ;
informat pre_rgnlztn_hq_mech_code $50.;
informat prime_partner_duns $50. ; 
informat award_number $50. ; 
informat indicator $255. ;
informat numeratorDenom $2. ;
informat indicatorType $25. ;
informat disaggregate $50. ;
informat standardizeddisaggregate $55. ;
informat categoryOptionComboName $50. ;
informat AgeAsEntered $50. ;
informat TrendsFine $50. ;
informat TrendsSemiFine $50. ;
informat TrendsCoarse $50. ;
informat Sex $50. ;
informat StatusHIV $50. ;
informat StatusTB $50. ;
informat StatusCX $50. ;
informat hiv_treatment_status $25. ; 
informat population $50. ;
informat otherDisaggregate $50. ;
informat coarseDisaggregate $10. ;
informat modality $50.;
informat Fiscal_year $15.; 
informat TARGETS BEST32.;
informat Qtr1 BEST32.;
informat Qtr2 BEST32.;
informat Qtr3 BEST32.;
informat Qtr4 BEST32.;
informat Cumulative BEST32.;



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
format DREAMS $1. ; 
format PrimePartner $250. ;
format FundingAgency $30. ;
format mech_code $32.;
format mech_name $350. ;
format pre_rgnlztn_hq_mech_code $50.;
format prime_partner_duns $50. ; 
format award_number $50. ; 
format indicator $255. ;
format numeratorDenom $2. ;
format indicatorType $25. ;
format disaggregate $50. ;
format standardizeddisaggregate $55. ;
format categoryOptionComboName $50. ;
format AgeAsEntered $50. ;
format TrendsFine $50. ;
format TrendsSemiFine $50. ;
format TrendsCoarse $50. ;
format Sex $50. ;
format StatusHIV $50. ;
format StatusTB $50. ;
format StatusCX $50. ;
format hiv_treatment_status $25. ; 
format population $50. ;
format otherDisaggregate $50. ;
format coarseDisaggregate $10. ;
format modality $50.;
format Fiscal_year $15.; 
format TARGETS BEST32.;
format Qtr1 BEST32.;
format Qtr2 BEST32.;
format Qtr3 BEST32.;
format Qtr4 BEST32.;
format Cumulative BEST32.;




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
DREAMS $ 
PrimePartner $
FundingAgency $
mech_code $
mech_name $
pre_rgnlztn_hq_mech_code $
prime_partner_duns $
award_number $ 
indicator $
numeratorDenom $
indicatorType $
disaggregate $
standardizeddisaggregate $
categoryOptionComboName $
AgeAsEntered $
TrendsFine $
TrendsSemiFine $
TrendsCoarse $
Sex $
StatusHIV $
StatusTB $
StatusCX $
hiv_treatment_status $ 
population $ 
otherDisaggregate $
coarseDisaggregate $
modality $
Fiscal_year $ 
TARGETS
Qtr1
Qtr2
Qtr3
Qtr4
Cumulative;
run;


**/select which indicators you want below. If you are unsure of indicator names, you can do a proc freq statement
with a table for indicator to get the list of names**//;

/*data master;*/
/*set psnuim;  */
/*where indicator IN ("HTS_TST", "HTS_TST_POS", "PMTCT_STAT", "PMTCT_STAT_POS", "PMTCT_ART", "PMTCT_EID", "PMTCT_EID_Less_Equal_Two_Months",*/
/*"PMTCT_HEI_POS", "TX_NEW", "PMTCT_FO");*/
/*drop region regionuid OperatingUnitUID SNU1Uid PSNUuid;*/
/*run;*/
/**/
/**/
/*proc datasets library=work;*/
/*delete psnuim;*/
/*run;*/
***trying to shrink the dataset***;

data master2;
set psnuim;
if (TARGETS = . or TARGETS = 0) & (Qtr1 = . or Qtr1 = 0) & (Qtr2 = . or Qtr2 = 0) & (Qtr3 = . or Qtr3 = 0) & (Qtr4 = . or Qtr4 = 0) & (Cumulative = . or Cumulative = 0) then delete;
run;

***too much additional data in PMTCT_STAT so removing the disaggregate Age/Sex***;

data master2;
set master2;
if indicator = "PMTCT_STAT" & standardizedDisaggregate = "Age/Sex" then delete;
run;

proc datasets library=work;
delete master;
run;

***PMTCT_ART requirement - removing the denominiator since we already have that in PMTCT_STAT_POS***;
data master3;
set master2;
if indicator = "PMTCT_ART" & numeratorDenom NOTIN ("N") then delete;
run; 

proc datasets library=work;
delete master2;
run;



***TX_NEW requirement: only under 1 and PBF population***;


data master4;
set master3;
if (indicator = "TX_NEW" & AgeAsEntered NE "<01") and (indicator = "TX_NEW" & disaggregate NE "PregnantOrBreastfeeding/HIVStatus") then delete;
run;

proc datasets library=work;
delete master3;
run;

***Testing requirement***;

data master5;
set master4;
if (indicator = "HTS_TST" & modality NE "PMTCT ANC") and (indicator = "HTS_TST" & modality NE "Post ANC1") then delete;
run;

data master5;
set master5;
if (indicator = "HTS_TST_POS" & modality NE "PMTCT ANC") and (indicator = "HTS_TST_POS" & modality NE "Post ANC1") then delete;
run;

proc datasets library=work;
delete master4;
run;

***removing older years***;

data master6;
set master5;
if Fiscal_Year = '2017' then delete;
run; 

data master6;
set master6;
if (TARGETS = . or TARGETS = 0) & (Qtr1 = . or Qtr1 = 0) & (Qtr2 = . or Qtr2 = 0) & (Qtr3 = . or Qtr3 = 0) & (Qtr4 = . or Qtr4 = 0) & (Cumulative = . or Cumulative = 0) then delete;
run;

proc datasets library=work;
delete master5;
run;


***cleaning where things don't make sense***;

data master7;
set master6;
if indicator = "PMTCT_STAT" & standardizedDisaggregate = "Total Numerator" then StatusHIV = ""; 
run;

data master8;
set master7;
if indicator = "PMTCT_STAT_POS" & standardizedDisaggregate = "Total Numerator" then StatusHIV = "Positive"; 
run;

proc datasets library=work;
delete master6;
run;

proc datasets library=work;
delete master7;
run;

 
***creating dataset that is just PMTCT_STAT_POS so I can change it to EID_D for FY18 only. The PDH is calculating the denominator incorrectly***;
data EID;
set master8;
where indicator IN ("PMTCT_STAT_POS", "PMTCT_EID");
run;

data EID;
set EID;
where standardizedDisaggregate IN ("Total Denominator", "Total Numerator");
run;

data EID;
set EID;
if Fiscal_Year = '2019' & indicator = 'PMTCT_EID' then delete;
run;

data EID;
set EID;
if Fiscal_Year = '2018' & indicator = 'PMTCT_EID' then delete;
run;

data EID;
set EID;
if Fiscal_Year = '2019' & indicator = 'PMTCT_STAT_POS' then delete;
run;


data EID1;
set EID;
if indicator = "PMTCT_STAT_POS" then indicator = "PMTCT_EID";
run;

data EID1a;
set EID1;
if standardizedDisaggregate = "Total Numerator" then standardizedDisaggregate = "Total Denominator";
run;

data EID1a;
set EID1a;
if numeratorDenom = "N" then numeratorDenom = "D";
run;

data EID1a;
set EID1a;
if disaggregate = "Total Numerator" then disaggregate = "Total Denominator";
run;


data EID1a;
set EID1a;
if (Fiscal_Year = . & TARGETS = . & Qtr1 = . & Qtr2 = . & Qtr3 = . & Qtr4 = . & Cumulative = .) then delete;
run;

data EIDb;
set master8;
if Fiscal_Year = "2018" & indicator = "PMTCT_EID" & standardizedDisaggregate = "Total Denominator" then delete;
run;


data master9;
set EIDb EID1a;
run;

data master10;
set master9;
if indicator = "PMTCT_EID" & standardizedDisaggregate = "Total Denominator" then StatusHIV = "Positive";
run;



*** i need to have a HEI_POS_ART for 00-12 months***; 

data master11;
set master10;
if indicator = "PMTCT_HEI_POS" & standardizedDisaggregate = "Age/HIVStatus/ARTStatus" & otherDisaggregate = "Receiving ART" then TrendsSemiFine = "<01";
run; 

proc datasets library=work;
delete master8;
run;

proc datasets library=work;
delete master9;
run;

proc datasets library=work;
delete Eid;
run;

***i need to temporarily change PMTCT_ART standardized disagg for FY19 Q1 results so that I can look at the aggregated data vs. the fine age bands***;

data ART;
set master11;
where indicator = "PMTCT_ART";
run;

data ART;
set ART;
if Fiscal_Year = '2018' then delete; 
run;

data ART;
set ART;
if standardizeddisaggregate = "Total Numerator" then delete;
run;


data ART;
set ART;
if standardizedDisaggregate = "Age/NewExistingArt/Sex/HIVStatus" then standardizedDisaggregate = "NewExistingArt/Sex/HIVStatus";
run;

data ART;
set ART;
if AgeAsEntered = "<10" then AgeAsEntered = "";
run;

data ART;
set ART;
if AgeAsEntered = "10-14" then AgeAsEntered = "";
run;
data ART;
set ART;
if AgeAsEntered = "15-19" then AgeAsEntered = "";
run;
data ART;
set ART;
if AgeAsEntered = "20-24" then AgeAsEntered = "";
run;
data ART;
set ART;
if AgeAsEntered = "25-29" then AgeAsEntered = "";
run;
data ART;
set ART;
if AgeAsEntered = "30-34" then AgeAsEntered = "";
run;
data ART;
set ART;
if AgeAsEntered = "35-39" then AgeAsEntered = "";
run;
data ART;
set ART;
if AgeAsEntered = "40-44" then AgeAsEntered = "";
run;
data ART;
set ART;
if AgeAsEntered = "45-49" then AgeAsEntered = "";
run;
data ART;
set ART;
if AgeAsEntered = "40-49" then AgeAsEntered = "";
run;
data ART;
set ART;
if AgeAsEntered = "50+" then AgeAsEntered = "";
run;
data ART;
set ART;
if AgeAsEntered = "Unknown Age" then AgeAsEntered = "";
run;
data ART;
set ART;
if TrendsSemiFine = "<10" then TrendsSemiFine = "";
run;

data ART;
set ART;
if TrendsSemiFine = "10-14" then TrendsSemiFine = "";
run;
data ART;
set ART;
if TrendsSemiFine = "15-19" then TrendsSemiFine = "";
run;
data ART;
set ART;
if TrendsSemiFine = "20-24" then TrendsSemiFine = "";
run;
data ART;
set ART;
if TrendsSemiFine = "25-49" then TrendsSemiFine = "";
run;
data ART;
set ART;
if TrendsSemiFine = "50+" then TrendsSemiFine = "";
run;


data master12;
set master11 ART;
run;


***Now that we have an EID Denominator, i need to make a separate EID 00-12 month test due to the order of the current DEN, NUM and the 2 month test***;
data EID2;
set master12;
where indicator = "PMTCT_EID" & standardizedDisaggregate = "Age";
run; 

data EID2;
set EID2;
if indicator = "PMTCT_EID" then indicator = "PMTCT_EID_TwelveMonths";
run; 

data EID2;
set EID2;
if indicator = "PMTCT_EID_TwelveMonths" then standardizedDisaggregate = "Total Numerator";
run;

data EID2;
set EID2;
if indicator = "PMTCT_EID_TwelveMonths" then AgeAsEntered = "";
run;

data EID2;
set EID2;
if indicator = "PMTCT_EID_TwelveMonths" then TrendsSemiFine = "";
run;

data master13;
set master12 EID2;
run; 

proc datasets library=work;
delete master10;
run;

proc datasets library=work;
delete master11;
run;


****changing back to the time periods needed****;

data master14;
set master13;
where Fiscal_Year = "2018";
run;


data master14;
set master14 (rename= (TARGETS= FY2018_Targets Qtr1=FY2018Q1 Qtr2=FY2018Q2 Qtr3=FY2018Q3 Qtr4=FY2018Q4 Cumulative=FY2018APR));
run;

data master15;
set master13;
where Fiscal_Year = "2019";
run;


data master15;
set master15 (rename= (TARGETS= FY2019_Targets Qtr1=FY2019Q1 Qtr2=FY2019Q2 Qtr3=FY2019Q3 Qtr4=FY2019Q4 Cumulative=FY2019cum));
run;

data master16;
set master14 master15;
run;

/**/
/*data master12;*/
/*set master11;*/
/*if indicator = "PMTCT_EID" & standardizedDisaggregate = "Age" & AgeAsEntered = "02 - 12 Months" then AgeSemiFine = "<01";*/
/*run; */
/**/
/*proc freq data = master12;*/
/*where indicator = "PMTCT_EID" & standardizedDisaggregate = "Age";*/
/*table ageasentered*agesemifine; run; */

***need to make PMTCT_STAT_POS for FY19 targets****; 
/**/
/*data POS;*/
/*set master10;*/
/*where indicator = "PMTCT_STAT";*/
/*run;*/
/**/
/*data POS;*/
/*set POS;*/
/*drop FY2018_Targets */
/*FY2018Q1 */
/*FY2018Q2*/
/*FY2018Q3*/
/*FY2018Q4*/
/*FY2018APR */
/*FY2019Q1;*/
/*run;*/
/**/
/*data POS;*/
/*set POS;*/
/*if FY2019_Targets = . then delete;*/
/*run;*/
/**/
/*data POS2;*/
/*set POS;*/
/*where resultStatus = "Positive";*/
/*run;*/
/**/
/*data POS2;*/
/*set POS2;*/
/*if indicator = "PMTCT_STAT" then indicator = "PMTCT_STAT_POS";*/
/*run;*/
/**/
/*data POS2;*/
/*set POS2;*/
/*if standardizedDisaggregate = "Age/Sex/KnownNewResult" then standardizedDisaggregate = "Total Numerator";*/
/*run;*/
/**/
/*data POS2;*/
/*set POS2;*/
/*if otherDisaggregate = "Newly Identified" then otherDisaggregate = "";*/
/*run;*/
/**/
/*data POS2;*/
/*set POS2;*/
/*if otherDisaggregate = "Known at Entry" then otherDisaggregate = "";*/
/*run;*/
/**/
/*data POS2;*/
/*set POS2;*/
/*if AgeAsEntered = "<10" then AgeAsEntered = "";*/
/*run;*/
/**/
/*data POS2;*/
/*set POS2;*/
/*if AgeAsEntered = "10-14" then AgeAsEntered = "";*/
/*run;*/
/*data POS2;*/
/*set POS2;*/
/*if AgeAsEntered = "15-19" then AgeAsEntered = "";*/
/*run;*/
/*data POS2;*/
/*set POS2;*/
/*if AgeAsEntered = "20-24" then AgeAsEntered = "";*/
/*run;*/
/*data POS2;*/
/*set POS2;*/
/*if AgeAsEntered = "25-29" then AgeAsEntered = "";*/
/*run;*/
/*data POS2;*/
/*set POS2;*/
/*if AgeAsEntered = "30-34" then AgeAsEntered = "";*/
/*run;*/
/*data POS2;*/
/*set POS2;*/
/*if AgeAsEntered = "35-39" then AgeAsEntered = "";*/
/*run;*/
/*data POS2;*/
/*set POS2;*/
/*if AgeAsEntered = "40-49" then AgeAsEntered = "";*/
/*run;*/
/*data POS2;*/
/*set POS2;*/
/*if AgeAsEntered = "50+" then AgeAsEntered = "";*/
/*run;*/
/*data POS2;*/
/*set POS2;*/
/*if AgeAsEntered = "Unknown Age" then AgeAsEntered = "";*/
/*run;*/
/*data POS2;*/
/*set POS2;*/
/*if AgeSemiFine = "<10" then AgeSemiFine = "";*/
/*run;*/
/**/
/*data POS2;*/
/*set POS2;*/
/*if AgeSemiFine = "10-14" then AgeSemiFine = "";*/
/*run;*/
/*data POS2;*/
/*set POS2;*/
/*if AgeSemiFine = "15-19" then AgeSemiFine = "";*/
/*run;*/
/*data POS2;*/
/*set POS2;*/
/*if AgeSemiFine = "20-24" then AgeSemiFine = "";*/
/*run;*/
/*data POS2;*/
/*set POS2;*/
/*if AgeSemiFine = "25-49" then AgeSemiFine = "";*/
/*run;*/
/*data POS2;*/
/*set POS2;*/
/*if AgeSemiFine = "50+" then AgeSemiFine = "";*/
/*run;*/
/**/
/*data master13;*/
/*set master12 POS2;*/
/*run;*/




%let date= 11262019;  *<- change date to current date;

/*libname out "\\cdc.gov\private\M333\lqa9\PEDS.PMTCT\Geller Request"; run;*/
/*data out.PMTCT_PSNU_IM_&date;*/
/*set master5;*/
/*run;*/


PROC EXPORT DATA= WORK.MASTER16
            OUTFILE= "C:\Users\lqa9\Desktop\Current Docs\PMTCT SAS code -Katie\pmtct_psnu_im_q4_v2 &date..xlsx" 
            DBMS=EXCEL REPLACE;
     SHEET="PSNU by IM"; 
RUN;


***convert to excel**;





**trying to fix the error in ageSemiFine for PMTCT_STAT, standardizedDisaggregate Age/Sex/KnownNewResult***;
/*data master4;*/
/*set master3;*/
/*if (indicator = "PMTCT_STAT" & StandardizedDisaggregate = "Age/Sex/KnownNewResult" & AgeSemiFine = "25-29") then AgeSemiFine = "25-49";*/
/*else AgeSemiFine=AgeSemiFine;*/
/*run; */
/**/
/*data master5;*/
/*set master4;*/
/*if (indicator = "PMTCT_STAT" & StandardizedDisaggregate = "Age/Sex/KnownNewResult" & AgeSemiFine = "30-34") then AgeSemiFine = "25-49";*/
/*else AgeSemiFine=AgeSemiFine;*/
/*run; */
/**/
/*data master6;*/
/*set master5;*/
/*if (indicator = "PMTCT_STAT" & StandardizedDisaggregate = "Age/Sex/KnownNewResult" & AgeSemiFine = "35-39") then AgeSemiFine = "25-49";*/
/*else AgeSemiFine=AgeSemiFine;*/
/*run; */
/**/
/*data master7;*/
/*set master6;*/
/*if (indicator = "PMTCT_STAT" & StandardizedDisaggregate = "Age/Sex/KnownNewResult" & AgeSemiFine = "40-49") then AgeSemiFine = "25-49";*/
/*else AgeSemiFine=AgeSemiFine;*/
/*run; */

*fixing FY19 Q1 datatset*;

/*data master6;*/
/*set master5;*/
/*if (indicator = "PMTCT_STAT" & resultStatus = "Unknown") then resultStatus = .; */
/*run; */
/**/
/*data master7;*/
/*set master6;*/
/*if (indicator = "PMTCT_ART" & AgeCoarse = "15+") then standardizedDisaggregate =  "NewExistingArt/Sex/HIVStatus";*/
/*run;*/
/**/
/*proc freq data=master5;*/
/*tables AgeSemiFine;*/
/*run;*/
/**/
/**/


***PMTCT_STAT requirement****;
/*data master3;*/
/*set master2;*/
/*/*if indicator = "PMTCT_STAT" & disaggregate NOTIN ("Total Numerator", "Total Denominator", "Age/KnownNewResult", "Age/Sex/KnownNewResult", "Known/New/Age") then delete;*/*/
/*run;*/
