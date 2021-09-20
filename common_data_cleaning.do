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

///CREATION AND MERGE OF DATA AND WEIGHT
/*
//temporary working folder
//pls use the full path to the folder with wave1/2 data, not to the root folder \studies\, it creates a mess (output files (pics, tables and etc) are created in the root folder)
capture cd "G:\Shared drives\Koronawirus\studies\"

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


///CREATION AND MERGE OF POPULATION AND CASES DATA
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




///CREATION AND MERGE OF WHY AND WHO
/*
/// WHY
import excel "G:\Shared drives\Koronawirus\studies\3 szczepionka\classification of open ended questions\final_classification.xlsx", sheet("why") cellrange(A1:J6224) firstrow clear
rename FINALWHY final_why
save "G:\Shared drives\Koronawirus\studies\3 szczepionka\classification of open ended questions\data_why.dta", replace

/// WHO
import excel "G:\Shared drives\Koronawirus\studies\3 szczepionka\classification of open ended questions\final_classification.xlsx", sheet("new who 20210412") cellrange(A1:K6224) firstrow clear
save "G:\Shared drives\Koronawirus\studies\3 szczepionka\classification of open ended questions\data_who.dta", replace
//import excel "3 szczepionka/classification of open ended questions/final_classification.xlsx", sheet("new who 20210412") cellrange(A1:K6224) firstrow clear
//save "3 szczepionka/classification of open ended questions/data_who.dta", replace

/// merge with why and who
use "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\data_wave1.dta", clear
//use "3 szczepionka/20210310 data analysis (Arianda wave2)/WNE2_N3000_covid_stats.dta", clear

/// merge with why
capture drop _merge
merge 1:1 ID using "G:\Shared drives\Koronawirus\studies\3 szczepionka\classification of open ended questions\data_why.dta"
//merge 1:1 ID using "3 szczepionka/classification of open ended questions/data_why.dta"
rename wave wave_why
keep if _merge==3

/// merge with who
capture drop _merge
merge 1:1 ID using "G:\Shared drives\Koronawirus\studies\3 szczepionka\classification of open ended questions\data_who.dta"
//capture merge 1:1 ID using "3 szczepionka/classification of open ended questions/data_who.dta"
keep if _merge==3
capture drop _merge

save "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)\wave1_final.dta", replace
*/

/*

///CREATION AND MERGE OF "REFERRED TO"
import excel "3 szczepionka\classification of open ended questions\final_classification.xlsx", sheet("referred to") firstrow clear
//import excel "3 szczepionka/classification of open ended questions/final_classification.xlsx", sheet("(old 20210416) referred to") firstrow clear
destring ID, replace
save "3 szczepionka\classification of open ended questions\referred_to.dta", replace
//save "3 szczepionka/classification of open ended questions\referred_to.dta", replace

/// "referred to" merge
use "5 common data cleaning (wave1)\wave1_final.dta", clear
//use "3 szczepionka/20210310 data analysis (Arianda wave2)/WNE2_N3000_covid_stats_who_why.dta", clear
capture drop _merge
merge 1:1 ID using "3 szczepionka\classification of open ended questions\referred_to.dta"
//merge 1:1 ID using "3 szczepionka/classification of open ended questions/referred_to.dta"
keep if _merge==3
drop _merge

save "5 common data cleaning (wave1)\wave1_final_refto.dta", replace
*/


//working folder
//pls use the full path to the folder with wave1/2 data, not to the root folder "studies", it creates a mess (output files (pics, tables and etc) are created in the root folder)
clear all
capture cd "G:\Shared drives\Koronawirus\studies\5 common data cleaning (wave1)"
capture cd "G:\Dyski współdzielone\Koronawirus\studies\5 common data cleaning (wave1)"
capture cd "/Volumes/GoogleDrive/Shared drives/Koronawirus/studies/5 common data cleaning (wave1)"
capture cd "G:\Shared drives\Koronawirus\studies\5 common data cleaning (puzzles Study 3 and Vaccines wave 1)"

