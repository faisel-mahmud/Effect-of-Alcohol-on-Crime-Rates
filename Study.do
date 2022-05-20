set more off 
clear all 

**set your desired path here
cd "C:/Users/Faisel Mahmud/Desktop/Econ 104 HW Assignments/Homework 4"
use NHISData.dta, clear
* nhis data

**** Setup ****

* Make RD variables
*create rd variables here (same as from hw3)

**** Check balance ****

*1
gen age = 21 + days_21/365
gen agec = age - 21
gen post = 1 if agec >= 0
replace post = 0 if agec < 0
gen agec_sq = agec^2
gen agec_cu = agec^3
gen agec_post = agec*post
gen agec_sq_post = agec_sq*post
gen agec_cu_post = agec_cu*post

label var drinks_alcohol "Drinking"
label var post "Above 21"
label var agec "Age centered on 21"
label var agec_post "Age centered on 21 * Over 21"

*q1
reg uninsured post agec agec_post if age >= 19 & age <= 23
outreg2 using "balanceTable4.xls", dec(3) label replace
reg hs_diploma post agec agec_post if age >= 19 & age <= 23
outreg2 using "balanceTable4.xls", dec(3) append label
reg hispanic post agec agec_post if age >= 19 & age <= 23
outreg2 using "balanceTable4.xls", dec(3) append label
reg white post agec agec_post if age >= 19 & age <= 23
outreg2 using "balanceTable4.xls", dec(3) append label
reg black post agec agec_post if age >= 19 & age <= 23
outreg2 using "balanceTable4.xls, dec(3) append label
reg employed post agec agec_post if age >= 19 & age <= 23
outreg2 using "balanceTable4.xls", dec(3) append label
reg married post agec agec_post if age >= 19 & age <= 23
outreg2 using "balanceTable4.xls", dec(3) append label
reg working_lw post agec agec_post if age >= 19 & age <= 23
outreg2 using "balanceTable4.xls", dec(3) append label
reg going_school post agec agec_post if age >= 19 & age <= 23
outreg2 using "balanceTable4.xls", dec(3) append label
reg male post agec agec_post if age >= 19 & age <= 23
outreg2 using "balanceTable4.xls", dec(3) append label

*q2
use Arrest.dta, clear

gen age = 21 + days_to_21/365
gen agec = age - 21
gen post = 1 if agec >= 0
replace post = 0 if agec < 0
gen agec_post = agec*post

gen bin_30days= 21 + 30*floor(days_to_21/30)/365 + (30/2)/365

preserve
collapse (mean) all age agec, by(bin_30days)
reg all age if age >= 19 & age < 21
predict fitted_left if age >= 19 & age < 21
reg all age if age >= 21 & age < 23
predict fitted_right if age >= 21 & age < 23
#delimit ;
graph twoway (scatter all age)
	(line fitted_left age)
	(line fitted_right age)
	if age >= 19 & age <= 23,
	title("Overall Arrests for Ages under 21 and Over")
	xtitle("Age")
	ytitle("Overall Arrests")
	legend(off)
	scheme(s1mono)
	;
#delimit cr

