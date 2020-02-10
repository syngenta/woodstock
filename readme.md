# Woodstock

This is the git repository for Woodstock. Woodstock (or The Rainfall Tool to some) is a tool developed to support crop protection risk assessments for birds and mammals. Woodstock does this by providing percentile statistics about rain and temperature for time periods that occur in the standard FOCUS weather data files (FOCUS Groundwater and Surface Water scenarios).

An example question Woodstock can be used to answer:

> "In our seed trial in Germany, we had 10mm of rain in a 5 day period, is this an atypical amount of rain to expect?"

It useful to be able to answer these types of questions as studies become unconservative if too much rain falls as rain can wash off seed coating and hence reduce exposure.

## Woodstock Usage and Distribution

Woodstock is and will be distributed on a free to use basis subject to the conditions stated in the Software Licence. You must agree to these terms before downloading, installing, distributing or using Woodstock


## How do I get Woodstock?

A copy of woodstock is hosted on [ShinyApps.io](https://syngenta.shinyapps.io/woodstock/) . If the link is not working, please raise an issue on the github issues page. You can also contact open.publishing@syngenta.com

Alternativly you can clone this repository and run Woodstock locally with a local install of R

## How does Woodstock work?

At its core, Woodtock has two useful R functions; calculate_cumulative_rain and calculate_average_temp. The rest of the app is a wrapper and explanation for that function. This function takes:

* A date range (of less than a year), this represents a sowing period or just a range of dates that the user is interested
* A day period, this represents the number of consecutive days the user is interested for rainfall or temperature
* A path to a data file that contains weather data
* A collection of met stations found in the weather data to filter

The function returns a data frame where rows represent a day period that lies between the date range for a met station with either the cumulative rain or average temperature. A detailed example can be found in app on the "Explanation" tab.