use "wave1_final_refto.dta"

/// GENERATING VOIEVODSHIP-SPEC VARS
gen infected_y_pc=infected_y/population*1000
gen deceased_y_pc=deceased_y/population*1000

/// WHO WHY VARS GENERATION
desc final_why
replace final_why=auto_why if final_why==""

rename final_who FINALWHO
gen final_who=FINALWHO
replace final_who=auto_who if final_who==""

replace final_why =subinword(final_why,"other","OTHER",.)
replace final_why =subinword(final_why,"money_other","MONEY_OTHER",.)
replace final_why =subinword(final_why,"money_pays_ok","MONEY_PAYS_OK",.)
replace final_why =subinword(final_why,"money_other","MONEY_OTHER",.)
replace final_why =subinword(final_why,"money_pays_ok","MONEY_PAYS_OK",.)


global why_vars "safety_concerns efficacy_concerns poorly_tested not_afraid_virus just_no vaccine_too_costly conspiracy contraindications antibodies time_consuming doubts_no mistrust_no antivax safety_general others_safety normality just_yes belief_science no_alternatives morbidity_factors convenience doubts_yes mistrust_yes work money  already_vac obligation INCONSISTENT OTHER nonsens"

global who_vars "who_dont_know who_nothing who_family who_doctor who_else who_more_info who_forced who_nonsens who_convenience who_choice who_money who_other who_own_health who_more_evidence_efficacy who_more_evidence_safety who_time who_already_vac who_more_evidence_inefficacy who_side_effects who_unavailability who_end_pandemics INCONSISTENT"



foreach i in $why_vars{
gen why_`i' = strpos(final_why,"`i'")
replace why_`i'=1 if why_`i'>0
}

sum why_*
 

foreach i in $who_vars{
gen `i' = strpos(final_who,"`i'")
replace `i'=1 if `i'>0
}

rename INCONSISTENT who_INCONSISTENT
sum who_*



/// "REFERRED TO" VARS GENERATION

rename (who_referred_to why_referred_to) (referred_to_who referred_to_why)
global referred_to "referred_to_the_price referred_to_the_efficacy"
gen whowhy_referred_to=referred_to_who+referred_to_why

foreach i in $referred_to{
gen ref_to_`i' = strpos(whowhy_referred_to,"`i'") //code look for text in the field "whowhy_referred_to", meaning combination of search in why and who fields
replace ref_to_`i'=1 if ref_to_`i'>0
}

sum ref_to_*


/// COMMENTS REVIEW, COUNT, %
gen n_count=_N
rename p29 comment_29
global comments "comment_29"
foreach comment in $comments {
list `comment' if `comment'!=""
egen `comment'_count = count(`comment')
gen `comment'_count_percent = `comment'_count/n_count
display "number of comments: "  `comment'_count
display "% of records with comments: " `comment'_count_percent
}


/// VACCINE PART DATA CLEANING
rename (p37_1_r1	p37_1_r2	p37_1_r3	p37_1_r4	p37_1_r5	p37_1_r6	p37_1_r7 	p37_8_r1	p37_8_r2	p37_8_r3	p37_8_r4	p37) (v_prod_reputation	v_efficiency	v_safety	v_scarcity	v_other_want_it	v_scientific_authority	v_vax_passport v_p_pay0	v_p_gets70	v_p_pays10	v_p_pays70	v_decision) 
global vaccine_vars "v_prod_reputation	v_efficiency	v_safety	v_other_want_it	v_scientific_authority	v_vax_passport v_p_gets70	v_p_pays10	v_p_pays70" // i leave out scarcity -- sth that supposedly everybody knows. we can't estimate all because of ariadna's error anyway
global vaccine_short "v_prod_reputation	v_efficiency	v_safety    v_other_want_it	v_scientific_authority	v_vax_passport"
global prices "v_p_gets70	v_p_pays10	v_p_pays70" // v_p_pay0 is a base level

