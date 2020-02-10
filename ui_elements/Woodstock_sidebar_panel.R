
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


#Woodstock_sidebar_panel.R
#
Woodstock_sidebar_panel <- sidebarPanel(
  
  h4("Climate Data"),
  
  radioGroupButtons('RainVsTem',
                    label = "Look at rain or temperature data:",
                    choices = c("Cumulative Rain" = "Rain", "Average Temperature" = "Temperature"),
                    selected = "Rain",
                    justified = T,
                    checkIcon = list(yes=icon("check-circle"),no=icon("times-circle")),
                    size="normal"
                    #individual = T
                    #checkIcon=list(yes=icon("yes"),no=icon("rebel"))
  ),
  h4("Locations"),
  # Ground water and Surface Water Locations are kept seperate only from a
  # user experience perspective. In the back end they are all treated
  # identically.
  column(
    6,
    checkboxGroupInput(
      'FOCUSGWSelected',
      label = "Select Ground Water Scenarios:",
      choices = c(
        "Châteaudun (N. France)" = "CHAT-M",
        "Hamburg (Germany)" = "HAMB-M",
        "Jokioinen (Finland)" = "JOKI-M",
        "Kremsmünster (Austria)" = "KREM-M",
        "Okehampton (U.K.)" = "OKEH-M",
        "Piacenza (Italy)" = "PIAC-M",
        "Porto (Portugal)" = "PORT-M",
        "Sevilla (Spain)" = "SEVI-M",
        "Thiva (Greece)" = "THIV-M"
      ),
      selected = c("CHAT-M", "HAMB-M") # have two selected
      # to show 2 can be selected
      
    )
  ),
  column(
    6,
    checkboxGroupInput(
      'FOCUSSWSelected',
      label = "Select Surface Water Scenarios:",
      choices = c(
        "D1 (Sweden)" = "D1LANNA",
        "D2 (U.K.)" = "D2BRIMS",
        "D3 (Netherlands)" = "D3VREDE",
        "D4 (Denmark)" = "D4SKOUS",
        "D5 (France)" = "D5JAILL",
        "D6 (Greece)" = "D6THEBE",
        "R1 (Germany)" = "R1NOIRR",
        "R2 (Portugal)" = "R2NOIRR",
        "R3 (Italy)" = "R3NOIRR",
        "R4 (France)" = "R4NOIRR"
      ),
      selected = c("D1LANNA", "D2BRIMS") #have two more selected to show you
      #can have selections across SW & GW
    )
  ),
  helpText(
    "Please Note: When combining D & R scenarios, bear in mind that R scenarios have more years of data. This leads to R scenarios being overrepresented when combined with D scenarios"
  ),
  hr(),
  h4("Time Parameters"),
  dateRangeInput(
    'dateRange',
    label = 'Date range input:',
    start = as.Date("2020-01-01"),
    end = as.Date("2020-12-31"),
    min = as.Date("2015-01-01"),
    max = as.Date("2021-12-31"),
    format = "M-dd" # to show that year doesn't matter
  ),
  #checkboxInput('hasPeriod',
  #              "Set a custom time period?",
  #              value = F),
  #conditionalPanel(condition = "input.hasPeriod==true",
  uiOutput('Period2')
  #)
  ,
  actionButton("Go", "Calculate", icon = icon("refresh")),
  #uses  'refresh'
  #icon to show that it needs to be pressed each time user inputs change
  
  hr(),
  conditionalPanel(
    condition = "input.RainVsTem == 'Rain'",
    h4("Rain Parameters (Optional)"),
    numericInput(
      'Observed.Rain',
      label = "Give rainfall (mm) for time period of interest",
      value = 20,
      min = 0,
      max = 500
    )
  ),
  conditionalPanel(
    condition = "input.RainVsTem == 'Temperature'",
    h4("Temperature Parameters (Optional)"),
    numericInput(
      'Observed.Temp',
      label = "Give average temperature (C) for time period of interest",
      value = 10,
      min = -20,
      max = 100
    )
  ),
  textInput(
    'PercentilesRaw',
    label = "Provide percentiles of interest (seperated by a comma)",
    value = "25,50,75",
    placeholder = "0,10,25,50,75,90,100"
  ),
  
  #code used to change themes, taken from shinythemes theme selector
  conditionalPanel(condition="input.RainVsTem=='Never_trig'",
                   selectInput("shinytheme-selector",NULL,c("flatly","united"),selectize = FALSE)),
  tags$script(
    "$('#shinytheme-selector')
    .on('change', function(el) {
    var allThemes = $(this).find('option').map(function() {
    if ($(this).val() === 'default')
    return 'bootstrap';
    else
    return $(this).val();
    });
    // Find the current theme
    var curTheme = el.target.value;
    if (curTheme === 'default') {
    curTheme = 'bootstrap';
    curThemePath = 'shared/bootstrap/css/bootstrap.min.css';
    } else {
    curThemePath = 'shinythemes/css/' + curTheme + '.min.css';
    }
    // Find the <link> element with that has the bootstrap.css
    var $link = $('link').filter(function() {
    var theme = $(this).attr('href');
    theme = theme.replace(/^.*\\//, '').replace(/(\\.min)?\\.css$/, '');
    return $.inArray(theme, allThemes) !== -1;
    });
    // Set it to the correct path
    $link.attr('href', curThemePath);
    });"
        
  )
)
