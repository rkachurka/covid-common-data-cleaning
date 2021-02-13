clear
// install package to import spss file
// net from http://radyakin.org/transfer/usespss/beta
//usespss "data.sav"
//saveold "G:\Shared drives\Koronawirus\studies\5 data analysis (Ariadna data)\data_stata_format.dta", version(13)
capture use "G:\Shared drives\Koronawirus\studies\5 data analysis (Ariadna data)\data_stata_format.dta", clear
capture use "G:\Dyski współdzielone\Koronawirus\studies\5 data analysis (Ariadna data)\data_stata_format.dta", clear


//XXX to remove too fast and too slow participants

//goal: can we start with the vaccines part? will you be able to develop the do file to analyze it? I guess a simple ordered probit or ordered logit allowing for main effects and first-order interactions among our experimental variables and the demographics

//VACCINE PART DATA CLEANING
rename (p37_1_r1	p37_1_r2	p37_1_r3	p37_1_r4	p37_1_r5	p37_1_r6	p37_1_r7	p37_8_r1	p37_8_r2	p37_8_r3	p37_8_r4	p37) (v_producer_reputation	v_efficency	v_safety	v_scarsity	v_other_want_it	v_scientific_authority	v_ease_personal_restrictions	v_price0	v_priceplus70	v_priceminus10	v_priceminus70	v_decision) 
global vaccine_vars "v_producer_reputation	v_efficency	v_safety	v_scarsity	v_other_want_it	v_scientific_authority	v_ease_personal_restrictions	v_price0	v_priceplus70	v_priceminus10	v_priceminus70"

//DEMOGRAPHICS DATA CLEANING
//wojewodstwo is ommited, because of no theoretical reason to include it
rename (miasta wyksztalcenie) (city_population edu)
global demogr "sex age city_population edu"

//OTHER DATA CLEANING
ren kolejnosc_pytan questions_order_p1_p14 //we have a problem here, if we add this variable ologit doest work - no observations error. Probably we have too many combinations of question orders and some of them have only one observation
ren p5_losowanie questions_order_p5
ren warunek treatment //Asia, is it really treatment? which is which? which one is corona and cold?
global omg_pls_do_not_be_significant "questions_order_p5 i.treatment"

// correlations
pwcorr $demogr v_*, star(.01)
asdoc pwcorr $demogr v_*, star(.01) fs(6) dec(2) bonferroni save(Asdoc command results.doc) append

quietly ologit v_decision $vaccine_vars $demogr 
est store m_1
quietly ologit v_decision $vaccine_vars $demogr $omg_pls_do_not_be_significant
est store m_2
est table m_1 m_2 , b(%12.3f) var(20) star(.01 .05 .10) stats(N)

tab v_decision