label define v_dec_eng 1 "definitely not" 2 "rather not" 3 "rather yes" 4 "definitely yes"
label values v_decision v_dec_eng

sort v_decision
// browse p38 v_dec ID if why_INCO


/// DROPPING (STRONG) INCONSISTENCIES
/*my thinking was this:
if someone says "zdecydowanie nie"(="definitely not") but says sth clearly positive about vaccines or vice versa, drop it
if someone says "raczej nie"("rather not") and says (p38) he will get a jab (so a stronger statement, not just anything positive), drop it. 
same for "raczej tak"(="rather yes") & explicit refusal in p38
*/
replace why_INCO=0 if v_decision==2|v_decision==3
replace why_INCO=1 if ID==6552  // p38=="Chce się zaszczepić bo jest to rozwiązanie przyszłości"
replace why_INCO=1 if ID==5758 // p38=="nie bede się szczepic eksperymentem medycznym,ktory ma testowc udzi przez 2 lata"
replace why_INCO=0 if ID==4452 // p38=="chcę  by to wszystk się już zakończyło"

// browse p39 v_dec ID if who_INCO

replace who_INCO=0 if v_dec==2| v_dec==3
replace who_INCO=1 if ID==4877 // p39=="Za tak. Szczepionka musiała by być długo testowana bo nie chcę brać udziału w eksperymentach medycznych" | p39=="nie zmienię zdania bo nie bede królikiem doświadczalnym w ich ekserymencie medycznym" | p39=="Nie ma możliwości stworzyć szybko szczepionki, bo potrzebny jest długi czas testowania, a tu nie mamy czasu, a skutki uboczne mogą się ujawnić po kilku latach."

gen INCO=who_INCO+why_INCO
drop if INCO




gen vaxx_def_yes =v_dec==4
gen vaxx_rather_yes =v_dec==3
gen vaxx_rather_no =v_dec==2
gen vaxx_def_no =v_dec==1

gen vaxx_yes=vaxx_def_yes+vaxx_rather_yes


// sum vaxx_yes [weight=waga] if male==1 & age>60

// pwcorr $vaccine_vars, sig
egen sum_vaxx=rsum($vaccine_short)
sum $vaccine_vars
//hist sum_vaxx, disc
tab sum_vaxx // seems ok


capture drop no_manips
gen no_manips=v_p_gets70==0 & v_p_pays10==0 & v_p_pays70==0 & v_p_pay0==0
sum sum_vaxx if no_manips
tab v_dec no_manips, col chi

tab no_manips v_p_gets70 

tab no_manips v_p_pays70 

tab v_dec no_manips if v_p_gets70==0& v_p_pays70==0 & v_p_pays10==0, col chi

drop if no_manips


/// WHY AND WHO by decision
tabstat why_* [weight=waga], by(v_decision)
tabstat who_* [weight=waga], by(v_decision)
tab v_decision


///DEMOGRAPHICS DATA CLEANING
gen male=sex==2
rename (age) (age_category)
gen age=year



gen age2=age^2 
//later check consistency of answers

rename (miasta wyksztalcenie) (city_population edu)
tabstat vaxx_yes [weight=waga], statistics( mean ) by(edu)
gen elementary_edu=edu==1|edu==2
gen secondary_edu=edu==3|edu==4
gen higher_edu=edu==5|edu==6|edu==7

capture drop edu_short
gen edu_short=1*ele+2*sec+3*higher

tabstat vaxx_yes [weight=waga], statistics( mean ) by(city_population)
label define city_pop_eng 1 "village" 2 "small (<20k)" 3"medium (<99k)" 4 "big (<500k)" 5 "large city (>500k)"
label values city_population city_pop_eng

