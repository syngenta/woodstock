
# Copyright Syngenta Limited 2020
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

#Woodstock_outputs.R

#display calculated data in MyTable()
output$MyTable <-
  DT::renderDataTable(options = list(
    pageLength = 10,
    search.smart = T,
    searching = FALSE
  ), {
    MyTable() # Shows the latest data generated since last click of "Calculate"
  })

#generate and display CDF graphs, functions Make_X_Graph() are found in
# server_elements in their respective files
output$CDF <- renderPlot(bg = "transparent", {
  if (input$RainVsTem == "Rain") {
    Make_Rain_Graph(input, MyTable = MyTable())
  } else if (input$RainVsTem == "Temperature") {
    Make_Temp_Graph(input, MyTable = MyTable())
  }
})

output$PercentileTable <- renderTable(rownames = T, {
  PercentileTable() #found in reactive_values
})


output$ObservedTable <- renderTable({
  if (input$RainVsTem == "Rain") {
    Obs.Percentile <- ecdf(MyTable()$Sum.Rain)(input$Observed.Rain)
    data.frame(
      Property = "Observed Rain",
      Value = paste(input$Observed.Rain, "mm"),
      Percentile = paste0(format(
        round(Obs.Percentile * 100, 2), nsmall = 2
      ),
      "%")
    )
  } else if (input$RainVsTem == "Temperature") {
    Obs.Percentile <- ecdf(MyTable()$Avg.Temp)(input$Observed.Temp)
    data.frame(
      Property = "Observed Temperature",
      Value = paste(input$Observed.Temp, "C"),
      Percentile = paste0(format(
        round(Obs.Percentile * 100, 2), nsmall = 2
      ),
      "%")
    )
  }
})

output$GPS <- renderTable({
  GlobalLocations() #found in reactive_values
})

output$GWLocations <-
  renderTable(read.csv(
    "data/GWLocations.csv",
    check.names = F,
    encoding = "UTF-8" #because of accent characters
  ))
output$SWLocations <-
  renderTable(read.csv(
    "data/SWLocations.csv",
    check.names = F,
    encoding = "UTF-8"
  ))
