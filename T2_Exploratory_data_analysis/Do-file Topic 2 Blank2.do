*** code_topic2.do
*** A selection of Stata commands from the 
*** Topic 2 lecture notes. 
********************************************
*** Setting working directory
********************************************

*cd "C:\Users\jz519\OneDrive - University of Exeter\Desktop\BEE2032\WEEK 2"
cd "Your working directory"

********************************************
*** Loading the dataset
********************************************
use pen01aL3.dta, clear

********************************************
*** take a brief look at the data
********************************************

** browse

** summarize

** codebook


********************************************
*** histograms
********************************************

** simple histogram (default settings)

** set bin width and start point

** number of bins

** overlay normal distribution


********************************************
*** kernel density estimation
********************************************

** simple kernel density (default settings - epanechnikov)


** normal kernel


** triangular kernel


** histogram with kdensity overlay


** histogram with normal law overlay

 
********************************************
*** cumulative distribution
********************************************

* create new variable holding the cumulative distribution
cumul lnw, generate(clnw)

* make graph
summarize lnw
return list
scalar meanlnw=r(mean)
scalar stdlnw=r(sd)

twoway (line clnw lnw, sort) (function normal((x-meanlnw)/stdlnw), range(0 5) legend( label( 1 "log wage: empirical distribution function") label(2 "normal distribution")) )

*any other method?


********************************************
*** Quantile-quantile plot for men and women
********************************************

* quantile to normal plot


* qqplot



* x ~ standard normal distribution

* y ~ positive skewness

* z ~ negative skewness 

* t ~ positive kurtosis

* create two new variable holding the log wage, 
* one for men, one for women:


* quantile-quantile plot


********************************************
*** scatterplots
********************************************



** with linear fit

** with quadratic fit

** showing the observation number:

* first generate a variable holding the obs number:


* then turn off the symbol in the scatter plot ('i' for invisible) and use the number as label:



** display the value of a third variable as the size of the markers:
* msymbol(oh) --> 'oh' refers to small hollow circle



** display the scatterplot with a linear fit

* run the two lines together when there is the /// sign, the /// sign must always be preceeded by a space

** display the scatterplot with a quadratic fit


********************************************
*** Normality tests
********************************************

** null hypothesis: variable is normally distributed (skewness = 0, kurtosis = 3)

** alternative hypothesis: variables is not normally distributed


* also: 



* looking at transformations of the data

* testing transformations of the data

	
********************************************
*** Using returned results
********************************************

** see what's there:

** Jarque-Bera test statistic:



