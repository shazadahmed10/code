
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SAS script to estimate Factorized deduplication values for CDC 

Purpose: Creating CDC adjusted OU numbers for DFPM

Date created : 04/20/2017, 11/15/2017
Programmer: Imran Mujawar

Date modified: 11/16/2017, 11/16/2018
Programmer: Chesa  Cox, Shazad Ahmed

Datafiles: Site x IM by OU Pulled by Abe on 12/22/2017
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;

/*Setting data variable for output files*/
%LET todaydate = 2018_11_16;


/*Creating local libraries to store datasets*/
libname ou
"C:\Users\nde7\Desktop\SAS\DFPM\deduplibrary\TEST";

libname tl 
"C:\Users\nde7\Desktop\SAS\DFPM\deduplibrary\TEST\Tool";

/* Setting option to compress datasets */
options compress = yes;


/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*     Beginning of macro loop that outputs Fdupped data and validation tool*/
/*	   for specified countries and periods (can be listed together)*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/


%macro fdups(clist, yearQ);

%local i nxt;
%let i=1;
%do %while (%scan(&clist, &i) ne );

/*choosing country from the list*/
   %let nxt = %scan(&clist, &i);


/***************************************************************************************/
/*STEP 1: Import a country’s txt file. */
/***************************************************************************************/
%let filename = 
"\\cdc.gov\private\M133\nde7\Factview\SitexIM20171222\Site_IM_&nxt..txt";


/*Pulling the data using appropriate length statments to avoid truncation*/
data &nxt.;
infile 
&filename.
delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2;
/*using length statements to avoid truncation*/
informat orgUnitUID $50. ;
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
informat SNUPrioritization  $26. ;
informat mechanismUID $28. ;
informat PrimePartner $250. ;
informat FundingAgency $30. ;
informat MechanismID $50.;
informat ImplementingMechanismName $350. ;
informat CommunityUID $50. ; 
informat Community $75.; 
informat CommunityPrioritization $50.;   
informat FacilityUID $50. ;
informat Facility $75.;  
informat FacilityPrioritization  $50.;
informat SiteType $15.; 
informat dataElementUID $50.; 
informat indicator $255. ;
informat numeratorDenom $2. ;
informat indicatorType $25. ;
informat disaggregate $50. ;
informat standardizedDisaggregate $100. ;
informat categoryOptionComboUID $50.;
informat categoryOptionComboName $255. ;
informat AgeAsEntered $50. ;
informat AgeFine $50. ;
informat AgeSemiFine $50. ;
informat AgeCoarse $50. ;
informat Sex $50. ;
informat resultStatus $50. ;
informat otherDisaggregate $55. ;
informat coarseDisaggregate $50. ;
informat modality $100.;
informat isMCAD $25.;
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
informat ApprovalLevel $5. ;
informat ApprovalLevelDescription $5. ;


format orgUnitUID $50. ;
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
format SNUPrioritization  $26. ;
format mechanismUID $28. ;
format PrimePartner $250. ;
format FundingAgency $30. ;
format MechanismID $50.;
format ImplementingMechanismName $350. ;
format CommunityUID $50. ; 
format Community $75.; 
format CommunityPrioritization $50.;   
format FacilityUID $50. ;
format Facility $75.;  
format FacilityPrioritization  $50.;
format SiteType $15.; 
format dataElementUID $50.; 
format indicator $255. ;
format numeratorDenom $2. ;
format indicatorType $25. ;
format disaggregate $50. ;
format standardizedDisaggregate $100. ;
format categoryOptionComboUID $50.;
format categoryOptionComboName $255. ;
format AgeAsEntered $50. ;
format AgeFine $50. ;
format AgeSemiFine $50. ;
format AgeCoarse $50. ;
format Sex $50. ;
format resultStatus $50. ;
format otherDisaggregate $55. ;
format coarseDisaggregate $50. ;
format modality $100.;
format isMCAD $25.;
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
format ApprovalLevel $5. ;
format ApprovalLevelDescription $5. ;

input 
orgUnitUID $
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
SNUPrioritization  $
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
FacilityPrioritization  $
SiteType $ 
dataElementUID $ 
indicator $
numeratorDenom $
indicatorType $;
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
ApprovalLevel $
ApprovalLevelDescription $ ;

RUN;


/* Using the Site-IM FactView dataset sans MCAD */
data fdup1;
set &nxt.;
where isMCAD NOT in ("Y");
;
RUN;


/* Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save fdup1;
run;
quit;


/* Setting up macro loop for period */
%local j nyear;
%let j=1;
%do %while (%scan(&yearQ, &j) ne );

/* choosing period from the list */
   %let nyear = %scan(&yearQ, &j);
/***************************************************************************************/
/***************************************************************************************/
/***************************************************************************************/
/***************************************************************************************/
/***************************************************************************************/

%let data = fdup1;

%let varlist = 
orgUnitUID, 
CountryName,
indicator, 
disaggregate,
categoryOptionComboUID, 
categoryOptionComboName, 
numeratorDenom;

%let value = &nyear;



/***************************************************************************************/
/* SQL proc Aggregating by period in long format creating data points for estimation   */
/***************************************************************************************/

proc sql;
create table work.long as 

/* dedup DSD */
(select 
"&value" as periodx,
&varlist, 
"dedup_dsd" as var,
sum(&value) as val 
from work.&data
where MechanismID in ("00000") AND
indicatorType in ("DSD") AND 
&value  NOT in (., 0)
group by 
&varlist)

/* dedup TA */
union
(select 
"&value" as periodx,
&varlist, 
"dedup_ta" as var,
sum(&value) as val 
from work.&data
where MechanismID in ("00000") AND
indicatorType in ("TA") AND 
&value  NOT in (., 0)
group by 
&varlist)

/* Crosswalk dedup */
union
(select 
"&value" as periodx,
&varlist, 
"xdedup" as var,
sum(&value) as val 
from work.&data
where MechanismID in ("00001") AND
indicatorType in ("TA") AND 
&value  NOT in (., 0)
group by 
&varlist)

/* Max DSD value */
union
(select 
"&value" as periodx,
&varlist, 
"max_dsd" as var,
MAX(&value) as val 
from work.&data
where MechanismID NOT in ("00000", "00001") AND
indicatorType in ("DSD") AND 
&value  NOT in (., 0)
group by 
&varlist)

/* Max TA value */
union
(select
"&value" as periodx, 
&varlist, 
"max_ta" as var,
MAX(&value) as val 
from work.&data
where MechanismID NOT in ("00000", "00001") AND
indicatorType in ("TA") AND 
&value  NOT in (., 0)
group by 
&varlist)

/* Total DSD value */
union
(select 
"&value" as periodx,
&varlist, 
"sum_dsd_all" as var,
SUM(&value) as val 
from work.&data
where MechanismID NOT in ("00001") AND
indicatorType in ("DSD") AND 
&value  NOT in (., 0)
group by 
&varlist)