*q3
preserve
collapse (mean) dui liquor_laws age, by(bin_30days)
*regression lines for dui
reg dui age if age >= 19 & age < 21
predict fitted_left_DUI if age >= 19 & age < 21
reg dui age if age >= 21 & age <= 23
predict fitted_right_DUI if age >= 21 & age <= 23
*regression lines for liquor_laws
reg liquor_laws age if age >= 19 & age < 21
predict fitted_left_liquorLaws if age >= 19 & age < 21
reg liquor_laws age if age >= 21 & age <= 23
predict fitted_right_liquorLaws if age >= 21 & age <= 23
*graph
#delimit ;
graph twoway (scatter dui age, msymbol(circle) mcolor(black) yaxis(1) yscale(axis(1) range(50 400)))
(scatter liquor_laws age, msymbol(square) mcolor(red) yaxis(2) yscale(axis(2) range(8 9)))
(line fitted_left_DUI age, yaxis(1) lcolor(black) yscale(axis(1) range(50 400)))
(line fitted_right_DUI age, yaxis(1) lcolor(black) yscale(axis(1) range(50 400)))
(line fitted_left_liquorLaws age, yaxis(2) lcolor(black) yscale(axis(2) range(0 90)))
(line fitted_right_liquorLaws age, yaxis(2) lcolor(black) yscale(axis(2) range(0 90)))
if age >= 19 & age <= 23,
ylabel(#6, axis(1) nogrid)
ylabel(#6, axis(2))
title(Alcohol Involved Arrests)
xtitle(Age)
ytitle(DUI Rate, axis(1))
ytitle(Breaking Liquor Laws rate, axis(2))
legend (order(1 "DUI" 4 "Breaking Liquor Laws") ring(0) pos(1) )
scheme(s1mono)
;
#delimit cr
restore
graph export "DUI_LiquorLaws_figure.jpg", replace


preserve
collapse (mean) combined_oth robbery age, by(bin_30days)
*regression lines for combined_oth
reg combined_oth age if age >= 19 & age < 21
predict fitted_left_combined_oth if age >= 19 & age < 21
reg combined_oth age if age >= 21 & age <= 23
predict fitted_right_combined_oth if age >= 21 & age <= 23
*regression lines for robbery
reg robbery age if age >= 19 & age < 21
predict fitted_left_robbery if age >= 19 & age < 21
reg robbery age if age >= 21 & age <= 23
predict fitted_right_robbery if age >= 21 & age <= 23
*graph
#delimit ;
graph twoway (scatter combined_oth age, msymbol(circle) mcolor(black) yaxis(1) yscale(axis(1) range(50 350)))
(scatter robbery age, msymbol(square) mcolor(red) yaxis(2) yscale(axis(2) range(8 9)))
(line fitted_left_combined_oth age, yaxis(1) lcolor(black) yscale(axis(1) range(50 400)))
(line fitted_right_combined_oth age, yaxis(1) lcolor(black) yscale(axis(1) range(50 400)))
(line fitted_left_robbery age, yaxis(2) lcolor(black) yscale(axis(2) range(0 90)))
(line fitted_right_robbery age, yaxis(2) lcolor(black) yscale(axis(2) range(0 90)))
if age >= 19 & age <= 23,
ylabel(#6, axis(1) nogrid)
ylabel(#6, axis(2))
title(Alcohol Involved Arrests)
xtitle(Age)
ytitle(Disorderly Conduct/Vagrancy Rate, axis(1))
ytitle(Robbery Rate, axis(2))
legend (order(1 "Disorderly Conduct/Vagrancy" 4 "Robbery") ring(0) pos(1) )
scheme(s1mono)
;
#delimit cr
restore
graph export "CombiendOTH_Robbery_figure.jpg", replace



preserve
collapse (mean) ot_assault aggravated_assault age, by(bin_30days)
*regression lines for combined_oth
reg ot_assault age if age >= 19 & age < 21
predict fitted_left_ot_assault if age >= 19 & age < 21
reg ot_assault age if age >= 21 & age <= 23
predict fitted_right_ot_assault if age >= 21 & age <= 23
*regression lines for robbery
reg aggravated_assault age if age >= 19 & age < 21
predict fitted_left_aa if age >= 19 & age < 21
reg aggravated_assault age if age >= 21 & age <= 23
predict fitted_right_aa if age >= 21 & age <= 23
*graph
#delimit ;
graph twoway (scatter ot_assault age, msymbol(circle) mcolor(black) yaxis(1) yscale(axis(1) range(50 350)))
(scatter aggravated_assault age, msymbol(square) mcolor(red) yaxis(2) yscale(axis(2) range(8 9)))
(line fitted_left_ot_assault age, yaxis(1) lcolor(black) yscale(axis(1) range(50 400)))
(line fitted_right_ot_assault age, yaxis(1) lcolor(black) yscale(axis(1) range(50 400)))
(line fitted_left_aa age, yaxis(2) lcolor(black) yscale(axis(2) range(0 90)))
(line fitted_right_aa age, yaxis(2) lcolor(black) yscale(axis(2) range(0 90)))
if age >= 19 & age <= 23,
ylabel(#6, axis(1) nogrid)
ylabel(#6, axis(2))
title(Alcohol Involved Arrests)
xtitle(Age)
ytitle(Simple Assault, axis(1))
ytitle(Aggravated Assault, axis(2))
legend (order(1 "Simple Assault" 4 "Aggravated Assault") ring(0) pos(1) )
scheme(s1mono)
;
#delimit cr
restore
graph export "Simple_AA.jpg", replace

*q4
gen birthday = 0 
replace birthday = 1 if age >= 21 & age <= 21

reg all post agec agec_post if age >= 19 & age <= 23
outreg2 using "Overall_Increase.xls", dec(3) label replace
reg all post agec agec_post birthday if age >= 19 & age <= 23
outreg2 using "Overall_Increase.xls", dec(3) append label
reg dui post agec agec_post  if age >= 19 & age <= 23
outreg2 using "Overall_Increase.xls", dec(3) append label
reg dui post agec agec_post birthday  if age >= 19 & age <= 23
outreg2 using "Overall_Increase.xls", dec(3) append label
reg liquor_laws post agec agec_post  if age >= 19 & age <= 23
outreg2 using "Overall_Increase.xls", dec(3) append label
reg liquor_laws post agec agec_post birthday  if age >= 19 & age <= 23
outreg2 using "Overall_Increase.xls", dec(3) append label
reg robbery post agec agec_post  if age >= 19 & age <= 23
outreg2 using "Overall_Increase.xls", dec(3) append label
reg robbery post agec agec_post birthday  if age >= 19 & age <= 23
outreg2 using "Overall_Increase.xls", dec(3) append label
reg aggravated_assault post agec agec_post  if age >= 19 & age <= 23
outreg2 using "Overall_Increase.xls", dec(3) append label
reg aggravated_assault post agec agec_post birthday  if age >= 19 & age <= 23
outreg2 using "Overall_Increase.xls", dec(3) append label
reg ot_assault post agec agec_post  if age >= 19 & age <= 23
outreg2 using "Overall_Increase.xls", dec(3) append label
reg ot_assault post agec agec_post birthday  if age >= 19 & age <= 23
outreg2 using "Overall_Increase.xls", dec(3) append label
reg drunk_risk post agec agec_post  if age >= 19 & age <= 23
outreg2 using "Overall_Increase.xls", dec(3) append label
reg drunk_risk post agec agec_post birthday  if age >= 19 & age <= 23
outreg2 using "Overall_Increase.xls", dec(3) append label
reg combined_oth post agec agec_post  if age >= 19 & age <= 23
outreg2 using "Overall_Increase.xls", dec(3) append label
reg combined_oth post agec agec_post birthday  if age >= 19 & age <= 23
outreg2 using "Overall_Increase.xls", dec(3) append label

*q5
/* we note that the MLDA leads to a decrease in overall crime, observed from the  
graphs and the regression table. There is roughly a 20% increase to overall crime
at the age of 21, and we get this data from our graphs. However we should also
note that the breaking liquor laws rate decreases at 21, which intuitively, makes sense
since you can legally purchase alcohol at the age of 21.
*/

*q6/q7
*First Stage Estimation
use "NHISData.dta", clear

gen age = 21 + days_21/365
gen agec = age - 21
gen post = 1 if agec >= 0
replace post = 0 if agec < 0
gen agec_sq = agec^2
gen agec_cu = agec^3
gen agec_post = agec*post
gen agec_sq_post = agec_sq*post
gen agec_cu_post = agec_cu*post

label var post "Over 21"
label var agec "Age centered at 21"
label var agec_post "Age centered at 21 * Over 21"
label var drinks_alcohol "Drinking Alcohol"

reg drinks_alcohol post agec agec_post if age >= 19 & age <= 23
local phi = _b[post]
local se_phi = _se[post]
*FS


*Reduced Form Estimate
use Arrest.dta, clear
gen age = 21 + days_to_21/365
gen agec = age - 21
gen post = 1 if agec >= 0
replace post = 0 if agec < 0
gen agec_sq = agec^2
gen agec_cu = agec^3
gen agec_post = agec*post
gen agec_sq_post = agec_sq*post
gen agec_cu_post = agec_cu*post

*IV All Arrests
reg all post agec agec_post if age >= 19 & age <= 23
local rho = _b[post]
local se_rho = _se[post]

local rho_sq = (`rho')^2
local phi_4 = (`phi')^4
local var_phi = (`se_phi')^2
local var_rho = (`se_rho')^2
local phi_sq = (`phi')^2

local iv_var = ((`rho_sq'/`phi_4')*`var_phi')+((1/`phi_sq')*`var_rho')
local iv_se = sqrt(`iv_var')
local iv_coef = `rho'/`phi'
disp `iv_coef'
disp `iv_se'


*IV DUI
reg dui post agec agec_post if age >= 19 & age <= 23
local rho = _b[post]
local se_rho = _se[post]

local rho_sq = (`rho')^2
local phi_4 = (`phi')^4
local var_phi = (`se_phi')^2
local var_rho = (`se_rho')^2
local phi_sq = (`phi')^2

local iv_var = ((`rho_sq'/`phi_4')*`var_phi')+((1/`phi_sq')*`var_rho')
local iv_se = sqrt(`iv_var')
local iv_coef = `rho'/`phi'
disp `iv_coef'
disp `iv_se'

*IV Liquor_Laws
reg liquor_laws post agec agec_post if age >= 19 & age <= 23
local rho = _b[post]
local se_rho = _se[post]

local rho_sq = (`rho')^2
local phi_4 = (`phi')^4
local var_phi = (`se_phi')^2
local var_rho = (`se_rho')^2
local phi_sq = (`phi')^2

local iv_var = ((`rho_sq'/`phi_4')*`var_phi')+((1/`phi_sq')*`var_rho')
local iv_se = sqrt(`iv_var')
local iv_coef = `rho'/`phi'
disp `iv_coef'
disp `iv_se'

*IV OTH Combined
reg combined_oth post agec agec_post if age >= 19 & age <= 23
local rho = _b[post]
local se_rho = _se[post]

local rho_sq = (`rho')^2
local phi_4 = (`phi')^4
local var_phi = (`se_phi')^2
local var_rho = (`se_rho')^2
local phi_sq = (`phi')^2

local iv_var = ((`rho_sq'/`phi_4')*`var_phi')+((1/`phi_sq')*`var_rho')
local iv_se = sqrt(`iv_var')
local iv_coef = `rho'/`phi'
disp `iv_coef'
disp `iv_se'

*IV Robbery
reg robbery post agec agec_post if age >= 19 & age <= 23
local rho = _b[post]
local se_rho = _se[post]

local rho_sq = (`rho')^2
local phi_4 = (`phi')^4
local var_phi = (`se_phi')^2
local var_rho = (`se_rho')^2
local phi_sq = (`phi')^2

local iv_var = ((`rho_sq'/`phi_4')*`var_phi')+((1/`phi_sq')*`var_rho')
local iv_se = sqrt(`iv_var')
local iv_coef = `rho'/`phi'
disp `iv_coef'
disp `iv_se'

*OT_assault
reg ot_assault post agec agec_post if age >= 19 & age <= 23
local rho = _b[post]
local se_rho = _se[post]

local rho_sq = (`rho')^2
local phi_4 = (`phi')^4
local var_phi = (`se_phi')^2
local var_rho = (`se_rho')^2
local phi_sq = (`phi')^2

local iv_var = ((`rho_sq'/`phi_4')*`var_phi')+((1/`phi_sq')*`var_rho')
local iv_se = sqrt(`iv_var')
local iv_coef = `rho'/`phi'
disp `iv_coef'
disp `iv_se'

*Aggravated Assault
reg aggravated_assault post agec agec_post if age >= 19 & age <= 23
local rho = _b[post]
local se_rho = _se[post]

local rho_sq = (`rho')^2
local phi_4 = (`phi')^4
local var_phi = (`se_phi')^2
local var_rho = (`se_rho')^2
local phi_sq = (`phi')^2

local iv_var = ((`rho_sq'/`phi_4')*`var_phi')+((1/`phi_sq')*`var_rho')
local iv_se = sqrt(`iv_var')
local iv_coef = `rho'/`phi'
disp `iv_coef'
disp `iv_se'

*drunk_risk
reg drunk_risk post agec agec_post if age >= 19 & age <= 23
local rho = _b[post]
local se_rho = _se[post]

local rho_sq = (`rho')^2
local phi_4 = (`phi')^4
local var_phi = (`se_phi')^2
local var_rho = (`se_rho')^2
local phi_sq = (`phi')^2

local iv_var = ((`rho_sq'/`phi_4')*`var_phi')+((1/`phi_sq')*`var_rho')
local iv_se = sqrt(`iv_var')
local iv_coef = `rho'/`phi'
disp `iv_coef'
disp `iv_se'

*q8
/*
I believe that almost all the assumptions are met here. For the first 
assumption, The reduced form and first stage estimates are consistent. Our 
instrument, the MLDA in RCT terms, is as good as being as randomly assigned
since we can't actually randomly assign who's above and below 21. Thus,
we can observe arrest rates below or above the MLDA. Our second 
assumption is met since all of our IV estimates aren't zero, we can positively 
conclude that the first stage also isn't 0, otherwise we wouldn't be able to 
display the IV estimates for each case. The third assumption I believe isn't met
since the MLDA does not only impact arrest rates through drinking alcohol. An 
example of this is how being above the MLDA also allows you access to handguns
which may used to commit crimes. 



