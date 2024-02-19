*** Solutions to the exercises for topic 5
**********************************************
log using Topic5_Results.log, replace

* About Missings 
*1. 

display	(.>5)
*Returns as true as stata treats a missing as larger than any given numeric value

*2.
display .+.
* Sum of two missing values is a missing value

*3. 
display .+.a
*sum of two different type of missing value is a missing values

*4
display .a * .b
*product of two different types of missing value is a missing values


*** Missing Values In Regression Analysis

webuse nlsw88, clear

**1**
*Investigate the missing values in this dataset. Are there any? Can you detect certain patterns of missings?

misstable patterns , freq
*The most common pattern in missing values is when the union variable is missing and all others are there. The rest are much smaller ammounts. 


misstable summarize

**2** 
*For a dataset to be considered MAR, the following conditions should be met:
**The probability of missingness is not random, but it is fully accounted for by variables for which you have complete data.
**The missingness can be explained by differences in observed data but not by the missing data itself.


**3** 
correlate grade industry
correlate grade occupation
correlate grade hours
correlate grade tenure

correlate grade industry occupation hours tenure

*The discrepancy in correlations between indivudal and one line commands occurs because the command that calculates all correlations at once may use a different list of observations for each pair of variables, excluding any observation that has a missing value for any of the variables in the list.

**4** 
regress wage age married i2.race south smsa collgrad ttl_exp union

* Store the estimates from this regression
estimates store full_model
*Drop union
regress wage age married i2.race south smsa collgrad ttl_exp
estimates store reduced_model

* Compare the two sets of estimates
estimates table full_model reduced_model

*Age: The coefficient for age has become more negative in the reduced model, doubling in magnitude, which indicates that the effect of age on wage becomes more pronounced when union status is not controlled for.

*Married: The coefficient for married has also become more negative in the reduced model, suggesting a larger negative association between being married and wage when union status is not included.

*Race: The negative coefficient for race has increased in the reduced model, which could imply a stronger negative relationship between the non-white race indicator and wage without the union variable in the model.

*South: The negative coefficient for south has increased slightly, indicating a slightly stronger negative effect of being in the south on wage in the absence of the union variable.

*SMSA: The positive coefficient for smsa has decreased, suggesting a smaller positive effect of being in a Standard Metropolitan Statistical Area on wage when union membership is not considered.

*Collgrad: The coefficient for collgrad is almost unchanged, indicating that the effect of being a college graduate on wage is consistent regardless of the inclusion of the union variable.

*Ttl_exp: The coefficient for ttl_exp has increased slightly, implying a marginally stronger positive effect of total work experience on wage in the reduced model.

*Union: This variable was excluded in the reduced model. In the full model, it had a positive coefficient, suggesting that being a union member is associated with higher wages.

*Constant: The constant (_cons) has increased substantially in the reduced model. This change indicates a shift in the average wage predicted by the model when union is excluded.

**5**
*Imputation
mi set wide
mi register imputed union
mi impute logit union wage age married i2.race south smsa collgrad ttl_exp, add(20)

* After the imputation is done, run the regression on imputed data and store the estimates
mi estimate, post: regress wage age married i2.race south smsa collgrad ttl_exp union
* The 'post' option after mi estimate is crucial as it ensures the results are stored in e(b) and e(V)

*Store estimates
estimates store imputed_model

*Compare Models 
estimates table full_model reduced_model imputed_model

*Age: The coefficient for age in the imputed model (-.13211771) is between the full (-.0631262) and reduced (-.12949836) model values, showing a negative relationship with wage. The magnitude is closer to the reduced model, suggesting the imputation of union may have partially accounted for its absence.

*Married: The married coefficient in the imputed model (-.40038168) is very close to the reduced model (-.44449178), both of which are significantly more negative than in the full model (-.27250657). This indicates that the relationship between married and wage is less positive (or more negative) when union is not included, even after imputation.

*Race (Black): The coefficient for Black race in the imputed model (-1.2929216) is more negative than in both the full (-.909151) and reduced (-1.0685633) models, suggesting a stronger negative effect on wage.

*South: The coefficient for south in the imputed model (-.67682743) is less negative compared to the reduced model (-.9611616), and closer to the full model (-.85153687), indicating that imputation of union might have a mediating effect on the relationship between south and wage.

*SMSA: The coefficient for smsa in the imputed model (1.6780011) is lower than in the reduced model (1.7292766) but higher than in the full model (1.6336339), suggesting a positive effect on wage that is somewhat mitigated after imputation.

*Collgrad: The collgrad coefficient in the imputed model (2.777453) is very close to both the full (2.8713432) and reduced (2.961219) models, suggesting that the effect of being a college graduate on wage is consistent across models.

*Ttl_exp: The coefficient for ttl_exp (total experience) in the imputed model (.2997823) is slightly lower than in both the full (.30130597) and reduced (.3602157) models, indicating a positive effect on wage that is consistent across models.

*Union: The coefficient for union in the imputed model (1.8434316) is higher than in the full model (.7940267), suggesting that after imputation, union membership is associated with a larger positive effect on wage.

*Close log
log close

