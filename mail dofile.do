clear all
// install package to import spss file
// net from http://radyakin.org/transfer/usespss/beta
//usespss "data.sav"
//saveold "G:\Shared drives\Koronawirus\studies\5 data analysis (Ariadna data)\data_stata_format.dta", version(13)
capture use "G:\Shared drives\Koronawirus\studies\5 data analysis (Ariadna data)\data_stata_format.dta", clear
capture use "G:\Dyski współdzielone\Koronawirus\studies\5 data analysis (Ariadna data)\data_stata_format.dta", clear




//XXX to remove too fast and too slow participants, e.g. fastest (5%) slowest (1%)
// define variable that slows percentile, by time
sort time
gen time_perc = _n/_N
//use it later during the robustness check, when results will be ready (add/remove 5% fastest participants)

gen male=sex==2

//VACCINE PART DATA CLEANING
rename (p37_1_r1	p37_1_r2	p37_1_r3	p37_1_r4	p37_1_r5	p37_1_r6	p37_1_r7	p37_8_r1	p37_8_r2	p37_8_r3	p37_8_r4	p37) (v_producer_reputation	v_efficiency	v_safety	v_scarcity	v_other_want_it	v_scientific_authority	v_ease_personal_restrictions	v_p_pay0	v_p_gets70	v_p_pays10	v_p_pays70	v_decision) 
global vaccine_vars "v_producer_reputation	v_efficiency	v_safety	v_scarcity	v_other_want_it	v_scientific_authority	v_ease_personal_restrictions	v_p_gets70	v_p_pays10	v_p_pays70"
global vaccine_short "v_producer_reputation	v_efficiency	v_safety	v_scarcity	v_other_want_it	v_scientific_authority	v_ease_personal_restrictions"
global prices "v_p_gets70	v_p_pays10	v_p_pays70"

//info in wrong columns, pls check for more such cases!
//replace v_decision=P390 if v_decision==""
//RK: pls elaborate on above in details, I dont undesrtand these lines. I double checked, all is fine with columns

//DEMOGRAPHICS DATA CLEANING
//wojewodstwo is ommited, because of no theoretical reason to include it
rename (age year) (age_category age)
rename (miasta wyksztalcenie) (city_population edu)

capture drop elementary_edu
gen elementary_edu=edu==1|edu==2
gen secondary_edu=edu==3|edu==4
gen higher_edu=edu==5|edu==6|edu==7

rename m8 income
gen wealth_low=income==1|income==2
gen wealth_high=income==4|income==5
global wealth "wealth_low wealth_high"

global price_wealth ""
foreach price in $prices {
	foreach level in $wealth {
	gen wp_`price'_`level'=`price'*`level'
	global price_wealth "$price_wealth wp_`price'_`level'" 	
}
}
dis "$price_wealth"


rename m9 health_state

gen health_poor=health_state==1|health_state==2
gen health_good=health_state==4|health_state==5

gen had_covid=(5-p31)

gen covid_friends=p33==1
gen covid_friends_hospital=p34==1

gen no_covid_friends=covid_friends==0
gen covid_friends_nohospital=covid_friends==1&covid_friends_hospital==0

//to create 3 variables know+hospitalizaed, not hospitalized and etc


gen religious=m10==2|m10==3
gen religious_often=m11==4|m11==5|m11==6 //often = more than once a month
rename m11 religious_freq


//use it later during the robustness check, when results will be ready

gen status_unemployed=m12==5
gen status_pension=m12==6
gen status_student=m12==7

global demogr "male age i.city_population secondary_edu higher_edu $wealth health_poor health_good had_covid  covid_friends religious i.religious_freq status_unemployed status_pension status_student"
global demogr_int "male age higher_edu"

//********************************************//
//OTHER DATA CLEANING
rename warunek treatment //1.COVID 2.Cold, 3.Unemployment
global order_effects "i.treatment"

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
rename (p23_r1 p23_r2 p23_r3) (inf_covid inf_cold inf_unempl)
global informed "inf_covid inf_cold inf_unempl"

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
rename (p24 p25) (cases death)
replace cases=. if death>cases*100
gen ln_cases=ln(cases+1)
replace ln_cases=0 if ln_cases==.
gen ln_death=ln(death+1)
replace ln_death=0 if ln_death==.

global covid_impact "ln_cases ln_death"

//pls add comments in the code, especially such code:
global int_manips ""
foreach manipulation in $vaccine_short {
	foreach man2 in $vaccine_vars {
	local abb=substr("`manipulation'",1,14)
	local abb2=substr("`man2'",1,14)
	 gen vi_`abb'_`abb2'=`abb'*`abb2'	
	global int_manips "$int_manips vi_`abb'_`abb2'" 	
}
}
dis "$int_manips"

//
global interactions ""
foreach manipulation in $vaccine_vars {
	foreach demogr in $demogr_int {
	local abb=substr("`manipulation'",1,14)
	gen i_`abb'_`demogr'=`abb'*`demogr'	
	global interactions "$interactions i_`abb'_`demogr'" 	
}
}
dis "$interactions"

global int_consp_manip ""
foreach manipulation in $vaccine_vars {
	local abb=substr("`manipulation'",1,14)
	gen `abb'_conspiracy=`abb'*conspiracy_score	
	global int_consp_manip "$int_consp_manip `abb'_conspiracy" 	
}
dis "$int_consp_manip"

//gen int_voting_prod=voting*v_producer_reputation

//gen int_voting_safety=voting*v_safety

quietly ologit v_decision $vaccine_vars $demogr 
est store m_1
quietly ologit v_decision $vaccine_vars $demogr $emotions $risk $worry $voting  $control $informed conspiracy_score $covid_impact $order_effects
est store m_2
test $vaccine_vars

quietly ologit v_decision $vaccine_vars $demogr $emotions $risk $worry $voting $control $informed conspiracy_score $covid_impact $order_effects $interactions
est store m_3
test $interactions
quietly ologit v_decision $vaccine_vars $demogr $emotions $risk $worry $voting $control $informed conspiracy_score $covid_impact $order_effects $int_manips
est store m_4
test $int_manips
quietly ologit v_decision $vaccine_vars $demogr $emotions $risk $worry $voting $control $informed conspiracy_score $covid_impact $order_effects $price_wealth
est store m_5
test $price_wealth
quietly xi:ologit v_decision $vaccine_vars $demogr $emotions $risk $worry $voting $control $informed conspiracy_score $covid_impact $order_effects i.voting*v_producer_reputation i.voting*v_safety
est store m_6
test _IvotXv_pro_1 _IvotXv_pro_2 _IvotXv_pro_3 _IvotXv_pro_4 _IvotXv_pro_7 _IvotXv_pro_8 _IvotXv_pro_9 _IvotXv_saf_1 _IvotXv_saf_2 _IvotXv_saf_3 _IvotXv_saf_4 _IvotXv_saf_7 _IvotXv_saf_8 _IvotXv_saf_9
quietly ologit v_decision $vaccine_vars $demogr $emotions $risk $worry $voting $control $informed conspiracy_score $covid_impact $order_effects $int_consp_manip
est store m_7
test $int_consp_manip

est table m_1 m_2 m_3 m_4 m_5 m_6 m7, b(%12.3f) var(20) star(.01 .05 .10) stats(N)
//no interactions detected

quietly ologit v_decision $vaccine_vars $demogr 
est store m_1
quietly ologit v_decision $vaccine_vars $demogr $emotions $risk $worry $voting $control $informed conspiracy_score $covid_impact $order_effects
est store m_2

est table m_1 m_2, b(%12.3f) var(20) star(.01 .05 .10) stats(N)
