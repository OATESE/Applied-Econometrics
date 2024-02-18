
use GreeneF41_3.dta, clear

regress wearn we ax ax2 kids mtr he hw

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
