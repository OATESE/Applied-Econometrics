*** Solutions to the exercises for topic 6
*********************************************

graph drop _all 
log using Topic6_Results.log, replace

********************************
** Binary Dependent Variables **
********************************
clear

*** 1. Use the National Labour Survey data
sysuse nlsw88, clear

*** 2. Generate a variable holding the weekly earnings (wage x hours)
* This will be done by creating a new variable that multiplies wage by hours worked
gen weekly_earnings = wage * hours


*** Part 3: Generate a variable that is equal to one if the person is in the top 25% of weekly earners, and zero otherwise
* This will first require determining the 75th percentile value of weekly earnings
summarize weekly_earnings, detail
local top25percentile = r(p75)
* Now, generate the indicator variable
gen high_earner = (weekly_earnings >= `top25percentile')


*** Part 4: Run a regression model where the new indicator variable is the dependent variable

* Independent variables: age, grade, race, married, union, south, smsa, hours, ttl.exp, and tenure
* The race, married, and union variables are categorical and need to be factorized
regress high_earner i.race i.married i.union south smsa hours ttl_exp tenure age grade
* Store the model for later use
estimates store linear_model

*** 5. Examine the output and comment on sign and significance of the coefficients

* Interpretation of 'union' coefficient
* A positive coefficient of 0.0835062 for 'union' suggests that, holding other variables constant, being a member of a union is associated with an 8.35 percentage point increase in the likelihood of being in the top 25% of weekly earners. The coefficient is statistically significant (P < 0.01).

* Interpretation of 'south' coefficient
* A negative coefficient of -0.580796 for 'south' suggests that, holding other variables constant, living in the South is associated with a 58.08 percentage point decrease in the likelihood of being in the top 25% of weekly earners. This coefficient is statistically significant (P < 0.05).


*** 6. Assess if the linear regression results in predictions outside the (0,1) interval, and identify how many observations are affected

* Generate predicted values from the linear regression model
predict predicted_values

* Count the number of predictions outside the (0,1) interval
count if predicted_values < 0 | predicted_values > 1

* Store the number of affected observations in a local macro for reporting or further analysis
scalar observations_outside_interval = r(N)

* Display the number of observations with predictions outside the (0,1) interval
display "Number of observations with predictions outside the (0,1) interval: " observations_outside_interval


* 7. Estimate the same model using logistic regression (logit)
* Store the estimates for comparison with the linear model
logit high_earner i.race i.married i.union south smsa hours ttl_exp tenure age grade

* 8. Comment on the logit model output
* Interpret the same two coefficients as in the linear model but within the context of log-odds
*
* A positive coefficient of 0.5654573 for 'union' in a logistic regression indicates that union members have higher log-odds of being a top earner compared to non-members, holding other variables constant. This coefficient is statistically significant (P < 0.01), implying that union membership is an important predictor of being in the top 25% of weekly earners.

* A negative coefficient of -0.4955706 for 'south' suggests that individuals in the South have lower log-odds of being a top earner compared to those in other regions. This result is statistically significant (P < 0.01), indicating a meaningful difference in the likelihood of being a high earner based on geographical location.


*** Part 9. Examine the goodness of fit statistics for your logit model
* The model's Pseudo R-squared of 0.3191 indicates that approximately 31.91% of the variability in being a high earner is explained by the model. A likelihood ratio test statistic (LR chi2) of 689.98 with a P-value close to 0 suggests that the model as a whole is statistically significant.


* 10. Calculate the average marginal effect of experience, separately for married and single people
* This involves using the margins command after estimating the logit model
margins, dydx(ttl_exp) at(married=(0 1))



* 11. Calculate the predicted probability of being a high earner for a white person in the south, with otherwise average characteristics, at grade=(10 13 16)
* Compare these predictions with those from the linear regression model and comment on any differences
quietly: logit high_earner i.race i.married i.union south smsa hours ttl_exp tenure age grade
margins, at(grade=(10 13 16))


*************************
** Interaction Effects **
*************************


* 1. Expand your model by adding an interaction effect between a dummy variable (dvar) and a continuous variable (cvar)
logit high_earner i.race##c.ttl_exp i.married i.union south smsa hours tenure age grade


* 2. Store the logistic regression model estimates
estimates store logit_interaction_model

* 3. Calculate the average marginal effect of the continuous variable on the probability of being a high earner, over the dummy variable
margins, dydx(ttl_exp) over(race)

* 4. Estimate the same model by OLS
regress high_earner i.race##c.ttl_exp i.married i.union south smsa hours tenure age grade
estimates store ols_interaction_model


* 5. Calculate the average marginal effect of the continuous variable (cvar) on the probability of being a high earner, over the dummy variable (dvar)
margins, dydx(ttl_exp) over(race)
* For the OLS model, the average marginal effect of total work experience (ttl_exp) on the probability of being a high earner:
* - White individuals show a significant increase of about 0.145 per year of experience.
* - Black individuals show a smaller and not statistically significant increase of about 0.006 per year of experience.
* - Individuals of 'Other' race categories show a small and not statistically significant increase of about 0.014 per year of experience.

* For the logit model, the average marginal effect of total work experience (ttl_exp) on the log-odds of being a high earner:
* - White individuals show a significant increase in the log-odds of being a high earner by about 0.018 per year of experience.
* - Black individuals show a significant increase in the log-odds of about 0.015, which is slightly lower than that for White individuals.
* - Individuals of 'Other' race categories show a non-significant increase in the log-odds of about 0.019 per year of experience.

* The key differences are:
* - The magnitude of the effect is larger in the OLS model than in the logit model.
* - The OLS model shows statistical significance for White individuals only, while the logit model shows significance for both White and Black individuals.
* - The confidence intervals in the OLS model are narrower compared to the logit model, which suggests more precision in the OLS estimates.
* - The OLS estimates are in terms of probability changes, while the logit estimates are in terms of changes in log-odds.

* 6. Choose a second continuous variable (cvar2)
* Restore the logit model before calculating marginal effects
estimates restore logit_interaction_model

summarize tenure
* Set the values for weekly_earnings at which to calculate the marginal effects
local mean_tenure = r(mean)
local low_tenure = r(mean) - r(sd)
local high_tenure = r(mean) + r(sd)

* Calculate the marginal effects of ttl_exp over race at the chosen values of weekly_earnings
margins, dydx(ttl_exp) over(race) at(tenure=(`low_tenure' `mean_tenure' `high_tenure'))

* Plot the marginal effects
marginsplot, name(marginsplot_logit)

***7.
* Estimate the same model by OLS to calculate marginal effects
regress high_earner i.race##c.ttl_exp i.married i.union south smsa hours tenure age grade
summarize tenure
* Store the mean and standard deviations of tenure in local macros
local mean_tenure_ols = r(mean)
local low_tenure_ols = r(mean) - r(sd)
local high_tenure_ols = r(mean) + r(sd)
* Calculate the marginal effects of ttl_exp over race at the low, mean, and high values of tenure for the OLS model
margins, dydx(ttl_exp) over(race) at(tenure=(`low_tenure_ols' `mean_tenure_ols' `high_tenure_ols'))

* Plot the marginal effects for the OLS model
marginsplot, name(marginsplot_ols)


**Differences in graphs 

// Scale of the Effects:
//In the first graph (logit model), the effects on the probability range roughly from -0.02 to 0.06.
//In the second graph (OLS model), the effects on the linear prediction are narrower, ranging approximately from -0.01 to 0.04.

//Interpretation of Effects:
//The effects in the first graph are interpreted as changes in the probability of being a high earner due to one more year of total work experience, conditional on job tenure and race.
//The effects in the second graph reflect changes in the linear prediction (which could be the log-odds of being a high earner) for one more year of total work experience, also conditional on job tenure and race.

//Confidence Intervals:
//The confidence intervals in the first graph seem wider than those in the second graph, especially for the Black and Other racial groups at higher levels of job tenure. This suggests greater uncertainty or variability in the logistic regression estimates compared to the OLS regression estimates.

//Statistical Significance:
//While the second graph does not show statistical significance for any racial group across different levels of job tenure (as the CIs cross the zero-effect line), the first graph suggests there may be levels of job tenure where the effect of work experience on the probability of being a high earner is statistically significant for certain racial groups. However, this can only be confirmed by looking at the p-values associated with the estimates.

//Value of Job Tenure:
//Both graphs share the same job tenure values, but the interpretation of these values in relation to the dependent variable differs due to the nature of the models (logit versus OLS).

//Racial Group Effects:
//In both graphs, the effects for the White racial group remain relatively stable across different levels of job tenure, whereas for the Black and Other racial groups, the confidence intervals widen significantly as job tenure increases, indicating more uncertainty in the estimates for these groups at higher tenure levels.

//The differences in the graphs underscore the importance of model choice when interpreting interaction effects, as logistic regression models are nonlinear and probabilities are bounded between 0 and 1, while OLS regression models are linear and unbounded. This can lead to different conclusions about the significance and size of the interaction effects, as well as their stability across different values of the moderator variable (in this case, job tenure).
* Combine the plots
graph combine marginsplot_logit marginsplot_ols, name(combinedplot)

* Export the combined plot to an image file
graph export "combined_plot.png", as(png) replace



log close