/* Total TA value */
union
(select 
"&value" as periodx,
&varlist, 
"sum_ta_all" as var,
SUM(&value) as val 
from work.&data
where MechanismID NOT in ("00001") AND
indicatorType in ("TA") AND 
&value  NOT in (., 0)
group by 
&varlist)

/*Number of CDC IMs (DSD) */
union
(select 
"&value" as periodx,
&varlist, 
"num_cdc_im_dsd" as var,
count (*) as val 
from work.&data
where MechanismID NOT in ("00001", "00000") AND
indicatorType in ("DSD") AND
FundingAgency in ("HHS/CDC") AND 
&value  NOT in (., 0)
group by 
&varlist)

/*Number of non-CDC IMs (DSD) */
union
(select 
"&value" as periodx,
&varlist, 
"num_ag_im_dsd" as var,
count (*) as val 
from work.&data
where MechanismID NOT in ("00001", "00000") AND
indicatorType in ("DSD") AND
FundingAgency NOT in ("HHS/CDC") AND 
&value  NOT in (., 0)
group by 
&varlist)

/*Number of CDC IMs (TA) */
union
(select 
"&value" as periodx,
&varlist, 
"num_cdc_im_ta" as var,
count (*) as val 
from work.&data
where MechanismID NOT in ("00001", "00000") AND
indicatorType in ("TA") AND
FundingAgency in ("HHS/CDC") AND 
&value  NOT in (., 0)
group by 
&varlist)

/*Number of non-CDC IMs (TA) */
union
(select 
"&value" as periodx,
&varlist, 
"num_ag_im_ta" as var,
count (*) as val 
from work.&data
where MechanismID NOT in ("00001", "00000") AND
indicatorType in ("TA") AND
FundingAgency NOT in ("HHS/CDC") AND 
&value  NOT in (., 0)
group by 
&varlist)

/*Max CDC value (DSD)*/
union
(select 
"&value" as periodx,
&varlist, 
"max_cdc_dsd" as var,
max(&value) as val 
from work.&data
where MechanismID NOT in ("00001", "00000") AND
indicatorType in ("DSD") AND
FundingAgency in ("HHS/CDC") AND 
&value  NOT in (., 0)
group by 
&varlist)

/*Max non-CDC value (DSD)*/
union
(select 
"&value" as periodx,
&varlist, 
"max_ag_dsd" as var,
max(&value) as val 
from work.&data
where MechanismID NOT in ("00001", "00000") AND
indicatorType in ("DSD") AND
FundingAgency NOT in ("HHS/CDC") AND 
&value  NOT in (., 0)
group by 
&varlist)

/*Max CDC value (TA) */
union
(select 
"&value" as periodx,
&varlist, 
"max_cdc_ta" as var,
max(&value) as val 
from work.&data
where MechanismID NOT in ("00001", "00000") AND
indicatorType in ("TA") AND
FundingAgency in ("HHS/CDC") AND 
&value  NOT in (., 0)
group by 
&varlist)

/*Max non-CDC value (TA)*/
union
(select 
"&value" as periodx,
&varlist, 
"max_ag_ta" as var,
max(&value) as val 
from work.&data
where MechanismID NOT in ("00001", "00000") AND
indicatorType in ("TA") AND
FundingAgency NOT in ("HHS/CDC") AND 
&value  NOT in (., 0)
group by 
&varlist)

/*CDC total value (DSD) */
union
(select 
"&value" as periodx,
&varlist, 
"sum_cdc_dsd" as var,
sum(&value) as val 
from work.&data
where MechanismID NOT in ("00001", "00000") AND
indicatorType in ("DSD") AND
FundingAgency in ("HHS/CDC") AND 
&value  NOT in (., 0)
group by 
&varlist)

/* non-CDC total value (DSD) */
union
(select 
"&value" as periodx,
&varlist, 
"sum_ag_dsd" as var,
sum(&value) as val 
from work.&data
where MechanismID NOT in ("00001", "00000") AND
indicatorType in ("DSD") AND
FundingAgency NOT in ("HHS/CDC") AND 
&value  NOT in (., 0)
group by 
&varlist)

/*CDC total value (TA)*/
union
(select 
"&value" as periodx,
&varlist, 
"sum_cdc_ta" as var,
sum(&value) as val 
from work.&data
where MechanismID NOT in ("00001", "00000") AND
indicatorType in ("TA") AND
FundingAgency in ("HHS/CDC") AND 
&value  NOT in (., 0)
group by 
&varlist)

/*non-CDC total value */
union
(select 
"&value" as periodx,
&varlist, 
"sum_ag_ta" as var,
sum(&value) as val 
from work.&data
where MechanismID NOT in ("00001", "00000") AND
indicatorType in ("TA") AND
FundingAgency NOT in ("HHS/CDC") AND 
&value  NOT in (., 0)
group by 
&varlist)

;

quit;


/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save long fdup1;
run;
quit;


/***************************************************************************************/
/***************************************************************************************/
/***************************************************************************************/

/*Checking for missing values */
data dx;
set long;
if val in (0,.) then delete;
RUN;


/* Variable list for the SQL step macros */
%let varlistx = 
orgUnitUID
CountryName 
indicator
disaggregate 
categoryOptionComboUID
categoryOptionComboName 
numeratorDenom;


/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save dx fdup1;
run;
quit;


/*Sorting data for transposing*/
proc sort data=dx;
by 
Periodx
&varlistx;
RUN;


/*Transposing data by data points required for estimation in wide format */
PROC TRANSPOSE DATA=dx
OUT=wide; 
BY 
Periodx
&varlistx;
VAR val;
ID var;
RUN;


/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save wide fdup1;
run;
quit;


/* Checking the wide dataset */
data check;
set wide;
keep 
Periodx
&varlistx

dedup_dsd
dedup_ta
max_dsd
max_ta
sum_dsd_all
sum_ta_all
xdedup

num_cdc_im_dsd
num_ag_im_dsd
num_cdc_im_ta
num_ag_im_ta
max_cdc_dsd
max_ag_dsd
max_cdc_ta
max_ag_ta
sum_cdc_dsd
sum_ag_dsd
sum_cdc_ta
sum_ag_ta;
RUN;

/*Organizing the columns of dataset*/
data wide1;
retain 
Periodx
&varlistx

dedup_dsd
dedup_ta
max_dsd
max_ta
sum_dsd_all
sum_ta_all
xdedup

num_cdc_im_dsd
num_ag_im_dsd
num_cdc_im_ta
num_ag_im_ta
max_cdc_dsd
max_ag_dsd
max_cdc_ta
max_ag_ta
sum_cdc_dsd
sum_ag_dsd
sum_cdc_ta
sum_ag_ta;

set wide;

array vars (*)
Periodx
&varlistx;

array varsx (*)
dedup_dsd
dedup_ta
max_dsd
max_ta
sum_dsd_all
sum_ta_all
xdedup

