

# Copyright Syngenta Limited 20nn
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or (at
#                                                                    your option) any later version.
#
# THIS PROGRAM IS MADE AVAILABLE FOR DISTRIBUTION WITHOUT ANY FORM OF WARRANTY TO THE
# EXTENT PERMITTED BY APPLICABLE LAW.  THE COPYRIGHT HOLDER PROVIDES THE PROGRAM \"AS IS\"
# WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM LIES
# WITH THE USER.  SHOULD THE PROGRAM PROVE DEFECTIVE IN ANY WAY, THE USER ASSUMES THE
# COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION. THE COPYRIGHT HOLDER IS NOT
# RESPONSIBLE FOR ANY AMENDMENT, MODIFICATION OR OTHER ENHANCEMENT MADE TO THE PROGRAM
# BY ANY USER WHO REDISTRIBUTES THE PROGRAM SO AMENDED, MODIFIED OR ENHANCED.
#
# IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL THE
# COPYRIGHT HOLDER BE LIABLE TO ANY USER FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL,
# INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE
# PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE
# OR LOSSES SUSTAINED BY THE USER OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO
# OPERATE WITH ANY OTHER PROGRAMS), EVEN IF SUCH HOLDER HAS BEEN ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGES.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.



calculate_average_temp <-
  function(met_data,
           Start.Date,
           End.Date,
           Period = as.numeric(End.Date - Start.Date) + 1,
           Stations.Selected) {
    #------------
    # Description
    #------------
    
    # This function provides a table that contains the cumulative precipitation (mm) in a givin time period that lie between a date range for every year passed to it in the Met file
    # It defaults to thinking the period is the diference between the End and Start Date,
    # Example: Collect.Sum.Rain(Met,as.Date("1940-02-13"),as.Date("1940-02-30")) assumes you are only interested in that 17 day period but
    #  Collect.Sum.Rain(Met,as.Date("1940-02-13"),as.Date("1940-02-30"),15) would give you the 3 different 15 day time perios in those 17 days
    
    #-------
    # Checks
    #-------
    
    
    if (Period > (as.numeric(End.Date - Start.Date) + 1)) {
      stop(
        "The number of consecutive days you want to look at is greater than range of dates provided, either increase your value of Period, or increase the range of dates"
      )
    }
    if (Start.Date >= End.Date) {
      stop("Please use an end date that is after the start date")
    }
    if (length(Stations.Selected) == 0) {
      stop("Please select at least one Location")
    }
    
    #---------
    # Read in File
    #---------
    
    Met <- met_data %>%
      dplyr::filter(Station %in% Stations.Selected)
    Met$Date <- as.POSIXct(Met$Date)
    
    
    OutDF <- data.frame(
      Year = integer(),
      Start.Date = as.Date(character()),
      End.Date = as.Date(character()),
      Avg.Temp = double(),
      Location = character(),
      stringsAsFactors = FALSE
    )
    
    for (loc in Stations.Selected) {
      MetTemp <- Met %>%
        dplyr::filter(Station == loc)
      Year.Range <-
        year(min(MetTemp$Date)):year(max(MetTemp$Date)) #define how many years of data are in Met file
      
      
      #-------------------
      # This next chunk of code aims to pull out the range we are interested for each year, then break it down into period length chunks
      #--------------------
      
      for (i in 1:length(Year.Range)) {
        #S.Date is the start date in the year we are currently iterating over
        S.Date <- Start.Date - years(year(Start.Date) - Year.Range[i])
        #End Date, we do it this way to have correct behavior when start and end dates go over new year
        E.Date <- End.Date - years(year(Start.Date) - Year.Range[i])
        date.sequence <-
          seq(S.Date, E.Date, by = "day") #get a sequence of dates between S.Date and E.Date, note that this will include leap days
        num.of.periods.yearly <-
          length(date.sequence) - (Period - 1) #Calculate how many periods can lie in a date range,
        
        #Extract all rain data between these dates
        Temp <-
          MetTemp[MetTemp$Date >= as.POSIXct(S.Date) &
                    MetTemp$Date <= as.POSIXct(E.Date), ]$Temp_C
        
        
        #This part is more complicated we insert into the relevant chunk of the output vector the sum of the Rain data broken down into period length chunks
            avgTemp <-
          sapply(1:num.of.periods.yearly, function(x, Temp, Period) {
            mean(Temp[x:(x + (Period - 1))])
          }, Temp, Period)
        tempOut <- data.frame(
          Year = Year.Range[i],
          Start.Date = date.sequence[1:num.of.periods.yearly],
          End.Date = date.sequence[1:num.of.periods.yearly] + (Period - 1),
          Avg.Temp = avgTemp,
          Location = loc
        )
        OutDF <- rbind(OutDF, tempOut)
        
      }
    }
    #---------
    # Outputs
    #---------
    return(
      OutDF[(year(OutDF$End.Date) <= max(Year.Range)) &
              (!is.na(OutDF$Avg.Temp)), ] #filter out any end dates after the end of the data)
    )
  }
