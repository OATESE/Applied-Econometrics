*** code03.do
*** A selection of Stata commands from the 
*** Topic 3 lecture notes. 
********************************************
clear all
* Set up the working directory
cd "/Users/elliottoates/Library/CloudStorage/OneDrive-UniversityofExeter/Applied Econometrics/Topic 3"
pwd
*******************************
* Applied regression Analysis *
*******************************

* Load the data

use GreeneF41_3.dta
*** Perform a linear regression of wearn over ax ax2 we kids mtr
regress wearn ax ax2 we kids mtr

*** Get post-estimation elements

*** Predict the fitted values
predict yhat, xb
*** Predict the residuals
predict ehat, resid
*** Obtain the variance-covariance matrix
estat vce
*** F test of ax ax2
test ax ax2
*** Get the predicted earnings for a woman with no children, 10 years of schooling, no job experience and a marginal tax rate of 0.2
// linear combination of coefficients

*** Simple linear regression model

*** Compute the elasticites
// non-linear combination of coefficients

*** Display the coefficents and standard errors


*******************************
* Managing regression results *
*******************************

*** Store results in memory


*** Display estimation tables


*** Save results to disk

*** Clear Stata

**** Use previous results

