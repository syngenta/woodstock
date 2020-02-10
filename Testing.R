#This script is used for testing the function Collect_Sum_Rain_CSVAllStations.R
#ability to deal with leap years. This is being done as possible unexpected behavior is being found.
#It is not used in the app and if you're reading this it means i forgot to remove it from the release.
#Congrats, you found my code.

source("~/Test Application/TRfT V1.2/shiny/www/Collect_Sum_Rain_CSVAllStations.R")

a <- Collect.Sum.Rain.CSV.AllFiles(MetFilePath = "~/Test Application/TRfT V1.2/shiny/www/MergedFiles/AllGW.csv",
                                   Start.Date = as.Date("2017-02-26"),
                                   End.Date = as.Date("2017-03-06"),
                                   Period = 3,
                                   Stations.Selected = "CHAT-M")

#Using a year with a leap year as your start date will introduce an NA row in
#non leap years (small bug), and will also give a off by one error in the 
#indexing of Sum.Rain (big bug). Correct behavior for leap years

#Using a non leap year as a start date leads to missing leap year dates in leap#
#but correct Sum.Rain minus the cut off. Correct behavior for non leap years

#Proposed solution: rewrite function to calculate a date range for every year 
#in range and then cbind results. The advantage of this is that it will still 
#work for an arbritary time period however it might be slower than the current 
#method

source("~/Test Application/TRfT V1.2/shiny/www/Collect_Sum_Rain_CSVAllStationsLeapYear.R")

L.Y. <- Collect.Sum.Rain.CSV.AllFilesLeapyear(MetFilePath = "~/Test Application/TRfT V1.2/shiny/www/MergedFiles/AllGW.csv",
                                   Start.Date = as.Date("2016-12-29"),
                                   End.Date = as.Date("2017-01-03"),
                                   Period = 3,
                                   Stations.Selected = "CHAT-M")
N.L.Y. <- Collect.Sum.Rain.CSV.AllFilesLeapyear(MetFilePath = "~/Test Application/TRfT V1.2/shiny/www/MergedFiles/AllGW.csv",
                                              Start.Date = as.Date("2017-12-29"),
                                              End.Date = as.Date("2018-01-03"),
                                              Period = 3,
                                              Stations.Selected = "CHAT-M")
all(L.Y.==N.L.Y.)
#works as intended for non leap year start dates
