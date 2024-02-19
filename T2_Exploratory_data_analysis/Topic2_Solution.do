log using Topic2_Results.log, replace


sysuse nlsw88, clear 

// browse the data. Make sure you understand which variables are categorical and which are continuous, and what information each variables contains
browse

//Find the mean, median and standard deviation of wage. Is the distribution skewed? What are the smallest and largest values?
summarize wage, detail

// Compute and display the mean and median hourly wage for each category of the 'occupation' variable
// This addresses question 3: Analysis of a categorical variable (occupation) in terms of hourly wages
tabstat wage, by(occupation) statistics(mean median)


// Compute pairwise correlations among hourly wage, total experience, and tenure
// This addresses question 4: Analyzing the correlation between wage, experience, and tenure
pwcorr wage ttl_exp tenure, sig

// Create a histogram of hourly wages
// This addresses question 5: Producing and analyzing a distributional graph for hourly wages
histogram wage, title("Distribution of Hourly Wages") xlabel(none) ylabel(none) name(HistWage, replace)

// Create a histogram of total work experience
// This addresses question 5: Producing and analyzing a distributional graph for total work experience
histogram ttl_exp, title("Distribution of Total Work Experience") xlabel(none) ylabel(none) name(HistExp, replace)
	
// Create a scatter plot of hourly wage against hours worked per week
// This addresses question 6: Analyzing the relationship between work hours and hourly wages
scatter wage hours, ///
    title("Hourly Wage vs. Hours Worked per Week") ///
    xtitle("Hours Worked per Week") ///
    ytitle("Hourly Wage") ///
    name(ScatterWageHours, replace)
	
// Calculate average wage for union vs non-union members in the 'Operative' occupation
// This addresses question 7 for the 'Operative' occupation
label list occlbl //shows you that 'operatives label = 6'

sort union
by union: summarize wage if occupation == 6 // Mean for non union = 4.67, mean for union = 7.22, mean for undefinded = 5.19 

// Perform Skewness and Kurtosis test for normality on the wage variable
// This addresses part 8: Testing the null hypothesis that wage is normally distributed
sktest wage // The sktest command performs the Skewness and Kurtosis test on the wage variable. The output of this test will provide a p-value, which you can use to decide whether to reject the null hypothesis. If the p-value is less than your chosen significance level (commonly 0.05), you reject the null hypothesis, suggesting that the distribution of wage is not normal. If the p-value is higher, you do not have enough evidence to reject the null hypothesis, suggesting that the wage variable could be normally distributed.

gladder wage

// Generate a new variable that is the natural logarithm of wage
gen ln_wage = ln(wage)

// Perform Skewness and Kurtosis test for normality on the ln_wage variable
// This addresses the test of the null hypothesis that the natural logarithm of wage is normally distributed
sktest ln_wage

log close


