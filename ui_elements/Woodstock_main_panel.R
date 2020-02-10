
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


#Woodstock_main_panel.R

Woodstock_main_panel <- mainPanel(
  tags$head(tags$link(rel = "shortcut icon", href = "favicon.ico")),
  tabsetPanel(
    tabPanel(
      "Intro",
      icon = icon("home"),
      conditionalPanel(condition = "input.RainVsTem == 'Rain'",
                       source("ui_elements/Woodstock_rain_introduction.R")$value),
      conditionalPanel(condition = "input.RainVsTem == 'Temperature'",
                       source("ui_elements/Woodstock_temp_introduction.R")$value)
    ),
    tabPanel(
      "Explanation",
      icon = icon("lightbulb-o"),
      uiOutput("ExplanationImage"),
      tags$head(
        tags$style(
          type = "text/css",
          "#ExplanationImage img {max-width: 100%; width: 100%; height: auto}"
        )
      )
      # img(src="WoodStockExplained.png",with="50%")
    ),
    tabPanel(
      "Data Sources",
      icon = icon("book"),
      h4("Ground Water"),
      "A summary of FOCUS ground water data sources:",
      tableOutput('GWLocations'),
      hr(),
      h4("Surface Water"),
      "A summary of FOCUS surface water data sources:",
      tableOutput('SWLocations')
    ),
    tabPanel(
      "Aggregated Data",
      icon = icon("table"),
      br(),
      
      #use conditional panels to check if the "calculate" buttons has been
      # pressed, Used for user experience if they have skipped instructions
      # *tut tut*
      conditionalPanel(
        condition = "input.Go==0",
        conditionalPanel(condition = "input.RainVsTem == 'Rain'",
                         helpText(
                           "Aggregated data describing cumulative rain will appear here once the \"Calculate\" button has been pressed"
                         )),
        conditionalPanel(condition = "input.RainVsTem == 'Temperature'",
                         helpText(
                           "Aggregated data describing average temperature will appear here once the \"Calculate\" button has been pressed"
                         ))
      ),
      dataTableOutput('MyTable'),
      br(),
      #Download button only appears after button is pressed for UX
      conditionalPanel(
        condition = "input.Go>=1",
        downloadButton("DownloadMyTable", "Download Aggregated Data (.csv)")
      )
    ),
    tabPanel(
      "Graph",
      icon = icon("line-chart"),
      conditionalPanel(
        condition = "input.Go==0",
        helpText(
          "A plot will appear here after the \"Calculate\" button has been pressed"
        )
      ),
      plotOutput("CDF", height = 700)
    ),
    tabPanel(
      "Percentile Statistics",
      icon = icon("percent"),
      #br(),
      h4("Percentiles"),
      conditionalPanel(
        condition = "input.RainVsTem == 'Rain'",
        paste(
          "Below is a table of key percentiles for the distribution of summed rain in the defined period (DAA) between the start and end dates of the season."
        )
      ),
      conditionalPanel(
        condition = "input.RainVsTem == 'Temperature'",
        paste(
          "Below is a table of key percentiles for the distribution of averaged temperature in the defined period (DAA) between the start and end dates of the season."
        )
      ),
      
      tableOutput("PercentileTable"),
      #column(12, align="left",
      conditionalPanel(
        condition = "input.Go>=1",
        downloadLink("DownloadPercentileTable", "Download this table (.csv)")
      ),
      br(),
      br(),
      hr(),
      conditionalPanel(condition = "input.RainVsTem == 'Rain'",
                       h4("Observed Rain")),
      conditionalPanel(condition = "input.RainVsTem == 'Temperature'",
                       h4("Observed Temperature")),
      tableOutput("ObservedTable")
    ),
    tabPanel(
      "Global Percentile Statistics",
      icon = icon("globe"),
      conditionalPanel(condition = "input.RainVsTem == 'Rain'",
                       "This tab provides percentile statistics for the given time parameters and rainfall for every individual location. Approximate time: 30 seconds"
      ),
      conditionalPanel(condition = "input.RainVsTem == 'Temperature'",
                       "This tab provides percentile statistics for the given time parameters and temperature for every individual location. Approximate time: 30 seconds"
                       
      ),
      br(),
      conditionalPanel(condition = "!($('html').hasClass('shiny-busy'))",
                       actionButton("GPSCalc", "Calculate")),
      
      tableOutput("GPS"),
      conditionalPanel(
        condition = "input.GPSCalc>=1 && !($('html').hasClass('shiny-busy'))",
        downloadButton("DownloadGPS", "Download this table (.csv)")
      )
    )
    
  ))