label define e_s 1 "podstawowe" 2 "średnie" 3 "wyższe", replace
label values edu_short e_s

label define sex_eng 1 "female" 2 "male"
label values sex sex_eng

label define e_s_eng 1 "primary" 2 "secondary" 3 "higher"
label values edu_short e_s_eng 

rename m8 income
tabstat vaxx_yes [weight=waga], statistics( mean ) by(income)
gen wealth_low=income==1|income==2 //3 is average, base level
gen wealth_high=income==4|income==5
global wealth "wealth_low wealth_high"

/// HEALTH
rename m9 health_state
tabstat vaxx_yes [weight=waga], statistics( mean ) by(health_state)
gen health_poor=health_state==1|health_state==2 //3 is average, base level
gen health_good=health_state==4|health_state==5


rename p31 had_covid
tabstat vaxx_yes [weight=waga], statistics( mean ) by(had_covid)
gen tested_pos_covid=had_covid==1
gen thinks_had_covid=had_covid==2

// rename p31 had_covid_initial

rename p32 covid_hospitalized
tab covid_hospitalized
replace covid_hospitalized=0 if covid_hospitalized==.
replace covid_hosp=0 if covid_hosp==.a

gen covid_friends=p33==1
rename p33 initial_covid_friends
tab initial_covid_friends
tab covid_friends
//to create 3 variables know+hospitalizaed, know+not hospitalized
gen no_covid_friends=covid_friends==0
tab no_covid_friends

rename p34 covid_friends_hospital_initial
tab covid_friends_hospital_initial
gen covid_friends_hospital=covid_friends_hospital_initial==1
tab covid_friends_hospital
gen covid_friends_nohospital=covid_friends==1&covid_friends_hospital==0
tab covid_friends_nohospital
/// RELIGION
rename m10 religious_initial
tab religious_initial
gen religious=religious_initial==2|religious_initial==3


rename m11 religious_freq
tab religious_freq
tab religious_freq, nolabel
gen religious_often=religious_freq==4|religious_freq==5|religious_freq==6 //often = more than once a month

label define reli_freq_eng 1 "never" 2 "less than once a year" 3 "few times a year" 4 "few times a month" 5 "few times a week" 6 "few times a day"
label values religious_freq reli_freq_eng

/// Employment
rename m12 empl_status
tab empl_status
tab empl_status, nolabel
gen status_unemployed=empl_status==5
gen status_pension=empl_status==6
gen status_student=empl_status==7


/// COVID attitudes
rename p26 mask_wearing
rename p30_r1 distancing

/// EMOTIONS
ren (p17_r1 p17_r2 p17_r3 p17_r4 p17_r5 p17_r6) (e_happiness e_fear e_anger e_disgust e_sadness e_surprise)
global emotions "e_happiness e_fear e_anger e_disgust e_sadness e_surprise"
foreach i in $emotions{
tab `i'
}
/// RISK ATTITUDES
ren (p18_r1 p19_r1 p19_r2) (risk_overall risk_work risk_health)
global risk "risk_overall risk_work risk_health"
foreach i in $risk{
tab `i'
}
/// WORRY
ren (p20_r1 p20_r2 p20_r3) (worry_covid worry_cold worry_unempl)
global worry "worry_covid worry_cold worry_unempl"
foreach i in worry_cov{
tab `i'
}
/// SUBJECTIVE CONTROL
rename (p22_r1 p22_r2 p22_r3) (control_covid control_cold control_unempl)
global control "control_covid control_cold control_unempl"
foreach i in control_cov{
tab `i'
}
/// INFORMED ABOUT:
rename (p23_r1 p23_r2 p23_r3) (informed_covid informed_cold informed_unempl)
global informed "informed_covid informed_cold informed_unempl"
foreach i in $informed{
tab `i'
}
/// CONSPIRACY
rename (p30cd_r1 p30cd_r2 p30cd_r3) (conspiracy_general_info conspiracy_stats conspiracy_excuse)
global conspiracy "conspiracy_general_info conspiracy_stats conspiracy_excuse"
foreach i in $conspiracy{
tab `i'
}
egen conspiracy_score=rowmean($conspiracy)

