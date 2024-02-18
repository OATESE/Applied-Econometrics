*** Solutions to the exercises for topic 3
**********************************************

** adjust according to your own set-up

use GreeneF41_3.dta, clear

**1.1 estimation

regress wearn we ax ax2 kids mtr he hw
est store model1

**1.2 interpretation

*1.2.1 Does the constant term have a meaningful interpretation?


*1.2.2 What is the estimated effect of experience on earnings?
twoway (function y = _b[ax]*x + _b[ax2]*x^2, range(0 40))

//alternative
gen y = _b[ax]*ax + _b[ax2]*ax2

twoway line y ax, sort

*1.2.3 How can you interpret the dummy variable for kids?

*1.2.4 Can you compare the magnitude of the coefficients?

*1.2.5 Which coefficients are statistically significant?

*1.2.6 Compare your results with the results from estimating the smaller model in the slides. Comment on the most obvious differences.
regress wearn we ax ax2 kids mtr
est store model2

est table model1 model2

*1.2.7 Re-play your regression to show standardized coefficients:
regress, beta

//alternative 1
sum wearn
gen sd_wearn=r(sd)

sum we
gen sd_we=r(sd)

regress wearn we ax ax2 kids mtr he hw

display _b[we]*(sd_we/sd_wearn)

//alternative 2
egen std_wearn=std(wearn)
egen std_we=std(we)
egen std_ax=std(ax)
egen std_ax2=std(ax2)
egen std_kids=std(kids)
egen std_mtr=std(mtr)
egen std_he=std(he)
egen std_hw=std(hw)

reg std_wearn std_we std_ax std_ax2 std_kids std_mtr std_he std_hw

*1.2.5 Which coefficients are statistically significant?
regress wearn we ax ax2 kids mtr he hw

**1.3 hypothesis testing
*1.3.1
test ax ax2 kids

*1.3.2
test ax ax2 we kids mtr he hw 

*1.3.3
* H0: marginal effect of experience, evaluated at 
* ax = 5, is equal to zero:
* H1: H0 is not true
lincom ax + 2*5*ax2

* non-linear hypothesis: 
* H0: beta6/beta7 = 2
* H1: beta6/beta7 not equal to 2
nlcom ((_b[he]/_b[hw])-2)


*1.3.4 How can you test the null hypothesis that the marginal effect of experience on wife's earnings, evaluated at 30 years of experience, is equal to 0.1?
lincom ax + 2*ax2*30 - 0.1

**1.4 Variance inflation and correlations
estat vif
*** 1.5: predictions
predict e, resid
predict t, rstudent
predict h, leverage
predict d, cooksd

histogram e, kdensity
sum e, detail

*** 1.6: heteroskedasticity
rvfplot
* there is an obvious pattern which is caused by earnings being strictly 
* positive in our sample
rvpplot ax
rvpplot mtr
rvpplot he
* heteroskedasticity seems to be present with regards to some of the predictors

estat hettest
* we reject the null of homoscedasticity 
* Misspecification of the model can often show up as heteroskedasticity as well; 
* this is a poorly specified model, so before we address the heteroskedasticity we 
* would have to reformulate our model, if we were conducting actual research.

*** 1.7: Outliers and influential data
sum t h d

graph hbox t
* we have got some pretty large studentised residuals

sum h, detail
* same for leverage


lvr2plot

// Can you replicate the lvr2plot graph, this time weighting the size of the scatter points based on the cooksd value?
// [A detailed help file for lvr2plot can be found here: https://www.stata.com/manuals13/rregresspostestimationdiagnosticplots.pdf]
	
	
	
dfbeta

* take a look at some of those observations:
list id t h d _dfbeta* if inlist(id,57, 285, 369, 142, 362, 40, 269)

* observation 57 shifts the coefficients on ax and ax2 by more than half a standard deviation - that's a big effect. 
* This person has an hourly wage in the top 5% (variable ww) and a lot of job experience (second highest value). 

* observation 369 shifts the coefficient on hw by nearly a standard deviation! 
* This observation is a part-time worker with an hourly wage in the top 2%. The husband 
* has the highest hourly wage in the sample. 

* observation 285 shifts the mtr and he coefficients.
* observation 142 shifts all coefficients somewhat. Also very poorly fitted. 

// Rerun the regression without observation 369, comment on the difference between the regression results. 
