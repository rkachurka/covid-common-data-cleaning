// ideas:
// robustness check: to compare distrubution of answers for Ariadna data
// robustness check: to drop out 5% of the fastest subjects
// to remove participant with inconsistent justification of vax decision
// to remove all other categories if there is a category "just_yes" OR just_no

clear all

//INTSALATION:
//ssc install scheme-burd, replace
capture set scheme burd
//capture ssc install tabstatmat

//working folder
//pls use the full path to the folder with wave1/2 data, not to the root folder \studies\, it creates a mess (output files (pics, tables and etc) are created in the root folder)
capture cd "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)"
capture cd "G:\Dyski współdzielone\Koronawirus\studies\5 common data cleaning (wave1)"
capture cd "/Volumes/GoogleDrive/Shared drives/Koronawirus/studies/5 common data cleaning (wave1)"

/*
//creation of stata data files for later merge
import spss using "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\archive\Zbior_WNE1_N3000_nowa_waga.sav", clear
save "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\nowa_waga.dta", replace

import spss using "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\archive\Zbior_WNE1_N3000_data_1.sav", clear
save "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\datetime.dta", replace

//merge with main data
import spss using "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\archive\data.sav", clear
rename Id ID
merge 1:1 ID using "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\nowa_waga.dta"
capture drop _merge
merge 1:1 ID using "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\datetime.dta"
capture drop _merge
rename (waga waga2) (waga_old waga)
save "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\data_stata_format.dta", replace
*/


/// CREATION OF POPULATION AND CASES DATA
/*
clear all
import excel "G:\Shared drives\Koronawirus\studies\covid cases data.xlsx", sheet("data format wave1") cellrange(A1:B3118) firstrow clear
save "G:\Shared drives\Koronawirus\studies\data format wave1.dta", replace

clear all
import excel "covid cases data.xlsx", sheet("population per region") cellrange(A8:E23)
rename A region_id
rename B region
rename E population
keep region_id region population
save "population per region.dta", replace

clear all
import excel "covid cases data.xlsx", sheet("covid cases per region") cellrange(A2:J770) firstrow clear
recast double data
save "covid cases per region.dta", replace

clear all
import excel "covid cases data.xlsx", sheet("covid cases total") cellrange(A2:M51) firstrow clear
recast double data
save "covid cases total.dta", replace
*/


/*
//merge with covid cases per region, total, population per region
use "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\data_stata_format.dta", clear

rename woj region_id
rename data date_from_Ariadna

//creation of file for data merge, one time usage because date format is different - we need a unique ID for each date in text format
//export excel ID data using "C:\Users\johns_000\Desktop\data format (wave1).xlsx", firstrow(variables) replace

capture drop _merge
merge 1:1 ID using "G:\Shared drives\Koronawirus\studies\data format wave1.dta"
capture drop _merge
merge m:1 region_id using "G:\Shared drives\Koronawirus\studies\population per region.dta"
capture drop _merge
merge m:m data region_id using "G:\Shared drives\Koronawirus\studies\covid cases per region.dta"
keep if _merge==3
capture drop _merge
merge m:1 data using "G:\Shared drives\Koronawirus\studies\covid cases total.dta"
keep if _merge==3
capture drop _merge
save "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\data_wave1.dta", replace
*/



 
///CREATION OF WHY AND WHO
/*
/// WHY
import excel "3 szczepionka\classification of open ended questions\final_classification.xlsx", sheet("why") cellrange(A1:J6224) firstrow clear
//import excel "3 szczepionka/classification of open ended questions/final_classification.xlsx", sheet("why") cellrange(A1:J6224) firstrow clear
rename FINALWHY final_why
save "3 szczepionka\classification of open ended questions\data_why.dta", replace
//save "3 szczepionka/classification of open ended questions/data_why.dta", replace

/// WHO
import excel "3 szczepionka\classification of open ended questions\final_classification.xlsx", sheet("new who 20210412") cellrange(A1:K6224) firstrow clear
save "3 szczepionka\classification of open ended questions\data_who.dta", replace
//import excel "3 szczepionka/classification of open ended questions/final_classification.xlsx", sheet("new who 20210412") cellrange(A1:K6224) firstrow clear
//save "3 szczepionka/classification of open ended questions/data_who.dta", replace

/// merge with why and who
use "3 szczepionka\20210310 data analysis (Arianda wave2)\WNE2_N3000_covid_stats.dta", clear
//use "3 szczepionka/20210310 data analysis (Arianda wave2)/WNE2_N3000_covid_stats.dta", clear

/// merge with why
capture drop _merge
merge 1:1 ID using "3 szczepionka\classification of open ended questions\data_why.dta"
//merge 1:1 ID using "3 szczepionka/classification of open ended questions/data_why.dta"
rename wave wave_why
keep if _merge==3

/// merge with who
capture drop _merge
capture merge 1:1 ID using "3 szczepionka\classification of open ended questions\data_who.dta"
//capture merge 1:1 ID using "3 szczepionka/classification of open ended questions/data_who.dta"
keep if _merge==3
 drop _merge
 
save "3 szczepionka\20210310 data analysis (Arianda wave2)\WNE2_N3000_covid_stats_who_why.dta", replace
//save "3 szczepionka/20210310 data analysis (Arianda wave2)/WNE2_N3000_covid_stats_who_why.dta", replace
*/