gen consp_stats_high=conspiracy_sta==6|conspiracy_st==7
sum consp_stats_high [weight=waga]

/// VOTING
rename m20 voting
tab voting
tab voting, nolabel
replace voting=0 if voting==.a
replace voting=0 if voting==.
replace voting=8 if voting==5|voting==6
global voting "i.voting"

gen voting_nl=voting
label define numbers 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9"
label values voting_nl numbers
tab voting_nl
tab voting voting_nl

gen voting_short=voting
replace voting_short=9 if voting==8 | voting==0
replace voting_short=2 if voting==3 

/*
// OLD, OBSOLETE:
// label define v_s_OLD 1 "Zjedn. Praw." 2 "KO, PL2050 SH" 4 "Lewica" 7 "Konfederacja" 9 "inna lub żadna", replace
label define v_s_eng_OLD 1 "PiS(ruling, right)" 2 "center" 4 "left" 7 "ultra-right" 9 "none or other", replace
label values voting_short v_s_eng_OLD
tab voting_short


*/

// NEW, TO HAVE LEFT ON THE LEFT ETC.
label define v_s_eng 3 "right (ruling party)" 2 "center" 1 "left" 4 "ultra-right" 5 "none or other", replace
recode voting_short (1=3) (2=2) (4=1) (7=4) (9=5)
label values voting_short v_s_eng
tab voting_short


/// COVID IMPACT ESTIMATIONS
rename (p24 p25) (subj_est_cases subj_est_death)
destring subj_est_cases subj_est_death, replace
replace subj_est_cases=. if subj_est_death>subj_est_cases*100 //kind of check is added here, some people did not get that deaths were in thouthands and cases in millions
gen subj_est_cases_ln=ln(subj_est_cases+1)
replace subj_est_cases_ln=0 if subj_est_cases_ln==.
gen subj_est_death_l=ln(subj_est_death+1)
replace subj_est_death_l=0 if subj_est_death_l==.

global covid_impact "subj_est_cases_ln subj_est_death_l"

//[P40] If the vaccine was confirmed to be effective and safe after the first few months of vaccinations, would you be willing to be vaccinated?
rename p40 decision_change
tab decision_change
//this variable will be included into analysis to see which factors (e.g. emotions) are assotiated with vaccination decision change
gen change_yes=decision_change==3|decision_change==4
replace change_yes=. if decision_change==.a

sum change_yes [weight=waga]
sum change_yes 

/*
//below is wave2 only
/// HEALTH STATUS DETAILS
rename m9_1 health_vaccine_side_effects
gen vaccine_extra_risky=health_vaccine_side_effects==1
rename m9_2 health_covid_serious
gen covid_extra_risky=health_covid_serious==1
//"smoking categories consisted of “very light” (1–4 CPD), “light” (5–9 CPD), “moderate” (10–19 CPD), and “heavy” (20+ CPD) Rostron, Brian L., et al. "Changes in Cigarettes per Day and Biomarkers of Exposure Among US Adult Smokers in the Population Assessment of Tobacco and Health Study Waves 1 and 2 (2013–2015)." Nicotine and Tobacco Research 22.10 (2020): 1780-1787."
rename m9_3 health_smoking_yesno
rename m9_3a health_smoking_howmany
rename m9_3b health_smoking_atleast_once
//no smoking is a base level, ommited
gen health_smoking_vlight=health_smoking_howmany>0&health_smoking_howmany<5
gen health_smoking_light=health_smoking_howmany>4&health_smoking_howmany<10
gen health_smoking_moderate=health_smoking_howmany>9&health_smoking_howmany<20
gen health_smoking_heavy=health_smoking_howmany>19
global health_details "vaccine_extra_risky covid_extra_risky health_smoking_light health_smoking_moderate health_smoking_heavy"
foreach i in $health_details{
tab `i'
}


/// TRUST
rename (trust_r1	trust_r2	trust_r3	trust_r4	trust_r5	trust_r6	trust_r7) (trust_EU	trust_gov	trust_neigh	trust_doctors	trust_media	trust_family	trust_science)
global trust "trust_EU	trust_gov	trust_neigh	trust_doctors	trust_media	trust_family	trust_science" //included into demogr

foreach i in $trust{
tab `i'
}

capture drop trust_*_Y trust_*_N

global trust_dummies ""
foreach var in $trust{
gen `var'_Y=`var'==1
gen `var'_N=`var'==3
global trust_dummies "$trust_dummies `var'_Y `var'_N"
}

global trust_short_dummies "trust_EU_N trust_gov_N trust_media_N trust_science_Y trust_science_N trust_doctors_Y trust_doctors_N"

sum $trust_dummies
*/