num_cdc_im_dsd
num_ag_im_dsd
num_cdc_im_ta
num_ag_im_ta
max_cdc_dsd
max_ag_dsd
max_cdc_ta
max_ag_ta
sum_cdc_dsd
sum_ag_dsd
sum_cdc_ta
sum_ag_ta;

keep 
Periodx
&varlistx

dedup_dsd
dedup_ta
max_dsd
max_ta
sum_dsd_all
sum_ta_all
xdedup

num_cdc_im_dsd
num_ag_im_dsd
num_cdc_im_ta
num_ag_im_ta
max_cdc_dsd
max_ag_dsd
max_cdc_ta
max_ag_ta
sum_cdc_dsd
sum_ag_dsd
sum_cdc_ta
sum_ag_ta;

RUN;


/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save wide1 fdup1;
run;
quit;


/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
/*Script to identify  type of Dedup and XDedup (Sum, Max or Custom)*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
data dedup;
set wide1;
/* for dedup_type_dsd */
if dedup_dsd in (., 0) then dedup_type_dsd = "S";
else if dedup_dsd NOT in (., 0) then do;
	if max_dsd = sum_dsd_all then dedup_type_dsd = "M";
	else dedup_type_dsd = "C";
end;

/* for dedup_type_ta */
if dedup_ta in (., 0) then dedup_type_ta = "S";
else if dedup_ta NOT in (., 0) then do;
	if max_ta = sum_ta_all then dedup_type_ta = "M";
	else dedup_type_ta = "C";
end;

/* for xdedup_type */
if xdedup in (., 0) then xdedup_type = "S";
else if xdedup NOT in (., 0) then do;
	if abs(xdedup) = min(sum_dsd_all,sum_ta_all)
    then xdedup_type = "M";
	else xdedup_type = "C";
end;

RUN;


/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save dedup fdup1;
run;
quit;


/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/* Script to estimate Fdup values for various scenarios		      */
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
data fdupx;
set dedup;
/* For DSD first */
/*Estimate Fdups only when more than two CDC IMs for DSD*/
if num_cdc_im_dsd > 1 then do;
	/*when dedup_type_dsd is MAX */
	if dedup_type_dsd = "M" then do;
		/*When only CDC IMs at site for DSD*/
		if num_ag_im_dsd in (.,0) then fdup_dsd = abs(dedup_dsd);
		else if max_cdc_dsd >= max_ag_dsd then /*When CDC is max*/
		 /* Fdup = ?IMCDC(i) – max{IMCDC(i)} */
		fdup_dsd = sum_cdc_dsd - max_cdc_dsd;
		else if max_cdc_dsd < max_ag_dsd then do; /*When CDC !not! max*/
			/* max(0, ?IMCDC(i) - max{IMOther(j)}) */ 
			fdup_dsd_low = max(0,(sum_cdc_dsd - max_ag_dsd));  
			/* ?IMCDC(i) – max{IMCDC(i)} */ 
			fdup_dsd_high = sum_cdc_dsd - max_cdc_dsd;
		end;
	end;
	/*when dedup_type_dsd is CUSTOM */
	else if dedup_type_dsd = "C" then do;
		/*When only CDC IMs at site for DSD*/
		if num_ag_im_dsd in (.,0) then fdup_dsd = abs(dedup_dsd);
		/* Multiple agencies */
		else if num_ag_im_dsd NOT in (.,0) then do;
			/* Fdup(high) = min{Dedup, ?IMCDC(i) – max{IMCDC(i)} */
			fdup_dsd_high = min(abs(dedup_dsd), (sum_cdc_dsd - max_cdc_dsd));
			/* For Low estimate scenarios */
			/* When only one non-CDC IM present */
			if num_ag_im_dsd = 1 then do;
				if  max_cdc_dsd >= max_ag_dsd then /*When CDC is max*/
				/* Fdup(low) = max {0, dedup – IMOther} */
				fdup_dsd_low = max(0, (abs(dedup_dsd)-max_ag_dsd));
				else if  max_cdc_dsd < max_ag_dsd  then /*When CDC is !not! max*/
				/* Fdup(low) = max {0, dedup – min{? IMCDC(i), IMOther}} */
				fdup_dsd_low = max(0, (abs(dedup_dsd)- min(sum_cdc_dsd,max_ag_dsd)));
			end;
			/* This very rare SCENARIO is murky, so flagging situation */
			else if num_ag_im_dsd > 1 then do;
				Flag_dsd_low = 1;
				fdup_dsd_low = 0;
			end;
		end;
	end;
end;

/* For TA first */
/*Estimate Fdups only when more than two CDC IMs for ta*/
if num_cdc_im_ta > 1 then do;
	/*when dedup_type_ta is MAX */
	if dedup_type_ta = "M" then do;
		/*When only CDC IMs at site for ta*/
		if num_ag_im_ta in (.,0) then fdup_ta = abs(dedup_ta);
		else if max_cdc_ta >= max_ag_ta then /*When CDC is max*/
		 /* Fdup = ?IMCDC(i) – max{IMCDC(i)} */
		fdup_ta = sum_cdc_ta - max_cdc_ta;
		else if max_cdc_ta < max_ag_ta then do; /*When CDC !not! max*/
			/* max(0, ?IMCDC(i) - max{IMOther(j)}) */ 
			fdup_ta_low = max(0,(sum_cdc_ta - max_ag_ta));  
			/* ?IMCDC(i) – max{IMCDC(i)} */ 
			fdup_ta_high = sum_cdc_ta - max_cdc_ta;
		end;
	end;
	/*when dedup_type_ta is CUSTOM */
	else if dedup_type_ta = "C" then do;
		/*When only CDC IMs at site for ta*/
		if num_ag_im_ta in (.,0) then fdup_ta = abs(dedup_ta);
		/* Multiple agencies */
		else if num_ag_im_ta NOT in (.,0) then do;
			/* Fdup(high) = min{Dedup, ?IMCDC(i) – max{IMCDC(i)} */
			fdup_ta_high = min(abs(dedup_ta), (sum_cdc_ta - max_cdc_ta));
			/* For Low estimate scenarios */
			/* When only one non-CDC IM present */
			if num_ag_im_ta = 1 then do;
				if  max_cdc_ta >= max_ag_ta then /*When CDC is max*/
				/* Fdup(low) = max {0, dedup – IMOther} */
				fdup_ta_low = max(0, (abs(dedup_ta)-max_ag_ta));
				else if  max_cdc_ta < max_ag_ta  then /*When CDC is !not! max*/
				/* Fdup(low) = max {0, dedup – min{? IMCDC(i), IMOther}} */
				fdup_ta_low = max(0, (abs(dedup_ta)- min(sum_cdc_ta,max_ag_ta)));
			end;
			/* This very rare SCENARIO is murky, so flagging situation and assuming zero overlap */
			else if num_ag_im_ta > 1 then do;
				Flag_ta_low = 1;
				fdup_ta_low = 0;
			end;
		end;
	end;
