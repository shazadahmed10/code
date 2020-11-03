options compress = yes;
%macro kp (nxt);

data test;
infile "C:\Users\lqa9\Desktop\19Q3\Site\MER_Structured_Datasets_Site_IM_FY17-19_20190815_v1_1_&nxt..txt"
delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2;
informat orgunituid $50. ;
informat SiteName $100. ;
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
informat DREAMS $10. ;
informat PrimePartner $250. ;
informat FundingAgency $30. ;
informat mech_code $32.;
informat mech_name $350. ;
informat pre_rgnlztn_hq_mech_code $50.;
informat prime_partner_duns $50. ; 
informat award_number $50. ; 
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


format orgunituid $50. ;
format SiteName $100. ;
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
format DREAMS $10. ;
format PrimePartner $250. ;
format FundingAgency $30. ;
format mech_code $32.;
format mech_name $350. ;
format pre_rgnlztn_hq_mech_code $50.;
format prime_partner_duns $50. ; 
format award_number $50. ; 
format CommunityUID $50. ; 
format Community $75.;   
format CommunityPrioritization $50.;   
format FacilityUID $50. ;
format Facility $75.;  
format FacilityPrioritization  $50.;
format SiteType $20. ;  
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
orgunituid $
SiteName $
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
CommunityUID $
Community $   
CommunityPrioritization $   
FacilityUID $
Facility $
FacilityPrioritization  $
SiteType $
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



data test2;
set test;
where indicator IN ("HTS_RECENT", "HTS_SELF", "HTS_TST", "TX_NEW", "PrEP_CURR", "PrEP_NEW", "KP_PREV");
keep orgUnitUID siteName OperatingUnit SNU1 PSNU PrimePartner fundingagency mech_code mech_name indicator standardizedDisaggregate otherDisaggregate 
sitetype Fiscal_year -- Cumulative;
if Sitetype NE "Facility" then delete;
run;

data test3;
set test2;
if indicator = "HTS_TST" & standardizedDisaggregate NOTIN ("KeyPop/Result", "Total Numerator") then delete;
if indicator = "HTS_RECENT" & standardizedDisaggregate NOTIN ("KeyPop/HIVStatus", "Total Numerator") then delete;
if indicator = "HTS_SELF" & standardizedDisaggregate NOTIN ("KeyPop/HIVSelfTest", "Total Numerator") then delete;
if indicator = "KP_PREV" & standardizedDisaggregate NOTIN ("KeyPop", "Total Numerator") then delete;
if indicator = "PrEP_CURR" & standardizedDisaggregate NOTIN ("KeyPop", "Total Numerator") then delete;
if indicator = "PrEP_NEW" & standardizedDisaggregate NOTIN ("KeyPopAbr", "Total Numerator") then delete;
if indicator = "TX_NEW" & standardizedDisaggregate NOTIN ("KeyPop/HIVStatus", "Total Numerator") then delete;
run;


proc sort data = test3  out = &nxt;
by orgunitUID;
run;

%mend kp;





%kp (Rwanda);
%kp (Mozambique);
%kp (SAfrica);
%kp (Angola);
%kp (AsiaReg);
%kp (Botswana);
%kp (Burma);
%kp (Burundi);
%kp (Cambodia);
%kp (Cameroon);
%kp (CaribbReg);
%kp (CentAmer);
%kp (CentAsia);
%kp (DRC);
%kp (DR);
%kp (Ethiopia);
%kp (Ghana);
%kp (Haiti);
%kp (India);
%kp (Indonesia);
%kp (Kenya);
%kp (Lesotho);
%kp (Malawi);
%kp (Namibia);
%kp (Nigeria);
%kp (PNG);
%kp (SSudan);
%kp (Eswatini);
%kp (Tanzania);
%kp (Uganda);
%kp (Ukraine);
%kp (Vietnam);
%kp (Zambia);
%kp (Zimbabwe);
%kp (CIV); /* Would need to do this with double quotes */


data master;
set Rwanda Mozambique SAfrica Angola AsiaReg Botswana Burma Burundi Cambodia Cameroon CaribbReg CentAmer CentAsia DRC DR Ethiopia 
Ghana Haiti India Indonesia Kenya Lesotho Malawi Namibia Nigeria PNG SSudan Eswatini Tanzania Uganda Ukraine Vietnam Zambia Zimbabwe CIV;
run; 

data master2;
set master;
if Targets = . then Targets = 0;
if qtr1 = . then qtr1 = 0;
if qtr2 = . then qtr2 = 0;
if qtr3 = . then qtr3 = 0;
if qtr4 = . then qtr4 = 0;
if cumulative = . then cumulative = 0;
run;