/// ORDER EFFECTS
/*
// robustness check: to add order effects for emotions
//[P17] How strongly are you experiencing the following emotion at the moment?
rename p17_order order_emotions
replace order_emotions=subinstr(order_emotions,"r","",.)
split order_emotions, p(",")
global g_order_emotions "order_emotions1 order_emotions2 order_emotions3 order_emotions4 order_emotions5 order_emotions6"

destring $g_order_emotions, replace
// robustness check: to add order effects for trust questions
//[trust_gov, trust_neighbours, trust_doctors, trust_media, trust_family, trust_scientists] Czy ma Pan zaufanie do?: 
rename trust_order order_trust
replace order_trust=subinstr(order_trust,"r","",.)
split order_trust, p(",")
global g_order_trust "order_trust1 order_trust2 order_trust3 order_trust4 order_trust5 order_trust6 order_trust7"
destring $g_order_trust, replace
// robustness check: to add order effects for risk questions
rename p19_order order_risk
replace order_risk=subinstr(order_risk,"r","",.)
split order_risk, p(",")
global g_order_risk "order_risk1 order_risk2"
destring $g_order_risk, replace
// robustness check: to add order effects for worry questions
rename p20_order order_worry
replace order_worry=subinstr(order_worry,"r","",.)
split order_worry, p(",")
global g_order_worry "order_worry1 order_worry2 order_worry3"
destring $g_order_worry, replace
// robustness check: to add order effects for control questions
rename p22_order order_control
replace order_control=subinstr(order_control,"r","",.)
split order_control, p(",")
global g_order_control "order_control1 order_control2 order_control3"
destring $g_order_control, replace
// robustness check: to add order effects for informed questions
rename p23_order order_informed
replace order_informed=subinstr(order_informed,"r","",.)
split order_informed, p(",")
global g_order_informed "order_informed1 order_informed2 order_informed3"
destring $g_order_informed, replace
// robustness check: to add order effects for estimations questions
rename p24p25_order order_estimations
replace order_estimations=subinstr(order_estimations,"p","",.)
split order_estimations, p(",")
global g_order_estimations "order_estimations1 order_estimations2"
destring $g_order_estimations, replace
// robustness check: to add order effects for conspiracy questions
rename p30cd_order order_conspiracy
replace order_conspiracy=subinstr(order_conspiracy,"r","",.)
split order_conspiracy, p(",")
global g_order_conspiracy "order_conspiracy1 order_conspiracy2 order_conspiracy3"
destring $g_order_conspiracy, replace

// robustness check: to add order effects for vaccine persuasive messages
rename p37_order order_vaccine_persuasion
replace order_vaccine_persuasion=subinstr(order_vaccine_persuasion,"r","",.)
replace order_vaccine_persuasion=subinstr(order_vaccine_persuasion,",","",.)
/*
destring order_vaccine_persuasion, replace //RK:do we need destring? only 28 records have missing values = no message (except price) was shown
replace order_vaccine_persuasion=0 if order_vaccine_persuasio==. //RK:to not drop no message subjects
tab order_vaccine_persuasion //added into next global 
*/