end;

RUN;


/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save fdupx fdup1;
run;
quit;


/*Creating some flagging variables on whether estimate types are single or a range*/
data fdups;
set fdupx;
/*For DSD when there is a max dedup and more than one CDC IM present for DSD*/
if dedup_type_dsd in ("M","C") AND num_cdc_im_dsd > 1 then do;

	/*when dedup_type_dsd is MAX */
	if dedup_type_dsd = "M" then do;
		/*When only CDC IMs at site for DSD*/
		if num_ag_im_dsd in (.,0) then fdup_dsd_type = "S";
		else if max_cdc_dsd >= max_ag_dsd then /*When CDC is max*/
		 /* Fdup = ?IMCDC(i) – max{IMCDC(i)} */
		fdup_dsd_type = "S";
		else if max_cdc_dsd < max_ag_dsd then do; /*When CDC !not! max*/
			/* max(0, ?IMCDC(i) - max{IMOther(j)}) */ 
			fdup_dsd_type = "R";  
			/* ?IMCDC(i) – max{IMCDC(i)} */ 
			fdup_dsd_type = "R";
		end;
	end;
	/*when dedup_type_dsd is CUSTOM */
	else if dedup_type_dsd = "C" then do;
		/*When only CDC IMs at site for DSD*/
		if num_ag_im_dsd in (.,0) then fdup_dsd_type = "S";
		/* Multiple agencies */
		else if num_ag_im_dsd NOT in (.,0) then do;
			/* Fdup(high) = min{Dedup, ?IMCDC(i) – max{IMCDC(i)} */
			fdup_dsd_type = "R";
			/* For Low estimate scenarios */
			/* When only one non-CDC IM present */
			if num_ag_im_dsd = 1 then do;
				if  max_cdc_dsd >= max_ag_dsd then /*When CDC is max*/
				/* Fdup(low) = max {0, dedup – IMOther} */
				fdup_dsd_type = "R";
				else if  max_cdc_dsd < max_ag_dsd  then /*When CDC is !not! max*/
				/* Fdup(low) = max {0, dedup – min{? IMCDC(i), IMOther}} */
				fdup_dsd_type = "R";
			end;
			/* This SCENARIO is murky, so flagging situation */
			else if num_ag_im_dsd > 1 then fdup_dsd_type = "N";
		end;
	end;
end;

/*For ta when there is a max dedup and more than one CDC IM present for ta*/
if dedup_type_ta in ("M","C") AND num_cdc_im_ta > 1 then do;

	/*when dedup_type_ta is MAX */
	if dedup_type_ta = "M" then do;
		/*When only CDC IMs at site for ta*/
		if num_ag_im_ta in (.,0) then fdup_ta_type = "S";
		else if max_cdc_ta >= max_ag_ta then /*When CDC is max*/
		 /* Fdup = ?IMCDC(i) – max{IMCDC(i)} */
		fdup_ta_type = "S";
		else if max_cdc_ta < max_ag_ta then do; /*When CDC !not! max*/
			/* max(0, ?IMCDC(i) - max{IMOther(j)}) */ 
			fdup_ta_type = "R";  
			/* ?IMCDC(i) – max{IMCDC(i)} */ 
			fdup_ta_type = "R";
		end;
	end;
	/*when dedup_type_ta is CUSTOM */
	else if dedup_type_ta = "C" then do;
		/*When only CDC IMs at site for ta*/
		if num_ag_im_ta in (.,0) then fdup_ta_type = "S";
		/* Multiple agencies */
		else if num_ag_im_ta NOT in (.,0) then do;
			/* Fdup(high) = min{Dedup, ?IMCDC(i) – max{IMCDC(i)} */
			fdup_ta_type = "R";
			/* For Low estimate scenarios */
			/* When only one non-CDC IM present */
			if num_ag_im_ta = 1 then do;
				if  max_cdc_ta >= max_ag_ta then /*When CDC is max*/
				/* Fdup(low) = max {0, dedup – IMOther} */
				fdup_ta_type = "R";
				else if  max_cdc_ta < max_ag_ta  then /*When CDC is !not! max*/
				/* Fdup(low) = max {0, dedup – min{? IMCDC(i), IMOther}} */
				fdup_ta_type = "R";
			end;
			/* This SCENARIO is murky, so flagging situation */
			else if num_ag_im_ta > 1 then fdup_ta_type = "N";
		end;
	end;
end;

RUN;


/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save fdups fdup1;
run;
quit;


/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*          Script to estimate X-Fdup values					      */
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
data xfdup;
set fdups;
/*array vars (*) sum_cdc_dsd_f sum_cdc_dsd_f_low sum_cdc_dsd_f_high*/
/*			   sum_cdc_ta_f sum_cdc_ta_f_low sum_cdc_ta_f_high;*/
/*Estimate X-Fdups only when CDC has values for DSD and TA and a Xdedup value */
if xdedup_type in ("M","C") AND 
sum_cdc_dsd not in (.,0) AND 
sum_cdc_ta not in (.,0) then do;
	* Creating estimates for overall CDC DSD and TA values;
	if fdup_dsd_type = "S" then 
	sum_cdc_dsd_f = sum(sum_cdc_dsd,-(fdup_dsd));
	else if fdup_dsd_type = "R" then do;
		sum_cdc_dsd_f_low = sum(sum_cdc_dsd,-(fdup_dsd_high));
		sum_cdc_dsd_f_high = sum(sum_cdc_dsd,-(fdup_dsd_low));
	end;
	if fdup_ta_type = "S" then 
	sum_cdc_ta_f = sum(sum_cdc_ta,-(fdup_ta));
	else if fdup_ta_type = "R" then do;
		sum_cdc_ta_f_low = sum(sum_cdc_ta,-(fdup_ta_high));
		sum_cdc_ta_f_high = sum(sum_cdc_ta,-(fdup_ta_low));
	end;
 	/* Calculating Xdedup %*/
	if xdedup_type in ("C") then 
	p_xdedup = abs(xdedup)/(min(sum_dsd_all, sum_ta_all));
end;
RUN;


/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save xfdup fdup1;
run;
quit;