/// "REFERRED TO" CREATION
/*
import excel "3 szczepionka\classification of open ended questions\final_classification.xlsx", sheet("(old 20210416) referred to") firstrow clear
//import excel "3 szczepionka/classification of open ended questions/final_classification.xlsx", sheet("(old 20210416) referred to") firstrow clear
destring ID, replace
save "3 szczepionka\classification of open ended questions\referred_to.dta", replace
//save "3 szczepionka/classification of open ended questions\referred_to.dta", replace

/// "referred to" merge
use "3 szczepionka/20210310 data analysis (Arianda wave2)\WNE2_N3000_covid_stats_who_why.dta", clear
//use "3 szczepionka/20210310 data analysis (Arianda wave2)/WNE2_N3000_covid_stats_who_why.dta", clear
capture drop _merge
merge 1:1 ID using "3 szczepionka\classification of open ended questions\referred_to.dta"
//merge 1:1 ID using "3 szczepionka/classification of open ended questions/referred_to.dta"
keep if _merge==3
drop _merge

save "3 szczepionka\20210310 data analysis (Arianda wave2)\WNE2_N3000_covid_stats_who_why_refto.dta", replace
//save "3 szczepionka/20210310 data analysis (Arianda wave2)/WNE2_N3000_covid_stats_who_why_refto.dta", replace
*/


