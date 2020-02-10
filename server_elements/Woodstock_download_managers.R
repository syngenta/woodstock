

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


#woodstock_download_managers.R

#The download managers have some really odd code in them, most of this is
#because one of the updated specs of Woodstock was for downloaded CSVs to have
#the metadata used to produce them as a header. This prevents the standard use
#write.csv and hence we have to manually create a list of paramaters and paste a
#csv after it. In my opinion this is messy and the fact that the file name had
#all necessary metadata was a better solution, however it is what it is, I can
#only comment here incase I ever need to edit it

output$DownloadPercentileTable <- downloadHandler(
  filename = #filename argument does not accept paste0() as an input so wrap a
    #function around paste0()
    function() {
      #this anon function creates the file name for downloading, notice it has
      #all the metadata needed to recreate the results.
      locations <- c(input$FOCUSGWSelected, input$FOCUSSWSelected)
      
      return(
        paste0(
          input$RainVsTem,
          "_",
          "Percentiles_LOCATIONS_",
          paste(tolower(locations), collapse = "-"),
          "_SEASON_",
          paste0(input$dateRange, collapse = "-"),
          "_DAA_",
          input$Period2,
          ".csv"
        )
      )
    },
  content = function(file) {
    #write.csv(PercentileTable, file) # Here we use the PercentileTable from
    # the global assignment
    
    #header contains all the metadata again but to be put at the top of the
    #table
    #
    header <- c(
      paste0("Percentile Table"),
      paste0("Parameter:,", input$RainVsTem),
      if (input$RainVsTem == "Rain") {
        c(
          paste0("Observed Rain:,", input$Observed.Rain, "mm"),
          paste0("Observed Rain Percentile:,",
                 round(
                   100 * ecdf(MyTable()$Sum.Rain)(input$Observed.Rain), 2
                 ))
        )
      } else{
        c(
          paste0("Observed Temp:,", input$Observed.Temp, "C"),
          paste0("Observed Temp Percentile:,",
                 round(
                   100 * ecdf(MyTable()$Avg.Temp)(input$Observed.Temp), 2
                 ))
        )
      },
      paste0("DateRange:,", paste0(input$dateRange, collapse = " to ")),
      paste0("Period:,", input$Period2, " days"),
      paste0("Location:,", paste(
        c(input$FOCUSGWSelected, input$FOCUSSWSelected),
        collapse = " & "
      )),
      ""
    )
    
    #table_content is the actual percentile table but captured as a series of
    #character to be past to writeLines.
    table_contents <-
      capture.output(write.csv(PercentileTable(),
                               stdout(),
                               quote = F))
    writeLines(c(header,
                 table_contents),
               file)
    
  }
)


# This allows users to download the aggregated data, again, the file name
# provides the info needed to recreate the results in the app
output$DownloadMyTable <- downloadHandler(
  filename = function() {
    locations <- c(input$FOCUSGWSelected, input$FOCUSSWSelected)
    return(
      paste0(
        input$RainVsTem,
        "_",
        "Agg_Data_LOCATIONS_",
        paste(tolower(locations), collapse = "-"),
        "_SEASON_",
        paste0(input$dateRange, collapse = "-"),
        "_DAA_",
        input$Period2,
        ".csv"
      )
    )
  },
  content = function(file) {
    #write.csv(MyTable(), file)
    
    out <- c(
      paste0("Aggregated Data"),
      paste0("Parameter:,", input$RainVsTem),
      paste0("DateRange:,", paste0(input$dateRange, collapse = " to ")),
      paste0("Period:,", input$Period2, " days"),
      paste0("Location:,", paste(
        c(input$FOCUSGWSelected, input$FOCUSSWSelected),
        collapse = " & "
      )),
      "",
      capture.output(write.csv(MyTable(), stdout(), quote = F))
    )
    writeLines(out, file)
    
  }
)
#same as above but for GlobalPercentiles()
output$DownloadGPS <- downloadHandler(
  filename = function() {
    return(
      paste0(
        input$RainVsTem,
        "_",
        "Global_Percentages_SEASON_",
        paste0(input$dateRange, collapse = "-"),
        "_DAA_",
        input$Period2,
        ".csv"
      )
    )
    
  },
  content = function(file) {
    out <- c(
      paste0("Global Percentile Statistics"),
      paste0("Parameter:,", input$RainVsTem),
      if (input$RainVsTem == "Rain") {
        paste0("Observed Rain:,", input$Observed.Rain, "mm")
      } else{
        paste0("Observed Temp:,", input$Observed.Temp, "C")
      },
      paste0("DateRange:,", paste0(input$dateRange, collapse = " to ")),
      paste0("Period:,", input$Period2, " days"),
      paste0("Location:,", paste(
        c(input$FOCUSGWSelected, input$FOCUSSWSelected),
        collapse = " & "
      )),
      "",
      capture.output(write.csv(GlobalLocations(), stdout(), quote = F))
    )
    writeLines(out, file)
  }
)
