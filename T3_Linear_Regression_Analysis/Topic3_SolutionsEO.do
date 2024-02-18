// Load the dataset into Stata, clearing any existing data in memory
use GreeneF41_3.dta, clear

// Estimate a linear regression model with wife's earnings as the dependent variable
// Independent variables: wife's education, experience and its square, kids dummy, marginal tax rate, husband's education, and husband's mean hourly wage
regress wearn we ax ax2 kids mtr he hw
ereturn list
*1.2.1 Does the constant term have a meaningful interpretation?
// no cus reverse causality between mtr and earnings


// Store the model results for future reference
est store model1

// Generate a new variable 'y' to explore the estimated effect of experience on earnings graphically
// This command calculates the earnings based on experience (ax) and experience squared (ax2)
gen y = _b[ax]*ax + _b[ax2]*ax2

// Create a line plot of the generated variable 'y' against experience (ax), sorted by experience
twoway line y ax, sort

// Conduct hypothesis tests to examine the joint significance of experience, experience squared, and kids dummy variables
test ax ax2 kids

// Test the hypothesis that all coefficients apart from the constant term are jointly equal to zero
test ax ax2 we kids mtr he hw

// Linear combination command to test the marginal effect of experience evaluated at 5 years of experience
lincom ax + 2*5*ax2

// Non-linear hypothesis test comparing the ratio of coefficients of husband's education to husband's mean hourly wage against a value of 2
nlcom ((_b[he]/_b[hw])-2)

// Test the null hypothesis regarding the marginal effect of experience on wife's earnings evaluated at 30 years of experience being equal to 0.1
lincom ax + 2*ax2*30 - 0.1

// Calculate and display Variance Inflation Factors (VIF) to assess multicollinearity among independent variables
estat vif

// This marks the end of the do-file
