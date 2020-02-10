
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


#Woodstock_reactive_values.R


MyTable <- eventReactive(
  {input$Go
    input$RainVsTem
  }, {
  validate(need(
    length(input$FOCUSGWSelected) != 0 |
      length(input$FOCUSSWSelected) != 0
    ,
    "Please select at least one location"
  ))
  withProgress(
    message = "Calculating",
    min = 0,
    max = 1,
    expr = {
      setProgress(value = 1)
      if (input$RainVsTem == "Rain") {
        calculate_cumulative_rain(
          met_data=met_data,
          Start.Date = as.Date(input$dateRange[1]),
          End.Date =  as.Date(input$dateRange[2]) + (input$Period2 - 1),
          # Please note that the term after the plus sign has been added in V1.2,
          #the reason this has been added was due to a change in spec saying
          #that rather than being interested in all time periods of a certain
          #length WITHIN a date range, we are now interested in all time periods
          #with a START DATE within that range. As I had already optimised the
          #code for the original spec, I have edited the input to have the
          #desired effect by editing the end date to be the largest date that
          #would be used with the new spec
          
          Period =  input$Period2,
          #As we have a reactive UI, if no period is specified, it defaults to the whole season
          Stations.Selected =
            c(input$FOCUSGWSelected, input$FOCUSSWSelected)
        )
      } else if (input$RainVsTem == "Temperature") {
        calculate_average_temp(
          met_data=met_data,
          Start.Date = as.Date(input$dateRange[1]),
          End.Date =  as.Date(input$dateRange[2]) + (input$Period2 - 1),
          # Please note that the term after the plus sign has been added in V1.2,
          #the reason this has been added was due to a change in spec saying
          #that rather than being interested in all time periods of a certain
          #length WITHIN a date range, we are now interested in all time periods
          #with a START DATE within that range. As I had already optimised the
          #code for the original spec, I have edited the input to have the
          #desired effect by editing the end date to be the largest date that
          #would be used with the new spec
          
          Period =  input$Period2,
          #As we have a reactive UI, if no period is specified, it defaults to the whole season
          Stations.Selected =
            c(input$FOCUSGWSelected, input$FOCUSSWSelected)
        )
        
      }
    }
  )
  
})

PercentileTable <- eventReactive(MyTable(), {
  Percentiles <-
    c(0, 5, 10, 20, 25, 50, 75, 80, 90, 95, 100) #Key values, this can be edited
  PercentileNames <-
    paste0(Percentiles, "%") #Human friendly names
  
  
  if (input$RainVsTem == "Rain") {
    PercentileValues <-
      quantile(MyTable()$Sum.Rain, Percentiles / 100, names = F)
    PercentileTable <-
      t(
        # create a horizontal table for human friendly output
        data.frame(
          Percentile = as.character(Percentiles),
          `Rainfall (mm)` = PercentileValues
          ,
          check.names = F
        )
      )
    
  } else if (input$RainVsTem == "Temperature") {
    PercentileValues <-
      quantile(MyTable()$Avg.Temp, Percentiles / 100, names = F)
    PercentileTable <-
      t(
        # create a horizontal table for human friendly output
        data.frame(
          Percentile = as.character(Percentiles),
          `Temperature (C)` = PercentileValues
          ,
          check.names = F
        )
      )
    
    
  }
  colnames(PercentileTable) <- PercentileNames
  PercentileTable
})

GlobalLocations <- eventReactive(input$GPSCalc, {
  disable("GPSCalc")
  #read a template that is to be filled out.
  GlobalLocations <-
    read.csv(
      "data/GlobalPercentilesTemplate.csv",
      check.names = F,
      na.strings = "NA",
      encoding = "UTF-8"
    )
  withProgress(message = "Calculating Global Percentiles", value = 0, {
    if (input$RainVsTem == "Rain") {
      for (i in 1:nrow(GlobalLocations)) {
        # if (GlobalLocations[i, 'Group'] == "G.W.") {
        #   GWvsSW <- "AllGW"
        # } else{
        #   GWvsSW <- "AllSW"
        # }
        GlobalLocations[i, 5:15] <- quantile(
          calculate_cumulative_rain(
            #MetFilePath = paste0("www/MergedFiles/both.csv"),
            met_data = met_data,
            Start.Date = input$dateRange[1],
            End.Date = as.Date(input$dateRange[2]) + (input$Period2 - 1),
            Period = input$Period2,
            Stations.Selected = GlobalLocations[i, 'Station']
          )$Sum.Rain,
          c(0, 0.05, 0.1, 0.2, 0.25, 0.5, 0.75, 0.8, 0.9, 0.95, 1)
        )
        
        incProgress(1 / 19, detail = paste("Doing Location", i))
      }
    } else if (input$RainVsTem == "Temperature") {
      for (i in 1:nrow(GlobalLocations)) {
        GlobalLocations[i, 5:15] <- quantile(
         calculate_average_temp(
            met_data = met_data,
            Start.Date = input$dateRange[1],
            End.Date = as.Date(input$dateRange[2]) + (input$Period2 - 1),
            Period = input$Period2,
            Stations.Selected = GlobalLocations[i, 'Station']
          )$Avg.Temp,
          c(0, 0.05, 0.1, 0.2, 0.25, 0.5, 0.75, 0.8, 0.9, 0.95, 1)
        )
        
        incProgress(1 / 19, detail = paste("Doing Location", i))
      }
    }
  })
  enable("GPSCalc")
  GlobalLocations
})