//creation of vars indicating which persuasive message was the 1st. 
//o_ is order 
//of_ is order = first
//i_ is interaction

gen o_prod_reputation=strpos(order_vaccine_persuasion, "1")
gen o_efficiency=strpos(order_vaccine_persuasion, "2")
gen o_safety=strpos(order_vaccine_persuasion, "3")
gen o_other_want_it=strpos(order_vaccine_persuasion, "5") //no 4, there is a gap, be careful!
gen o_scientific_authority=strpos(order_vaccine_persuasion, "6")
gen o_vax_passport=strpos(order_vaccine_persuasion, "7")
gen o_tested=strpos(order_vaccine_persuasion, "8")

global noprefix_vax_short "prod_reputation efficiency safety other_want_it scientific_authority ease_personal_restrictions tested"
dis "$noprefix_vax_short"

//order of persuasive msg:
global o_vaccine_short "" //order of persuasive msg
foreach word in $noprefix_vax_short {	
	global o_vaccine_short "$o_vaccine_short o_`word'" //add created variable into the global 	
}
dis "$o_vaccine_short"

//interaction: message was shown * order of persuasive msg
global io_vaxshort "" 
foreach manipulation in $noprefix_vax_short {
	capture gen io_`manipulation'=v_`manipulation'*o_`manipulation'	
	global io_vaxshort "$io_vaxshort io_`manipulation'" 	
}
dis "$io_vaxshort"
//END: order of persuasive msg



//was persuasive msg shown the 1st:
global fo_vaccine_short "" //if order of persuasive msg ==1
foreach manipulation in $noprefix_vax_short {
	gen fo_`manipulation'=o_`manipulation'==1 //creates first_order dummy if order of persuasive msg ==1	
	global fo_vaccine_short "$fo_vaccine_short fo_`manipulation'" //add created variable into the global 	
}
dis "$fo_vaccine_short"

//interaction: message was shown * was persuasive msg shown the 1st
global ifo_vaxshort "" 
foreach manipulation in $noprefix_vax_short {
	capture gen ifo_`manipulation'=v_`manipulation'*fo_`manipulation'	
	global ifo_vaxshort "$ifo_vaxshort ifo_`manipulation'" 	
}
dis "$ifo_vaxshort"
//END: was persuasive msg shown the 1st
*/


/// TIME
// define variable that slows percentile, by time 
//rename survey_finish_time time
sort time
sum time
gen time_perc = _n/_N
//drop if time_perc<0.05|time_perc>0.95
replace time=time/60 //in minutes
sum time /*
//use it later during the robustness check, when results will be ready (add/remove 5% fastest participants)
rename (p19_time p20_time p22_time p23_time p24_time p25_time p30cd_time p37_time) (time_risk time_worry time_control time_informed time_estimationscases time_estimationsdeath time_conspiracy time_v_persuasion)
//do drop too quick subjects later */

/// OPEN ENDED QUESTION
// [P38] Describe below the main reasons for your decision regarding coronavirus vaccination. 
// [P39] Who or what could change your decision regarding coronavirus vaccination?
// [optional] [P21] What factors are major influences on the extent to which you are concerned about a coronavirus pandemic? 
//will be classified and set of explanations will be produced.
//capture export excel respondent_id v_decision open_ended_v_reasoning P380 open_ended_v_influencer P390 using "C:\Users\johns_000\Desktop\openendedquestionsforclassification.xls", firstrow(variables) replace
//every explanation will be assosiated with a dummy variable
rename p38 open_ended_v_why
rename p39 open_ended_v_who
rename p21 open_ended_fear_why