data master3;
set master2;
if (targets = 0 & qtr1 = 0 & qtr2 = 0 & qtr3 = 0 & qtr4 = 0 & cumulative = 0) then delete;
run;



data master19;
set master3;
where fiscal_year = "2019";
drop targets;
run;


*split into indicator datasets**;


*HTS;
data master19hts;
set master19;
where indicator = "HTS_TST";

data master19hts_tn;
set master19hts;
where standardizeddisaggregate = "Total Numerator"; 

data master19hts_kp;
set master19hts;
where standardizeddisaggregate NE "Total Numerator";
run;

proc sql;
create table master19hts_kp as
select orgunituid, sitename, operatingunit, psnu, indicator, sum(cumulative) as kp_cumulative
from master19hts_kp
group by orgunituid;
Quit;

proc sort data = master19hts_kp nodupkey;
by orgunituid;
run;

proc sql;
create table master19hts_tn as
select orgunituid, indicator, sum(cumulative) as tn_cumulative
from master19hts_tn
group by orgunituid;
Quit;

proc sort data = master19hts_tn nodupkey;
by orgunituid;
run;

data master19hts2;
merge master19hts_kp (in=a) master19hts_tn (in=b);
by orgunituid;
if a;
run;

data master19hts3;
set master19hts2;
kp_ratio = (kp_cumulative/tn_cumulative);
run;

data master19hts3;
set master19hts3;
if kp_ratio LT .1 then delete;
run;



*SELF*;
data master19self;
set master19;
where indicator = "HTS_SELF";

data master19self_tn;
set master19self;
where standardizeddisaggregate = "Total Numerator"; 

data master19self_kp;
set master19self;
where standardizeddisaggregate NE "Total Numerator";
run;

proc sql;
create table master19self_kp as
select orgunituid, sitename, operatingunit, psnu, indicator, sum(cumulative) as kp_cumulative
from master19self_kp
group by orgunituid;
Quit;

proc sort data = master19self_kp nodupkey;
by orgunituid;
run;

proc sql;
create table master19self_tn as
select orgunituid, indicator, sum(cumulative) as tn_cumulative
from master19self_tn
group by orgunituid;
Quit;

proc sort data = master19self_tn nodupkey;
by orgunituid;
run;

data master19self2;
merge master19self_kp (in=a) master19self_tn (in=b);
by orgunituid;
if a;
run;

data master19self3;
set master19self2;
kp_ratio = (kp_cumulative/tn_cumulative);
run;

data master19self3;
set master19self3;
if kp_ratio LT .1 then delete;
run;



*KP_PREV*;
data master19prev;
set master19;
where indicator = "KP_PREV";

data master19prev_tn;
set master19prev;
where standardizeddisaggregate = "Total Numerator"; 

data master19prev_kp;
set master19prev;
where standardizeddisaggregate NE "Total Numerator";
run;

proc sql;
create table master19prev_kp as
select orgunituid, sitename, operatingunit, psnu, indicator, sum(cumulative) as kp_cumulative
from master19prev_kp
group by orgunituid;
Quit;

proc sort data = master19prev_kp nodupkey;
by orgunituid;
run;

proc sql;
create table master19prev_tn as
select orgunituid, indicator, sum(cumulative) as tn_cumulative
from master19prev_tn
group by orgunituid;
Quit;

proc sort data = master19prev_tn nodupkey;
by orgunituid;
run;

data master19prev2;
merge master19prev_kp (in=a) master19prev_tn (in=b);
by orgunituid;
if a;
run;

data master19prev3;
set master19prev2;
kp_ratio = (kp_cumulative/tn_cumulative);
run;

data master19prev3;
set master19prev3;
if kp_ratio LT .1 then delete;
run;



*prep_new*;
data master19pnew;
set master19;
where indicator = "PrEP_NEW";

data master19pnew_tn;
set master19pnew;
where standardizeddisaggregate = "Total Numerator"; 

data master19pnew_kp;
set master19pnew;
where standardizeddisaggregate NE "Total Numerator";
run;

proc sql;
create table master19pnew_kp as
select orgunituid, sitename, operatingunit, psnu, indicator, sum(cumulative) as kp_cumulative
from master19pnew_kp
group by orgunituid;
Quit;

proc sort data = master19pnew_kp nodupkey;
by orgunituid;
run;

proc sql;
create table master19pnew_tn as
select orgunituid, indicator, sum(cumulative) as tn_cumulative
from master19pnew_tn
group by orgunituid;
Quit;