data xfdups;
set xfdup;
/*Estimate X-Fdups only when CDC has values for DSD and TA and a Xdedup value */
if xdedup_type in ("M","C") AND 
sum_cdc_dsd not in (.,0) AND 
sum_cdc_ta not in (.,0) then do;
	/* When only CDC IMs at site for both DSD and TA, same for MAX or CUSTOM */
	if num_ag_im_dsd in (.,0) AND num_ag_im_ta in (.,0) then 
	xfdup = abs(xdedup);
	/* When xdedup type is MAX*/
	else if xdedup_type in ("M") then do;
		if 	fdup_dsd_type = "S" AND fdup_ta_type = "S" then 
		/* XFdup = min{ XDedup, min{CDC(DSD), CDC(TA)} } */
		xfdup = min( abs(xdedup), min(sum_cdc_dsd_f, sum_cdc_ta_f) );
		else if fdup_dsd_type = "S" AND fdup_ta_type = "R" then do;
			xfdup_high = min( abs(xdedup), min(sum_cdc_dsd_f, sum_cdc_ta_f_low) );
			xfdup_low = min( abs(xdedup), min(sum_cdc_dsd_f, sum_cdc_ta_f_high) );
		end;
		else if fdup_dsd_type = "R" AND fdup_ta_type = "S" then do;
			xfdup_high = min( abs(xdedup), min(sum_cdc_dsd_f_low, sum_cdc_ta_f) );
			xfdup_low = min( abs(xdedup), min(sum_cdc_dsd_f_high, sum_cdc_ta_f) );
		end;
		else if fdup_dsd_type = "R" AND fdup_ta_type = "R" then do;
			xfdup_high = min( abs(xdedup), min(sum_cdc_dsd_f_low, sum_cdc_ta_f_low) );
			xfdup_low = min( abs(xdedup), min(sum_cdc_dsd_f_high, sum_cdc_ta_f_high) );
		end;
	end;
	/* When xdedup type is CUSTOM */
	else if xdedup_type in ("C") then do;
		if 	fdup_dsd_type = "S" AND fdup_ta_type = "S" then 
		xfdup = min( abs(xdedup), p_xdedup*(min(sum_cdc_dsd_f, sum_cdc_ta_f)) );
		else if fdup_dsd_type = "S" AND fdup_ta_type = "R" then do;
			xfdup_high = min( abs(xdedup), p_xdedup*(min(sum_cdc_dsd_f, sum_cdc_ta_f_low)) );
			xfdup_low = min( abs(xdedup), p_xdedup*(min(sum_cdc_dsd_f, sum_cdc_ta_f_high)) );
		end;
		else if fdup_dsd_type = "R" AND fdup_ta_type = "S" then do;
			xfdup_high = min( abs(xdedup), p_xdedup*(min(sum_cdc_dsd_f_low, sum_cdc_ta_f)) );
			xfdup_low = min( abs(xdedup), p_xdedup*(min(sum_cdc_dsd_f_high, sum_cdc_ta_f)) );
		end;
		else if fdup_dsd_type = "R" AND fdup_ta_type = "R" then do;
			xfdup_high = min( abs(xdedup), p_xdedup*(min(sum_cdc_dsd_f_low, sum_cdc_ta_f_low)) );
			xfdup_low = min( abs(xdedup), p_xdedup*(min(sum_cdc_dsd_f_high, sum_cdc_ta_f_high)) );
		end;
	end;
end;
RUN;	


/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save xfdups fdup1;
run;
quit;


/***************************************************************************************/
/***************************************************************************************/
/***** 2ND SQL Step to put data back in long original format, but with Fdups included **/
/***************************************************************************************/
/***************************************************************************************/

%let data = xfdups;

%let nvarlist = 
Periodx,
CountryName, 
indicator, 
disaggregate,
categoryOptionComboUID, 
categoryOptionComboName, 
numeratorDenom;


/***************************************************************************************/
/* Aggregating by period in long format by Site only */
proc sql;
create table work.OUlevel as 

/*dsd fdups */
(select 
"HHS/CDC" as FundingAgency,
&nvarlist,
"DSD" as indicatorType,
"Point Estimate" as value_type,
sum(-(fdup_dsd)) as value
from work.&data
where fdup_dsd not in (0,.)
group by 
&nvarlist)

union
/*dsd fdups_low */
(select 
"HHS/CDC" as FundingAgency,
&nvarlist,
"DSD" as indicatorType,
"Low_Range" as value_type,
sum(-(fdup_dsd_low)) as value
from work.&data
where fdup_dsd_low not in (.) 
group by 
&nvarlist)

union
/*dsd fdups_high */
(select 
"HHS/CDC" as FundingAgency,
&nvarlist,
"DSD" as indicatorType,
"High_Range" as value_type,
sum(-(fdup_dsd_high)) as value
from work.&data
where fdup_dsd_high not in (0,.) 
group by 
&nvarlist)

union
/* Rare scenario where low values unestimable */
(select 
"HHS/CDC" as FundingAgency,
&nvarlist,
"DSD" as indicatorType,
"No_Low" as value_type,
sum(Flag_dsd_low) as value
from work.&data
where Flag_dsd_low = 1 
group by 
&nvarlist)

union
/*ta fdups */
(select 
"HHS/CDC" as FundingAgency,
&nvarlist,
"TA" as indicatorType,
"Point Estimate" as value_type,
sum(-(fdup_ta)) as value
from work.&data
where fdup_ta not in (0,.) 
group by 
&nvarlist)

union
/*ta fdups_low */
(select 
"HHS/CDC" as FundingAgency,
&nvarlist,
"TA" as indicatorType,
"Low_Range" as value_type,
sum(-(fdup_ta_low)) as value
from work.&data
where fdup_ta_low not in (.) 
group by 
&nvarlist)

union
/*ta fdups_high */
(select 
"HHS/CDC" as FundingAgency,
&nvarlist,
"TA" as indicatorType,
"High_Range" as value_type,
sum(-(fdup_ta_high)) as value
from work.&data
where fdup_ta_high not in (0,.)
group by 
&nvarlist)

union
/* Rare scenario where low values unestimable2 */
(select 
"HHS/CDC" as FundingAgency,
&nvarlist,
"TA" as indicatorType,
"No_Low" as value_type,
sum(Flag_ta_low) as value
from work.&data
where Flag_ta_low = 1 
group by 
&nvarlist)

union
/*xfdups */
(select 
"HHS/CDC" as FundingAgency,
&nvarlist,
"TA" as indicatorType,
"XFdup Point Estimate" as value_type,
sum(-(xfdup)) as value
from work.&data
where xfdup not in (0,.)
group by 
&nvarlist)

union
/*xfdups_low */
(select 
"HHS/CDC" as FundingAgency,
&nvarlist,
"TA" as indicatorType,
"XFdup Low_Range" as value_type,
sum(-(xfdup_low)) as value
from work.&data
where xfdup_low not in (.) 
group by 
&nvarlist)

union
/*xfdups_high */
(select 
"HHS/CDC" as FundingAgency,
&nvarlist,
"TA" as indicatorType,
"XFdup High_Range" as value_type,
sum(-(xfdup_high)) as value
from work.&data
where xfdup_high not in (0,.)
group by 
&nvarlist)

union
/* CDC data */
(select
FundingAgency,
"&value" as periodx, 
CountryName,
indicator,
disaggregate,
categoryOptionComboUID, 
categoryOptionComboName, 
numeratorDenom,
indicatorType,
"" as value_type,
sum(&nyear) as value
from work.fdup1
where FundingAgency in ("HHS/CDC") 
group by 
FundingAgency,
CountryName,
indicator,
disaggregate,
categoryOptionComboUID, 
categoryOptionComboName, 
numeratorDenom,
indicatorType);

