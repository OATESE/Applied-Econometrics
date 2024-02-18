*** Solutions for Regression Analysis Exercises ***
*** Topic 5: Heteroskedasticity and Specification Analysis ***

* Load the dataset HPRICE2
use "HPRICE2.dta", clear

*** Section 2.1 Lin-Lin Model ***
* Descriptive Statistics to understand the dataset
summarize

* Estimate the lin-lin regression model
regress price crime nox dist radial proptax rooms lowstat stratio

* Interpretation of Coefficients
* 'price': Dependent variable - median house price.
* 'crime': For each unit increase, price decreases by $122.54 (statistically significant).
* 'nox': Each unit increase, price decreases by $1,853.23 (statistically significant).
* 'dist': Each unit increase, price decreases by $1,231.39 (statistically significant).
* 'radial': Each unit increase, price increases by $293.17 (statistically significant).
* 'proptax': Each unit increase, price decreases by $122.31 (statistically significant).
* 'rooms': Each additional room increases price by $4,062.66 (statistically significant).
* 'lowstat': Each point increase, price decreases by $519.64 (statistically significant).
* 'stratio': Each unit increase, price decreases by $1,102.70 (statistically significant).
* '_cons': Median house price with all predictors at zero ($41,533.99, statistically significant).
* R-squared: 0.7154 - Model explains 71.54% of variability in price.

* Heteroskedasticity and Misspecification Tests
estat hettest
estat ovtest

* Interpretation of Diagnostic Tests
* Heteroskedasticity (Breusch–Pagan): chi2(1) = 5.69, p = 0.017, indicating heteroskedasticity.
* Misspecification (Ramsey RESET): F(3, 502) = 69.98, p < 0.001, indicating potential omitted variables or incorrect form.

* Residual-versus-Fitted Plot for heteroskedasticity
rvfplot, yline(0)

* Interaction Terms: Effect of 'nox' and 'dist' on 'price'
regress price c.nox##c.dist radial proptax rooms lowstat stratio

* Marginal Effects of 'nox' at different levels of 'dist'
margins, dydx(nox) at(dist=(1 12))
* Both marginal effects are significant at the 5% level.

* Include 'nox' squared in the model
regress price c.nox##c.nox##c.dist radial proptax rooms lowstat stratio

* New Marginal Effects with 'nox' squared
margins, dydx(nox) at(dist=(1 12))
* 'dist' = 1: Marginal effect of nox on price is not significant (p = 0.376).
* 'dist' = 12: Marginal effect of nox on price is significant (p < 0.001).

*** Section 2.2 Log-Lin and Log-Log Model ***
* Estimate the log-lin and log-log regression model
gen ldist = log(dist)
regress lprice crime lnox ldist radial lproptax rooms lowstat stratio

* Heteroskedasticity and Specification Tests
estat hettest
estat ovtest
* Heteroskedasticity (Breusch–Pagan): chi2(1) = 66.62, p < 0.00, indicating no heteroskedasticity.
* Misspecification (Ramsey RESET): F(3, 502) = 11.82, p < 0.001, indicating no potential omitted variables or incorrect form.

* Residual-versus-Fitted Plot
rvfplot, yline(0)

* Interaction Terms: Effect of 'lnox' and 'radial' on 'lprice'
regress lprice crime c.lnox##i.radial ldist lproptax rooms lowstat stratio

* Marginal Effects of 'radial' on 'lprice'
margins, dydx(radial) at(lnox=(1.34 2.16))

* Interaction Model Coefficients
* The interaction term `c.lnox#i.radial` is not consistently significant, indicating that the effect of `nox` on `price` does not uniformly vary with changes in `radial`.

* Marginal Effect of `radial` on `log(price)`
* At `log(nox)` = 1.34, the marginal effects are not significant.
* At `log(nox)` = 2.16, the marginal effects are significant for some categories of `radial`, suggesting that the importance of highway accessibility increases in areas with higher `nox` levels.