proc sort data = master19pnew_tn nodupkey;
by orgunituid;
run;

data master19pnew2;
merge master19pnew_kp (in=a) master19pnew_tn (in=b);
by orgunituid;
if a;
run;

data master19pnew3;
set master19pnew2;
kp_ratio = (kp_cumulative/tn_cumulative);
run;

data master19pnew3;
set master19pnew3;
if kp_ratio LT .1 then delete;
run;






*prep_curr*;
data master19pcurr;
set master19;
where indicator = "PrEP_CURR";

data master19pcurr_tn;
set master19pcurr;
where standardizeddisaggregate = "Total Numerator"; 

data master19pcurr_kp;
set master19pcurr;
where standardizeddisaggregate NE "Total Numerator";
run;

proc sql;
create table master19pcurr_kp as
select orgunituid, sitename, operatingunit, psnu, indicator, sum(cumulative) as kp_cumulative
from master19pcurr_kp
group by orgunituid;
Quit;

proc sort data = master19pcurr_kp nodupkey;
by orgunituid;
run;

proc sql;
create table master19pcurr_tn as
select orgunituid, indicator, sum(cumulative) as tn_cumulative
from master19pcurr_tn
group by orgunituid;
Quit;

proc sort data = master19pcurr_tn nodupkey;
by orgunituid;
run;

data master19pcurr2;
merge master19pcurr_kp (in=a) master19pcurr_tn (in=b);
by orgunituid;
if a;
run;

data master19pcurr3;
set master19pcurr2;
kp_ratio = (kp_cumulative/tn_cumulative);
run;

data master19pcurr3;
set master19pcurr3;
if kp_ratio LT .1 then delete;
run;



*HTS_RECENT*;
data master19recent;
set master19;
where indicator = "HTS_RECENT";

data master19recent_tn;
set master19recent;
where standardizeddisaggregate = "Total Numerator"; 

data master19recent_kp;
set master19recent;
where standardizeddisaggregate NE "Total Numerator";
run;

proc sql;
create table master19recent_kp as
select orgunituid, sitename, operatingunit, psnu, indicator, sum(cumulative) as kp_cumulative
from master19recent_kp
group by orgunituid;
Quit;

proc sort data = master19recent_kp nodupkey;
by orgunituid;
run;

proc sql;
create table master19recent_tn as
select orgunituid, indicator, sum(cumulative) as tn_cumulative
from master19recent_tn
group by orgunituid;
Quit;

proc sort data = master19recent_tn nodupkey;
by orgunituid;
run;

data master19recent2;
merge master19recent_kp (in=a) master19recent_tn (in=b);
by orgunituid;
if a;
run;

data master19recent3;
set master19recent2;
kp_ratio = (kp_cumulative/tn_cumulative);
run;

data master19recent3;
set master19recent3;
if kp_ratio LT .1 then delete;
run;




*tx_new*;
data master19tx;
set master19;
where indicator = "TX_NEW";

data master19tx_tn;
set master19tx;
where standardizeddisaggregate = "Total Numerator"; 

data master19tx_kp;
set master19tx;
where standardizeddisaggregate NE "Total Numerator";
run;
 
proc sql;
create table master19tx_kp as
select orgunituid, sitename, operatingunit, psnu, indicator, sum(cumulative) as kp_cumulative
from master19tx_kp
group by orgunituid;
Quit;

proc sort data = master19tx_kp nodupkey;
by orgunituid;
run;

proc sql;
create table master19tx_tn as
select orgunituid, indicator, sum(cumulative) as tn_cumulative
from master19tx_tn
group by orgunituid;
Quit;

proc sort data = master19tx_tn nodupkey;
by orgunituid;
run;

data master19tx2;
merge master19tx_kp (in=a) master19tx_tn (in=b);
by orgunituid;
if a;
run;

data master19tx3;
set master19tx2;
kp_ratio = (kp_cumulative/tn_cumulative);
run;

data master19tx3;
set master19tx3;
if kp_ratio LT .1 then delete;
run;


**aggregate cumulative from many rows to one in both kp and total num datasets for each indicator.
Then, merge total_num ;


data master19v2;
set master19tx3 master19pnew3 master19prev3  master19self3  master19hts3 master19recent3 master19pcurr3;
drop indicator -- kp_ratio;
run;

proc sort data = master19v2 nodupkey;
by orgunituid;
run;


proc export data = master19v2
dbms = excel outfile = "C:\Users\lqa9\Desktop\KP Request\KP_site_list_FY19results.xlsx"
replace;
run;