quit;


/***************************************************************************************/
/***************************************************************************************/
/*****        3rd SQL Step to create validation tool at Site-IM level 	****************/
/***************************************************************************************/
/***************************************************************************************/

 

%let data = xfdups;

%let nvarlist = 
orgUnitUID,
CountryName, 
indicator,
disaggregate,
categoryOptionComboUID,
categoryOptionComboName, 
numeratorDenom;

/***************************************************************************************/
/* Aggregating by period in long format by Site only */
proc sql;
create table work.TOOL as 

/*dsd fdups */
(select 
"HHS/CDC" as FundingAgency,
"Fdups IM" as ImplementingMechanismName,
"_Fdup0" as MechanismID,
&nvarlist,
"DSD" as indicatorType,
"Point Estimate" as value_type,
sum(-(fdup_dsd)) as value
from work.&data
where fdup_dsd not in (0,.)
group by 
&nvarlist)

union
/*dsd fdups_low */
(select 
"HHS/CDC" as FundingAgency,
"Fdups IM" as ImplementingMechanismName,
"_Low_0" as MechanismID,
&nvarlist,
"DSD" as indicatorType,
"Low_Range" as value_type,
sum(-(fdup_dsd_low)) as value
from work.&data
where fdup_dsd_low not in (.) 
group by 
&nvarlist)

union
/*dsd fdups_high */
(select 
"HHS/CDC" as FundingAgency,
"Fdups IM" as ImplementingMechanismName,
"_High_0" as MechanismID,
&nvarlist,
"DSD" as indicatorType,
"High_Range" as value_type,
sum(-(fdup_dsd_high)) as value
from work.&data
where fdup_dsd_high not in (0,.) 
group by 
&nvarlist)

union
/* Rare scenario where low values unestimable2 */
(select 
"HHS/CDC" as FundingAgency,
"Fdups IM" as ImplementingMechanismName,
"_No_Low" as MechanismID,
&nvarlist,
"DSD" as indicatorType,
"No_Low" as value_type,
sum(Flag_dsd_low) as value
from work.&data
where Flag_dsd_low = 1 
group by 
&nvarlist)

union
/*ta fdups */
(select 
"HHS/CDC" as FundingAgency,
"Fdups IM" as ImplementingMechanismName,
"_Fdup0" as MechanismID,
&nvarlist,
"TA" as indicatorType,
"Point Estimate" as value_type,
sum(-(fdup_ta)) as value
from work.&data
where fdup_ta not in (0,.) 
group by 
&nvarlist)

union
/*ta fdups_low */
(select 
"HHS/CDC" as FundingAgency,
"Fdups IM" as ImplementingMechanismName,
"_Low_0" as MechanismID,
&nvarlist,
"TA" as indicatorType,
"Low_Range" as value_type,
sum(-(fdup_ta_low)) as value
from work.&data
where fdup_ta_low not in (.) 
group by 
&nvarlist)

union
/*ta fdups_high */
(select 
"HHS/CDC" as FundingAgency,
"Fdups IM" as ImplementingMechanismName,
"_High_0" as MechanismID,
&nvarlist,
"TA" as indicatorType,
"High_Range" as value_type,
sum(-(fdup_ta_high)) as value
from work.&data
where fdup_ta_high not in (0,.)
group by 
&nvarlist)

union
/* Rare scenario where low values unestimable */
(select 
"HHS/CDC" as FundingAgency,
"Fdups IM" as ImplementingMechanismName,
"_No_Low" as MechanismID,
&nvarlist,
"TA" as indicatorType,
"No_Low" as value_type,
sum(Flag_ta_low) as value
from work.&data
where Flag_ta_low = 1 
group by 
&nvarlist)

union
/*xfdups */
(select 
"HHS/CDC" as FundingAgency,
"Fdups IM" as ImplementingMechanismName,
"_Xfdup01" as MechanismID,
&nvarlist,
"TA" as indicatorType,
"XFdup Point Estimate" as value_type,
sum(-(xfdup)) as value
from work.&data
where xfdup not in (0,.)
group by 
&nvarlist)

union
/*xfdups_low */
(select 
"HHS/CDC" as FundingAgency,
"Fdups IM" as ImplementingMechanismName,
"_Xlow_01" as MechanismID,
&nvarlist,
"TA" as indicatorType,
"XFdup Low_Range" as value_type,
sum(-(xfdup_low)) as value
from work.&data
where xfdup_low not in (.) 
group by 
&nvarlist)

union
/*xfdups_high */
(select 
"HHS/CDC" as FundingAgency,
"Fdups IM" as ImplementingMechanismName,
"_Xhigh_01" as MechanismID,
&nvarlist,
"TA" as indicatorType,
"XFdup High_Range" as value_type,
sum(-(xfdup_high)) as value
from work.&data
where xfdup_high not in (0,.)
group by 
&nvarlist);

	QUIT;


/* Modifying the final tool dataset */
data toolx;
length FundingAgency $30. ;
length MechanismID $50.;
length ImplementingMechanismName $350. ;
length indicatorType $25. ;
set tool;

matchvar = 
strip(orgUnitUID)|| " | " ||
strip(indicator)|| " | " || 
strip(disaggregate)|| " | " || 
strip(categoryOptionComboName)|| " | " || 
strip(numeratorDenom);

RUN; 


data fdup2;
set fdup1;
matchvar = 
strip(orgUnitUID)|| " | " ||
strip(indicator)|| " | " || 
strip(disaggregate)|| " | " || 
strip(categoryOptionComboName)|| " | " || 
strip(numeratorDenom);
RUN; 


proc sql;
create table work.TOOL2 as 

/* The other data for sites with Fdups */
(select
FundingAgency,
ImplementingMechanismName,
MechanismID,
"&value" as periodx, 
orgUnitUID,
CountryName,
indicator,
disaggregate,
categoryOptionComboName, 
numeratorDenom,
indicatorType,
"" as value_type,
sum(&nyear) as value,
matchvar
from work.fdup2
where matchvar in (
					select distinct matchvar from TOOLx  
					)
group by 
FundingAgency,
ImplementingMechanismName,
MechanismID,
orgUnitUID,
CountryName,
indicator,
disaggregate,
categoryOptionComboName, 
numeratorDenom,
indicatorType, 
matchvar);

quit;


/* Appending the datasets to get final tool dataset */
data tool_final;
set toolx tool2;
RUN;


/* Final Dataset */
data ou.&nxt._&nyear._F;
set OUlevel;
RUN;

/* Final Tool datasets */
data tl.&nxt._&nyear._F;
set tool_final;
disaggvar = 
strip(indicator)|| " | " || 
strip(disaggregate)|| " | " || 
strip(categoryOptionComboName)|| " | " || 
strip(numeratorDenom);
MechID_Name = strip(MechanismID) || "-" || strip(ImplementingMechanismName);
RUN;