/////////OLD CODE
/*
clear all

import spss using "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\archive\Zbior_WNE1_N3000_nowa_waga.sav", clear
save "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\nowa_waga.dta", replace

import spss using "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\archive\Zbior_WNE1_N3000_data_1.sav", clear
saveold "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\datetime.dta", version(13)

capture cd "G:\Shared drives\Koronawirus\studies\5 data analysis (wave1)"
capture cd "G:\Dyski współdzielone\Koronawirus\studies\5 data analysis (wave1)"
capture cd "/Volumes/GoogleDrive/Shared drives/Koronawirus/studies/5 common data cleaning (wave1)"
import spss using "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\archive\data.sav", clear
rename Id ID
merge 1:1 ID using "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\nowa_waga.dta"
capture drop _merge
merge 1:1 ID using "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\datetime.dta"
capture drop _merge
rename (waga waga2) (waga_old waga)
saveold "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\data_stata_format.dta", version(13)


capture cd "G:\Shared drives\Koronawirus\studies\5 data analysis (wave1)"
capture cd "G:\Dyski współdzielone\Koronawirus\studies\5 data analysis (wave1)"
capture cd "/Volumes/GoogleDrive/Shared drives/Koronawirus/studies/5 common data cleaning (wave1)"
use data_stata_format.dta, clear


// define variable that slows percentile, by time 
sort time
gen time_perc = _n/_N
//use it later during the robustness check, when results will be ready (add/remove 5% fastest participants)

//VACCINE PART DATA CLEANING
rename (p37_1_r1	p37_1_r2	p37_1_r3	p37_1_r4	p37_1_r5	p37_1_r6	p37_1_r7	p37_8_r1	p37_8_r2	p37_8_r3	p37_8_r4	p37) (v_producer_reputation	v_efficiency	v_safety	v_scarcity	v_other_want_it	v_scientific_authority	v_ease_personal_restrictions	v_p_pay0	v_p_gets70	v_p_pays10	v_p_pays70	v_decision) 
global vaccine_vars "v_producer_reputation	v_efficiency	v_safety		v_other_want_it	v_scientific_authority	v_ease_personal_restrictions	v_p_gets70	v_p_pays10	v_p_pays70" // i leave out scarcity -- sth that supposedly everybody knows. we can't estimate all because of ariadna's error anyway
global vaccine_short "v_producer_reputation	v_efficiency	v_safety	v_scarcity	v_other_want_it	v_scientific_authority	v_ease_personal_restrictions"
global prices "v_p_gets70	v_p_pays10	v_p_pays70"


global uwagi "p1_uwagi p2_uwagi p5_uwagi p6_uwagi p9_uwagi p10_uwagi p13_uwagi p14_uwagi"

foreach uw in $uwagi {
list `uw' if `uw'!=""
}

//DEMOGRAPHICS DATA CLEANING
//wojewodstwo is ommited, because of no theoretical reason to include it
gen male=sex==2
rename (age year) (age_category age)
replace age=2021-age
gen age2=age^2

//later check consistency of answers

rename (miasta wyksztalcenie) (city_population edu)
gen elementary_edu=edu==1|edu==2
gen secondary_edu=edu==3|edu==4
gen higher_edu=edu==5|edu==6|edu==7

rename m8 income
gen wealth_low=income==1|income==2
gen wealth_high=income==4|income==5
global wealth "wealth_low wealth_high"

//HEALTH
rename m9 health_state

gen health_poor=health_state==1|health_state==2
gen health_good=health_state==4|health_state==5

gen had_covid=(5-p31)

gen covid_friends=p33==1
//to create 3 variables know+hospitalizaed, know+not hospitalized
gen no_covid_friends=covid_friends==0
gen covid_friends_hospital=p34==1
gen covid_friends_nohospital=covid_friends==1&covid_friends_hospital==0

//RELIGION
gen religious=m10==2|m10==3

rename m11 religious_freq
gen religious_often=religious_freq==4|religious_freq==5|religious_freq==6 //often = more than once a month

//Employment
gen status_unemployed=m12==5
gen status_pension=m12==6
gen status_student=m12==7

//COVID attitudes
rename p26 mask_wearing
rename p30_r1 distancing

//treatments
rename warunek treatment //1.COVID 2.Cold, 3.Unemployment
label define treats 1 "COVID" 2 "Cold" 3 "Unemployment"
label values treatment treats
gen t_covid=treatment==1
gen t_cold=treatment==2
gen t_unempl=treatment==3
global treatments "t_cold t_unempl"


//EMOTIONS
ren (p17_r1 p17_r2 p17_r3 p17_r4 p17_r5 p17_r6) (e_happiness e_fear e_anger e_disgust e_sadness e_surprise)
global emotions "e_happiness e_fear e_anger e_disgust e_sadness e_surprise"

//RISK ATTITUDES
ren (p18_r1 p19_r1 p19_r2) (risk_overall risk_work risk_health)
global risk "risk_overall risk_work risk_health"

//WORRY
ren (p20_r1 p20_r2 p20_r3) (worry_covid worry_cold worry_unempl)
global worry "worry_covid worry_cold worry_unempl"

//SUBJECTIVE CONTROL
rename (p22_r1 p22_r2 p22_r3) (control_covid control_cold control_unempl)
global control "control_covid control_cold control_unempl"

//INFORMED ABOUT:
rename (p23_r1 p23_r2 p23_r3) (informed_covid informed_cold informed_unempl)
global informed "informed_covid informed_cold informed_unempl"

//CONSPIRACY
rename (p30cd_r1 p30cd_r2 p30cd_r3) (conspiracy_general_info conspiracy_stats conspiracy_excuse)
global conspiracy "conspiracy_general_info conspiracy_stats conspiracy_excuse"
egen conspiracy_score=rowmean($conspiracy)
//lets do general conspiracy score?

//VOTING
rename m20 voting

replace voting=0 if voting==.a
replace voting=8 if voting==5|voting==6

global voting "i.voting"

//covid impact estimations
rename (p24 p25) (subj_est_cases subj_est_death)
replace subj_est_cases=. if subj_est_death>subj_est_cases*100
gen subj_est_cases_ln=ln(subj_est_cases+1)
replace subj_est_cases_ln=0 if subj_est_cases_ln==.
gen subj_est_death_l=ln(subj_est_death+1)
replace subj_est_death_l=0 if subj_est_death_l==.

global covid_impact "subj_est_cases_ln subj_est_death_l"


//////////////////*************GLOBALS***************////////////
global demogr "male age i.city_population secondary_edu higher_edu $wealth health_poor health_good had_covid  covid_friends religious i.religious_freq status_unemployed status_pension status_student"
global demogr_int "male age higher_edu"
global health_advice "mask_wearing distancing"

