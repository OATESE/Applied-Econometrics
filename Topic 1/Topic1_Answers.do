sysuse auto, clear  // Load the auto dataset

sort price  // Sort the data by price

// Retrieve the mpg of the cheapest car
di "Mileage per gallon of the cheapest car: " mpg[1]

// Retrieve the mpg of the most expensive car
di "Mileage per gallon of the most expensive car: " mpg[_N]

//Find out how many foreign vehicles are in the dataset
codebook foreign //Find which numeric values assigned to foreign
count if foreign == 1 //22 cars

//Sort the data in order of mpg, is this sort order unique
sort mpg
duplicates report mpg // The presence of duplicates (where "copies" is greater than 1) indicates that the sort order of the dataset based on mpg is not unique. This means that multiple cars have the same mpg value, and therefore, sorting by mpg alone does not result in a uniquely ordered dataset. To create a unique sort order, you might need to sort by additional variables (for example, mpg and price).

//  Generate a new variable called domestic which is equal to one if the vehicle is domestic and zero if the vehicle is foreign.
gen domestic = foreign == 0

// Sort the data in order of miles per gallon and price. Generate a new variable called obsno10 holding the observation number + 10.
sort mpg price
gen obsno10 = _n + 10


// Part 2
// set wd to where the data is 
clear
cd "/Users/elliottoates/Library/CloudStorage/OneDrive-UniversityofExeter/Applied Econometrics/Topic 1"
use pen01aL3.dta

// Generate the nominal hourly wage from the log wage
gen wage = exp(lnw)
// label variable wage
label variable wage "Nominal Hourly Wage"
//check
describe wage

//Generate another variable which equals 1 if a person holds a university degree, and 0 otherwise
gen degree = ed >= 17

//tabulate
tabulate degree
//labels
label define degree_label 1 "Degree" 0 "No Degree"
label values degree degree_label

//box plot 
graph hbox wage, over(degree)


//stata functions part
display normalden(0.5) //Standard normal density at 0.5

display chi2tail(2, 5) //  is the probability that a χ2 distributed random variable with 2 degrees of freedom is greater than 5?

egen std_varname = std(wage) //how to standardise a variable

gen sign_varname = sign(std_varname) //variable holding sign of another variable 