/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save xfdups fdup1;
run;
quit;


      %let j = %eval(&j + 1);
%end;


/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save fdup1;
run;
quit;


/***************************************************************************************/
/* Closing macro and going to next country in the list */
/***************************************************************************************/

      %let i = %eval(&i + 1);
%end;


/* Clear the work directory */
proc datasets library=work noprint kill;
run;
quit;

%mend fdups;


/****************************************************************************************/
/****************************************************************************************/
/*			End of macro # 1 (Major macro)                                                             */
/****************************************************************************************/
/****************************************************************************************/
/****************************************************************************************/

/****************************************************************************************/
/*			Mini macro to use in next macro (FdupsQ4x)                                  */
/****************************************************************************************/
%macro Qcalc (Qx, data_in, data_out);

data &data_out;
set &data_in;
/*For TA*/
FY2018_&Qx._TA_max = sum(
FY2018_&Qx._TA_Unadjusted,
FY2018_&Qx._TA_Fdup_P,
FY2018_&Qx._TA_Fdup_L);

FY2018_&Qx._TA_min = sum(
FY2018_&Qx._TA_Unadjusted,
FY2018_&Qx._TA_Fdup_P,
FY2018_&Qx._TA_Fdup_H);

/*For DSD */
FY2018_&Qx._DSD_max = sum(
FY2018_&Qx._DSD_Unadjusted,
FY2018_&Qx._DSD_Fdup_P,
FY2018_&Qx._DSD_Fdup_L);

FY2018_&Qx._DSD_min = sum(
FY2018_&Qx._DSD_Unadjusted,
FY2018_&Qx._DSD_Fdup_P,
FY2018_&Qx._DSD_Fdup_H);

/*For Other*/
FY2018_&Qx._Oth_max = sum(
FY2018_&Qx._Oth_Unadjusted,
FY2018_&Qx._Oth_Fdup_P,
FY2018_&Qx._Oth_Fdup_L);

FY2018_&Qx._Oth_min = sum(
FY2018_&Qx._Oth_Unadjusted,
FY2018_&Qx._Oth_Fdup_P,
FY2018_&Qx._Oth_Fdup_H);

/* For overall values, including DSD, TA, Other*/
FY2018_&Qx._max = sum(
FY2018_&Qx._TA_max,
FY2018_&Qx._DSD_max,
FY2018_&Qx._Oth_max,
FY2018_&Qx._TA_XFdup_P,
FY2018_&Qx._TA_XFdup_L
);

FY2018_&Qx._min = sum(
FY2018_&Qx._TA_min,
FY2018_&Qx._DSD_min,
FY2018_&Qx._Oth_min,
FY2018_&Qx._TA_XFdup_P,
FY2018_&Qx._TA_XFdup_H
);

FY2018_&Qx._Unadjusted = sum(
FY2018_&Qx._TA_Unadjusted,
FY2018_&Qx._DSD_Unadjusted,
FY2018_&Qx._Oth_Unadjusted
);

RUN;

%mend Qcalc;



/****************************************************************************************/
/****************************************************************************************/
/*			Final macro: fdupsCOPx to output FY17APR data                                */
/****************************************************************************************/
/****************************************************************************************/


%macro fdupsCOPx (clistx);

%local i nxtx;
%let i=1;
%do %while (%scan(&clistx, &i) ne );

/*choosing country from the list*/
   %let nxtx = %scan(&clistx, &i);

%fdups(
&nxtx., 
FY2018_TARGETS);

/****************************************************************************************/
/****************************************************************************************/


/*Appending each quarters data to get final dataset */
data &nxtx._f;
set 
ou.&nxtx._fy2018_targets_f;
run;


/*Changing names for the value_types for easier transposition */
data &nxtx._f1;
length value_typeX $100.;
set &nxtx._f;
if value_type = "Point Estimate"            then value_typeX = "Fdup_P";
else if value_type = "XFdup Point Estimate" then value_typeX = "XFdup_P";
else if value_type = "High_Range"           then value_typeX = "Fdup_H";
else if value_type = "Low_Range"            then value_typeX = "Fdup_L";
else if value_type = "XFdup Low_Range"      then value_typeX = "XFdup_H";
else if value_type = "XFdup High_Range"     then value_typeX = "XFdup_L";
else if value_type = "No_Low"     		    then value_typeX =  "No_Low";
else if value_type = ""     		   		then value_typeX = "Unadjusted";
else value_typeX = value_type;

if IndicatorType in ("DSD","TA") then IndicatorTypex = IndicatorType;
else IndicatorTypex = "Oth";
 
RUN;


/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save &nxtx._f1;
run;
quit;

/* Creating variable for final transposition */
data &nxtx._f2;
length tvar $200.;
set &nxtx._f1;
tvar = 
strip(periodx) || "_" ||
strip(IndicatorTypeX) || "_" ||
strip(value_typeX);
RUN;	


data &nxtx._f3;
set &nxtx._f2;
keep 
FundingAgency 
CountryName
indicator 
disaggregate 
categoryOptionComboUID 
categoryOptionComboName 
numeratorDenom  
tvar
value;
RUN;


/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save &nxtx._f3;
run;
quit;

/*Variables for transposing to get APR totals */
%let tvarlist = 
FundingAgency 
CountryName
indicator 
disaggregate 
categoryOptionComboUID 
categoryOptionComboName 
numeratorDenom ; 


/*Transposing the data */
/*Sorting data for transposing*/
proc sort data=&nxtx._f3;
by 
&tvarlist;
RUN;


/*Transposing data by data points required for estimation in wide format */
PROC TRANSPOSE DATA=&nxtx._f3
OUT=&nxtx._w; 
BY 
&tvarlist;
VAR value;
ID tvar;
RUN;


/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save &nxtx._w;
run;
quit;

/*Making sure all variables are accounted for */
data &nxtx._w1;
set &nxtx._w;
array keepvar (*)
FY2018_TARGETS_DSD_Fdup_P
FY2018_TARGETS_TA_Fdup_P
FY2018_TARGETS_Oth_Fdup_P
FY2018_TARGETS_TA_XFdup_P
FY2018_TARGETS_DSD_Fdup_H
FY2018_TARGETS_TA_Fdup_H
FY2018_TARGETS_Oth_Fdup_H
FY2018_TARGETS_DSD_Fdup_L
FY2018_TARGETS_TA_Fdup_L
FY2018_TARGETS_Oth_Fdup_L
FY2018_TARGETS_TA_XFdup_H
FY2018_TARGETS_TA_XFdup_L
FY2018_TARGETS_DSD_No_Low
FY2018_TARGETS_TA_No_Low
FY2018_TARGETS_Oth_No_Low
FY2018_TARGETS_DSD_Unadjusted
FY2018_TARGETS_TA_Unadjusted
FY2018_TARGETS_Oth_Unadjusted;
RUN;

/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save &nxtx._w1;
run;
quit;

