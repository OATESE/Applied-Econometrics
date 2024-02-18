*** solutions to the topic 1 exercises
*** 
**********************************************

pwd
** adjust these as necessary
cd "/Users/ss1496/Dropbox/Teaching/Applied Econometrics/Topic1"
log using exercise1.log


*********************************************
*** Basic commands and syntax
*********************************************


** use the auto data and clear memory:
sysuse auto, clear

** mpg of least expensive/most expensive car:
sort price
list price mpg in 1 /* least expensive */
list price mpg in 74 
list price mpg in l /* (lower case letter "l" for "last") most expensive */
* note that there are various other ways of doing this, for instance: 
sort price
gen id = _n
list price mpg if _n ==_N 
/* assign order number based on the previous sort price */
/*list the observations for which the obersvation number if equal to the maximum number of observations = the last observation */

** How many foreign vehicles? 
count if foreign == 1
* or
tabulate foreign
* or 
summarize foreign
/* the proportion of foreign vehicles is 
	equal to */
/* there are cars in total */
* this last solution is not a good way of doing this.

** sort according to mpg:
sort mpg
** is the sort order unique?
codebook mpg
* No it isn't. There are 74 cars but only 21 distinct values of mpg */

** generate new variable "domestic":
generate domestic= 1 - foreign
drop domestic

generate domestic=1 if foreign == 0
replace domestic = 0 if foreign ==1


** sort in order of mpg and price
sort mpg price

** generate new variable:
generate obsno10 = _n + 10

*********************************************
*** Variable labels
*********************************************

** clear the memory in case we have other data loaded
clear 
use pen01aL3

** variable labels
generate wage=exp(lnw)

describe wage

label variable wage "Hourly nominal wage"

describe wage

*********************************************
*** Value labels 
*********************************************

** degree variable:
generate degree = 1 if ed >= 17
replace degree = 0 if ed < 17

tab degree

** box plot
graph hbox wage, over(degree, total)
* compare this to: 


** value labels:
* first define a value label: 
label define degr 1 "Degree" 0 "No degree" // defining the rule for labeling the values
* now apply it to the values in the variable 'degree':
label values degree degr // Label the values of the variable degree applying the rule "degr"

* see if we've done it correctly:
tab degree

** box plot again
graph hbox wage, over(degree, total)

*********************************************
*** Stata functions
*********************************************

** Stata funcions
help functions

* standard normal density
display normalden(0.5)

* this is what chi2(2df) looks like:
twoway (function y = chi2den(2,x), range(0 10)), xline(5) xlabel(0(1)10)

* what is the probability that chi2(2) > 5?
display chi2tail(2,5)

** Standardisation: (x-mu/sigma)
sum wage 
* your variable name may differ
* mean is 20.65072, standard deviation is  12.20505

gen stdwage = (wage - 20.65072)/12.20505

drop stdwage

sum wage
return list

gen stdwage= (wage - r(mean))/r(sd)
* not a great solution; there are better ways to go about this which we 
* will cover soon.

** variable holding the sign of another variable:
* first: creating a variable which has some negative values:
generate negpos=_n - 70
sum negpos

* next: new variable holding the sign of negpos:
generate signegpos= sign(negpos)

list negpos signegpos
* sign is equal to -1 for negative, 0 for 0, and +1 for positive.


*********************************************
*** Precision puzzle
*********************************************

clear 
set obs 10

generate x1=2
generate x2=0.2

count if x1 ==2
count if x2== 0.2

* We encounter a binary rounding error. This is a problem with variables stored in floating-point precision (which is the default). Stata uses double precision for all its internal calculations. 

* to get around this: 
count if x2==float(0.2)

* or we can use double precision for our variable:
generate double x3=0.2
count if x3== 0.2

log close