/****************************************************************************************/
/* Calculating Quarterly totals for DSD, TA, Other, by Unadjusted and adjusted max and min */
/****************************************************************************************/

%Qcalc (TARGETS, &nxtx._w1, &nxtx._w2);



/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save &nxtx._w2;
run;
quit;


/*  Keeping only required columns */
data &nxtx._wx;

retain 
FundingAgency
CountryName
indicator
disaggregate
categoryOptionComboUID
categoryOptionComboName
numeratorDenom

FY2018_TARGETS_Unadjusted
FY2018_TARGETS_min
FY2018_TARGETS_max
FY2018_TARGETS_DSD_Unadjusted
FY2018_TARGETS_DSD_min
FY2018_TARGETS_DSD_max
FY2018_TARGETS_TA_Unadjusted
FY2018_TARGETS_TA_min
FY2018_TARGETS_TA_max
FY2018_TARGETS_Oth_Unadjusted
FY2018_TARGETS_Oth_min
FY2018_TARGETS_Oth_max;

SET &nxtx._w2;

Keep
FundingAgency
CountryName
indicator
disaggregate
categoryOptionComboUID
categoryOptionComboName
numeratorDenom

FY2018_TARGETS_Unadjusted
FY2018_TARGETS_min
FY2018_TARGETS_max
FY2018_TARGETS_DSD_Unadjusted
FY2018_TARGETS_DSD_min
FY2018_TARGETS_DSD_max
FY2018_TARGETS_TA_Unadjusted
FY2018_TARGETS_TA_min
FY2018_TARGETS_TA_max
FY2018_TARGETS_Oth_Unadjusted
FY2018_TARGETS_Oth_min
FY2018_TARGETS_Oth_max;

RUN;


/* Creating Fdups type variable   */
data &nxtx._wx1;
length Fdups $50.;
set &nxtx._wx;
if FY2018_TARGETS_Unadjusted = FY2018_TARGETS_min = FY2018_TARGETS_max then Fdups = "None";
else if FY2018_TARGETS_min = FY2018_TARGETS_max then Fdups = "Point";
else if  FY2018_TARGETS_min ne FY2018_TARGETS_max then Fdups = "Range";
run;

/*Clearing previous datasets in the work directory */
proc datasets library=work nolist;
save &nxtx._wx1;
run;
quit;


/* Creating final dataset   */
data ou.&nxtx._COP(rename=
	(FY2018_TARGETS_Unadjusted=Unadjusted
	FY2018_TARGETS_min = Min
	FY2018_TARGETS_max = Max
	FY2018_TARGETS_DSD_Unadjusted = DSD_Unadjusted
	FY2018_TARGETS_DSD_min = DSD_min
	FY2018_TARGETS_DSD_max = DSD_max
	FY2018_TARGETS_TA_Unadjusted = TA_Unadjusted
	FY2018_TARGETS_TA_min = TA_min
	FY2018_TARGETS_TA_max = TA_max
	FY2018_TARGETS_Oth_Unadjusted = Oth_Unadjusted
	FY2018_TARGETS_Oth_min = Oth_min
	FY2018_TARGETS_Oth_max = Oth_max));
	
retain 
FundingAgency
CountryName
indicator
disaggregate
categoryOptionComboUID
categoryOptionComboName
numeratorDenom
FY2018_TARGETS_Unadjusted
FY2018_TARGETS_min
FY2018_TARGETS_max
Fdups
FY2018_TARGETS_DSD_Unadjusted
FY2018_TARGETS_DSD_min
FY2018_TARGETS_DSD_max
FY2018_TARGETS_TA_Unadjusted
FY2018_TARGETS_TA_min
FY2018_TARGETS_TA_max
FY2018_TARGETS_Oth_Unadjusted
FY2018_TARGETS_Oth_min
FY2018_TARGETS_Oth_max;

set &nxtx._wx1;

keep 
FundingAgency
CountryName
indicator
disaggregate
categoryOptionComboUID
categoryOptionComboName
numeratorDenom
FY2018_TARGETS_Unadjusted
FY2018_TARGETS_min
FY2018_TARGETS_max
Fdups
FY2018_TARGETS_DSD_Unadjusted
FY2018_TARGETS_DSD_min
FY2018_TARGETS_DSD_max
FY2018_TARGETS_TA_Unadjusted
FY2018_TARGETS_TA_min
FY2018_TARGETS_TA_max
FY2018_TARGETS_Oth_Unadjusted
FY2018_TARGETS_Oth_min
FY2018_TARGETS_Oth_max;
RUN;

      %let i = %eval(&i + 1);
%end;


/* Clear the work directory */
proc datasets library=work noprint kill;
run;
quit;

%mend fdupsCOPx;


/****************************************************************************************/
/****************************************************************************************/
/*			End of macros                                                              */
/****************************************************************************************/
/****************************************************************************************/
/****************************************************************************************/


/****************************************************************************************/
/****************************************************************************************/
/*			Running final macro and creating output dataset                             */
/****************************************************************************************/
/****************************************************************************************/
/****************************************************************************************/


%fdupsCOPx (
AsiaReg);



*stacking up the datasets;
data ou.finalAPR2018;
length FiscalYear 4. ReportingCycle $10. DataType $10. DateCreated $10.;

set 
ou.AsiaReg_APR;

FiscalYear = 2018;
ReportingCycle = 'APR';
DataType = 'Results';
DateCreated = "&todaydate.";
RUN;


/*********Exporting the output dataset**********************************************/
/*For Exporting into excel
proc export data = ou.finalCOP2018
dbms = xlsx  replace
outfile =  
"C:\Users\nde7\Desktop\SAS\DFPM\deduplibrary\TEST\&todaydate._Fdup_COPFY18.xlsx";
SHEET = "Fdups";
run;*/

/*For exporting to tab delim txt file*/
proc export data= ou.finalAPR2018
outfile="C:\Users\nde7\Desktop\SAS\DFPM\deduplibrary\TEST\&todaydate._Fdup_APRFY18.txt" dbms=tab replace;
putnames=yes;
run;

/**/
/*/*The validation tool dataset */*/
/*data tl.Ethiopia_f_17apr;*/
/*set */
/*tl.Ethiopia_fy2017q1_f*/
/*tl.Ethiopia_fy2017q2_f*/
/*tl.Ethiopia_fy2017q3_f*/
/*tl.Ethiopia_fy2017q4_f;*/
/*run;*/
/**/
/**/
/**/
/**/
/*/*Exporting the validation tool dataset*/*/
/*proc export data = tl.Ethiopia_f_17apr*/
/*dbms = xlsx  replace*/
/*outfile =  */
/*"C:\Mujawar\lrz5\AAA_Recent\Fdups\ExcelOutput\&todaydate._Fdup_tool_Ethiopia_APR(GenieExt).xlsx";*/
/*SHEET = "Fdups_tool";*/
/*run;*/
/**/
/**/
/**/
*/
